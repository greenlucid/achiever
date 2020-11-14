/**
 * @authors: @greenlucid
 * @reviewers: []
 * @auditors: []
 * @bounties: []
 * @deployments: []
 * SPDX-License-Identifier: Licenses are bad
 */

pragma solidity >=0.7;

import "./IArbitrator.sol";
import "./IArbitrable.sol";
import "./IEvidence.sol";
import "./CappedMath.sol";

/**
 * @title Achiever
 * This contract allows users to make vows and put their money where their mouth is.
 * General info in github.com/greenlucid/achiever
 * Data about vows is referenced in a link.
 * Users may upload evidence and discuss via links.
 * This contract holds a list of vows.
 */

contract Achiever is IEvidence, IArbitrable {
    
    using CappedMath for uint;
    
    /* Enums */
    
    enum VowStatus {
        Clean,
        Challenged,
        Dispute,
        Failed,
        Achieved
    }
    
    enum DisputeStatus {
        Pending,
        Disputing,
        ToFail,
        ToAchieve,
        CrowdfundFail,
        CrowdfundAchieve,
        Ruled
    }
    
    /* Structs */
    
    struct Vow {
        address achiever;
        uint8 vowStatus;
        uint64 zeroDay; // Vow is supposed to be achieved by this time
        uint64 disputeId;
        bool disputed; // init false
        bool paid; // init false
        uint bond; // initial amount vower staked
    }
    
    struct ADispute {
        uint64 vowId;
        uint64 nContributorsAchiever;
        uint64 nContributorsChallenger;
        uint32 currentRound; // starts at 0
        uint8 disputeStatus;
        uint externalDisputeId; // this is the one Arbitrator undertands
        uint currentAchiever;
        uint currentChallenger;
        uint treasure; // this is delivered to winner
        uint lastStake; // this is stored to calc the cost of the next stake
        uint lastCost; // this is stored to calc the increase in cost for everything
    }
    
    /* Settings */
    
    uint RULING_OPTIONS = 2; // Non-zero rulings (YES // NO)
    uint CLEAR_PERIOD = 7 days; // Days until a clean promise can be achieved
    uint GRACE_PERIOD = 3 days;  // Days until arbitration can start from zero_day
    uint COUNTER_PERCENT = 2500; // Counter is a stake challenger makes, counter_percent relates to bond.
    uint WINNER_DISCOUNT = 3000; // Percent of lastStake that is paid by previous round winner
    uint MINIMUM_CONTRIBUTION = 0.001 ether; // To halt spam in appeals
    uint MINIMUM_VOW = 0.1 ether; // To halt spam creating vows
    uint MULTIPLIER_TO_DIV = 10000;
    
    bytes public ARBITRATOR_EXTRA_DATA = abi.encodePacked(uint256(0), uint256(3));
    
    IArbitrator public arbitrator;
    
    /* Data and Lists */
    
    Vow[] public vows;
    ADispute[] public disputes;
    
    mapping(uint => mapping(address => uint)) public expensesAchiever;
    mapping(uint => mapping(address => uint)) public expensesChallenger;
    mapping(uint => mapping(uint => address)) public contributorsAchiever;
    mapping(uint => mapping(uint => address)) public contributorsChallenger;
    
    /* Events */
    
    event VowMade(address _achiever, uint _vowId, uint _bond, string _vowfile);
    event VowChallenged(address _challenger, uint _vowId, uint _internalDispute, string _claim);
    
    event VowDisputeStarted(uint _vowId, uint _internalDispute, uint _externalDispute);
    
    event VowFundedFail(address _contributor, uint _vowId, uint _amount);
    event VowFundedAchieve(address _contributor, uint _vowId, uint _amount);
    
    event VowAppealed(uint _vowId, uint _internalDispute, uint _externalDispute);
    
    event VowFailed(address _achiever, uint _vowId);
    event VowAchieved(address _achiever, uint _vowId);
    
    /* Private functions */
    
    function _payClean(Vow memory _vow) private {
        payable(_vow.achiever).transfer(_vow.bond);
    }
    
    function _payComplex(Vow memory _vow) private {
        // This infringes DRY
        if (_vow.vowStatus == uint8(VowStatus.Achieved) ) {
            _payDistAchiever(_vow);
        } else {
            _payDistChallenger(_vow);
        }
    }
    
    function _payDistAchiever(Vow memory _vow) private {
        uint disputeId = _vow.disputeId;
        ADispute memory dispute = disputes[disputeId];
        uint end = dispute.nContributorsAchiever;
        uint totalAchiever = totalAchieverExpenses(disputeId);
        
        for(uint i = 0; i < end; i++) {
            address contributor = contributorsAchiever[disputeId][i];
            uint contribution = expensesAchiever[disputeId][contributor];
            uint award = (contribution * dispute.treasure) / totalAchiever;
            payable(contributor).transfer(award);
        }
    }
    
    function _payDistChallenger(Vow memory _vow) private {
        uint disputeId = _vow.disputeId;
        ADispute memory dispute = disputes[disputeId];
        uint end = dispute.nContributorsChallenger;
        uint totalChallenger = totalChallengerExpenses(disputeId);
        
        for(uint i = 0; i < end; i++) {
            address contributor = contributorsChallenger[disputeId][i];
            uint contribution = expensesChallenger[disputeId][contributor];
            uint award = (contribution * dispute.treasure) / totalChallenger;
            payable(contributor).transfer(award);
        }
    }
    
    function _createVow( address _achiever, uint _bond, uint _zeroDay) private returns(uint) {
            
        uint vowsLength = vows.length;
        
        Vow memory vow = Vow({
            achiever: _achiever,
            vowStatus: uint8(VowStatus.Clean),
            zeroDay: uint64(_zeroDay),
            disputeId: 0, // Untrusted value
            disputed: false,
            paid: false,
            bond: _bond
        });
        
        vows.push(vow);
        
        return vowsLength;
    }
    
    function _createDispute( uint _vowId, uint _counter, uint _disputeCost,
        address _challenger) private returns(uint) {
            
        Vow memory vow = vows[_vowId];
        
        ADispute memory newDispute = ADispute({
            vowId: uint64(_vowId),
            nContributorsAchiever: uint64(1),
            nContributorsChallenger: uint64(1),
            currentRound: uint32(0),
            disputeStatus: uint8(DisputeStatus.Pending),
            externalDisputeId: 0, // externalDisputeId is still unknown
            currentAchiever: 0, // currentAchiever
            currentChallenger: 0, // currentChallenger
            treasure: vow.bond + _counter, // treasure
            lastStake: _counter, // lastStake starts at counter
            lastCost: _disputeCost
            });
        
        uint disputesLength = disputes.length;
        expensesAchiever[disputesLength][vow.achiever] += vow.bond;
        expensesChallenger[disputesLength][_challenger] += _counter + _disputeCost;
        contributorsAchiever[disputesLength][0] = vow.achiever;
        contributorsChallenger[disputesLength][0] = _challenger;
        disputes.push(newDispute);
        return (disputesLength);
    }
    
    function _fetchDisputeStatus(ADispute memory dispute) private view returns(IArbitrator.DisputeStatus) {
        uint externalId = dispute.externalDisputeId;
        return(arbitrator.disputeStatus(externalId));
    }
    
    function _fetchCurrentRuling(ADispute memory dispute) private view returns(uint) {
        uint externalId = dispute.externalDisputeId;
        return(arbitrator.currentRuling(externalId));
    }
    
    function _fetchAppealPeriod(ADispute memory dispute) private view returns(uint, uint) {
        return(arbitrator.appealPeriod(dispute.externalDisputeId));
    }
    
    function _fundAchiever(uint _disputeID, uint _amount, address _contributor) private {
        // check if contributor had already contibuted. update nContributorsAchiever and add address if not.  TRUSTED!
        ADispute storage dispute = disputes[_disputeID];
        if (!hasContributedAchiever(_disputeID, _contributor)){
            contributorsAchiever[_disputeID][dispute.nContributorsAchiever] = _contributor;
            dispute.nContributorsAchiever++;
        }
        expensesAchiever[_disputeID][_contributor] += _amount;
        // update treasure.
        dispute.treasure += _amount;
        // update currentAchiever
        dispute.currentAchiever += _amount;
    }
    
    function _fundChallenger(uint _disputeID, uint _amount, address _contributor) private {
        // check if contributor had already contibuted. update nContributorsChallenger and add address if not.  TRUSTED!
        ADispute storage dispute = disputes[_disputeID];
        if (!hasContributedChallenger(_disputeID, _contributor)){
            contributorsChallenger[_disputeID][dispute.nContributorsChallenger] = _contributor;
            dispute.nContributorsChallenger++;
        }
        expensesChallenger[_disputeID][_contributor] += _amount;
        // update treasure.
        dispute.treasure += _amount;
        // update currentChallenger
        dispute.currentChallenger += _amount;
    }
    
    function _appeal(uint _disputeID, uint _amount) private {
        ADispute storage dispute = disputes[_disputeID];
        //  deduct from treasure
        dispute.treasure -= _amount;
        //  reset currentAchiever / currentChallenger
        dispute.currentAchiever = 0;
        dispute.currentChallenger = 0;
        //  status is now Disputing
        dispute.disputeStatus = uint8(DisputeStatus.Disputing);
        //  update lastCost and lastStake
        dispute.lastCost = _amount;
        dispute.lastStake = nextRoundStake(_disputeID);
        //  call arbitrator
        arbitrator.appeal{value: _amount}(dispute.externalDisputeId, ARBITRATOR_EXTRA_DATA);
    }
    
    /* Public functions */
    
    function winnerCashout(uint _id) public {
        Vow memory vow = vows[_id];
        require(vow.vowStatus == uint8(VowStatus.Failed)
            || vow.vowStatus == uint8(VowStatus.Achieved));
        require(!vow.paid);
        
        Vow storage vowPaid = vows[_id];
        vowPaid.paid = true;
        
        if(!vow.disputed){
            _payClean(vow);
        } else {
            _payComplex(vow);
        }
    }
    
    function achieveCleanVow(uint _id) public {
        require(block.timestamp >= vows[_id].zeroDay + CLEAR_PERIOD);
        vows[_id].vowStatus = uint8(VowStatus.Achieved);
        winnerCashout(_id);
    }
    
    function submitEvidence(uint _disputeID, string memory _evidence) public {
        emit Evidence(arbitrator, _disputeID, msg.sender, _evidence);
    }
    
    function withdrawOrphanFunds() public {
        //TODO. Idea is to make this for me as a dev fee of sorts?
        //Sums funds of all unpaid vows, subtracts to total and gives me the crumbs
        //Useful in case someone accidentally throws funds at this contract
        //Otherwise it would be burned
    }
    
    /* External functions */
    
    function makeVow(uint _zeroDay, string memory _vowfile) external payable {
        require(msg.value >= MINIMUM_VOW,
            "You need to pledge more ether");
        
        uint newVowId = _createVow(msg.sender, msg.value, _zeroDay);
        
        emit VowMade(msg.sender, newVowId, msg.value, _vowfile);
    }
    
    function challengeVow(uint _id, string memory _evidence) external payable {
        require(_id < vows.length,
            "Vow must exist");
        Vow storage vow = vows[_id];
        uint counter = (COUNTER_PERCENT * vow.bond) / MULTIPLIER_TO_DIV;
        uint disputeCost = arbitrator.arbitrationCost(ARBITRATOR_EXTRA_DATA);
        
        require(msg.value >= counter + disputeCost,
            "Serum must cover counter and arbitration");
        require(vow.vowStatus == uint8(VowStatus.Clean),
            "Vow must be Clean in order to be challengeable");
        require(block.timestamp < vow.zeroDay + CLEAR_PERIOD,
            "Vow has stayed Clean up to the CLEAR_PERIOD, it could be Achieved now.");
        
        vow.disputed = true;
        vow.vowStatus = uint8(VowStatus.Challenged);
        vow.disputeId = uint64(_createDispute(
            _id,
            counter,
            disputeCost,
            msg.sender
        ));
        
        submitEvidence(vow.disputeId, _evidence); // This first piece of evidence is the Challenger's claim.
        /*// In this implementation, only one dispute at maximum can be called per Vow.
        // This means that if future evidence is submitted that proves Vow was failed,
        // even though Challenger's claim was invalid, then that dispute must be ruled as Failed.
        // In a future implementation I want to implement it with a cooldown, so that disputes whose
        // challenger's claim is invalid are ruled to Fail, but multiple disputes can be made until
        // Vow cannot be proven to have failed for a certain amount of days.
        // Thus, this is a Proof of Concept. This contract would need a lot of refactoring to achieve this.
        // It should be interesting to pursue this working, in order to research in practice new ways
        // of settling disputes.
        // At the moment, challenger's invalid claim is not enough to deem a Vow Achieved, as only one
        // Dispute is available per Vow, and malicious Achievers could challenge their own Vow with and
        // invalid claim, assuring Achieved status. So, jurors must rule the Vow in absolute terms in this
        // implementation.*/
        
        emit VowChallenged(msg.sender, _id, vow.disputeId, _evidence);
    }
    
    function bootDispute(uint _id) external {
        ADispute storage dispute = disputes[_id];
        require(dispute.disputeStatus == uint8(DisputeStatus.Pending),
            "Dispute must be Pending");
        Vow storage vow = vows[dispute.vowId];
        require(vow.vowStatus == uint8(VowStatus.Challenged),
            "Vow must be in Challenged status");
        require(block.timestamp >= vow.zeroDay + GRACE_PERIOD,
            "Dispute cannot boot until grace period ends");
        
        dispute.disputeStatus = uint8(DisputeStatus.Disputing);
        vow.vowStatus = uint8(VowStatus.Dispute);
        // arbitrationCost might update during the time between Pending and Disputing
        // thus potentially draining funds from this contract
        // things that may go wrong: many. Good thing this is a prototype
        dispute.externalDisputeId = 
            arbitrator.createDispute {
            value: arbitrator.arbitrationCost(ARBITRATOR_EXTRA_DATA)
            } (RULING_OPTIONS, ARBITRATOR_EXTRA_DATA);
        emit VowDisputeStarted(dispute.vowId, _id, dispute.externalDisputeId);
    }
    
    function updateLocalDispute(uint _id) external {
        // gets 'disputing' dispute to either ToFail or ToAchieve
        ADispute storage dispute = disputes[_id];
        require(dispute.disputeStatus == uint8(DisputeStatus.Disputing)
            , "Must be in Disputing state to be updated to ToPhase");
        // Check Arbitrator to see if it's Waiting
        require(_fetchDisputeStatus(dispute) == IArbitrator.DisputeStatus.Waiting
            , "External dispute must be Appealeable");
        uint currentRuling = _fetchCurrentRuling(dispute);
        if (currentRuling != 2) { // Ruling either refused, ruled to achieve, or overflow
            dispute.disputeStatus = uint8(DisputeStatus.ToAchieve);
        } else { // Ruling is Fail
            dispute.disputeStatus = uint8(DisputeStatus.ToFail);
        }
    }
    
    function appealToFail(uint _id) external payable {
        //This changes ToFail to CrowdfundFail if enough is funded
        ADispute storage dispute = disputes[_id];
        require(dispute.disputeStatus == uint8(DisputeStatus.ToFail)
            , "Needs to be ToFail to perform appealToFail");
        (uint appealStart, uint appealEnd) = _fetchAppealPeriod(dispute);
        require(block.timestamp < getAverage(appealStart, appealEnd)
            , "It's too late to fund loser side");
        require(msg.value >= MINIMUM_CONTRIBUTION
            , "This contribution is too small");
        
        // add funds to crowdfund _fundAchiever this updates all values
        _fundAchiever(_id, msg.value, msg.sender);
        
        emit VowFundedAchieve(msg.sender, dispute.vowId, msg.value);
        
        // if funds are enough, goto CrowdfundFail . treasure wont be spent until calling arbitrator !!!!
        // enough means: nextRoundStake + (fetchAppealCost / loserrate)
        uint thisCost = fetchAppealCost(_id) * (MULTIPLIER_TO_DIV - WINNER_DISCOUNT) / MULTIPLIER_TO_DIV;
        if ( dispute.currentAchiever >= (nextRoundStake(_id) + thisCost) ) {
            dispute.disputeStatus = uint8(DisputeStatus.CrowdfundFail);
        }
    }
    
    function appealToAchieve(uint _id) external payable {
        //This changes ToAchieve to CrowdfundAchieve if enough is funded
        ADispute storage dispute = disputes[_id];
        require(dispute.disputeStatus == uint8(DisputeStatus.ToAchieve)
            , "Needs to be ToAchieve to perform appealToAchieve");
        (uint appealStart, uint appealEnd) = _fetchAppealPeriod(dispute);
        require(block.timestamp < getAverage(appealStart, appealEnd)
            , "It's too late to fund loser side");
        require(msg.value >= MINIMUM_CONTRIBUTION
            , "This contribution is too small");
        
        // add funds to crowdfund _fundChallenger this updates all values
        _fundChallenger(_id, msg.value, msg.sender);
        
        emit VowFundedFail(msg.sender, dispute.vowId, msg.value);
        
        // if funds are enough, goto CrowdfundAchieve . treasure wont be spent until calling arbitrator !!!!
        // enough means: nextRoundStake + (fetchAppealCost / loserrate)
        uint thisCost = fetchAppealCost(_id) * (MULTIPLIER_TO_DIV - WINNER_DISCOUNT) / MULTIPLIER_TO_DIV;
        if ( dispute.currentChallenger >= (nextRoundStake(_id) + thisCost) ) {
            dispute.disputeStatus = uint8(DisputeStatus.CrowdfundAchieve);
        }
    }
    
    function appealCrowdfundFail(uint _id) external payable {
        //This calls for an appeal if enough if funded. Otherwise, if not in time, Fail will lose and Achieve happens.
        
        ADispute storage dispute = disputes[_id];
        require(dispute.disputeStatus == uint8(DisputeStatus.CrowdfundFail)
            , "Needs to be CrowdfundFail to perform appealCrowdfundFail");
        (, uint appealEnd) = _fetchAppealPeriod(dispute);
        require(block.timestamp < appealEnd
            , "It's too late to fund winning side");
        require(msg.value >= MINIMUM_CONTRIBUTION
            , "This contribution is too small");
        
        // add funds to crowdfund _fundChallenger this updates all values
        _fundChallenger(_id, msg.value, msg.sender);
        
        emit VowFundedFail(msg.sender, dispute.vowId, msg.value);
        
        // if funds are enough, tell arbitrator to appeal. treasure will spend appealCost !
        // enough means: nextRoundStake + (fetchAppealCost / winnerrate)
        uint thisAppealCost = fetchAppealCost(_id);
        uint thisCost = thisAppealCost * WINNER_DISCOUNT / MULTIPLIER_TO_DIV;
        
        if ( dispute.currentChallenger >= ( (nextRoundStake(_id) * WINNER_DISCOUNT / MULTIPLIER_TO_DIV )
            + thisCost) ) {
            _appeal(_id, thisAppealCost);
            emit VowAppealed(dispute.vowId, _id, dispute.externalDisputeId);
        }
    }
    
    function appealCrowdfundAchieve(uint _id) external payable {
        //This calls for an appeal if enough if funded. Otherwise, if not in time, Achieve will lose and Fail happens.
        
        ADispute storage dispute = disputes[_id];
        require(dispute.disputeStatus == uint8(DisputeStatus.CrowdfundAchieve)
            , "Needs to be CrowdfundAchieve to perform appealCrowdfundAchieve");
        (, uint appealEnd) = _fetchAppealPeriod(dispute);
        require(block.timestamp < appealEnd
            , "It's too late to fund winning side");
        require(msg.value >= MINIMUM_CONTRIBUTION
            , "This contribution is too small");
        
        // add funds to crowdfund _fundAchiever this updates all values
        _fundAchiever(_id, msg.value, msg.sender);
        
        emit VowFundedAchieve(msg.sender, dispute.vowId, msg.value);
        
        // if funds are enough, tell arbitrator to appeal. treasure will spend appealCost !
        // enough means: nextRoundStake + (fetchAppealCost / winnerrate)
        uint thisAppealCost = fetchAppealCost(_id);
        uint thisCost = thisAppealCost * WINNER_DISCOUNT / MULTIPLIER_TO_DIV;
        
        if ( dispute.currentAchiever >= ( (nextRoundStake(_id) * WINNER_DISCOUNT / MULTIPLIER_TO_DIV )
            + thisCost) ) {
            _appeal(_id, thisAppealCost);
            emit VowAppealed(dispute.vowId, _id, dispute.externalDisputeId);
        }
    }
    
    /**
     * @dev Give a ruling for a dispute. Must be called by the arbitrator. Trusted
     * The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
     * @param _disputeID ID of the dispute in the Arbitrator contract.
     * @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
     */
     
    function rule(uint256 _disputeID, uint256 _ruling) external override onlyArbitrator {
        //TODO if Dispute is CrowdfundFail or CrowdfundAchieve, rule will instead set the other.
        
        uint i = 0;
        for(; i < disputes.length; i++){
            if (_disputeID == disputes[i].externalDisputeId) {
                break;
            }
        }
        
        ADispute storage dispute = disputes[i];
        uint8 storedStatus = dispute.disputeStatus;
        dispute.disputeStatus = uint8(DisputeStatus.Ruled); 
        
        Vow storage vow = vows[dispute.vowId];
        
        emit Ruling(arbitrator, _disputeID, _ruling);
        
        if (storedStatus == uint8(DisputeStatus.CrowdfundFail)) {
            // not funded, so Achieve
            vow.vowStatus = uint8(VowStatus.Achieved);
        } else if (storedStatus == uint8(DisputeStatus.CrowdfundAchieve)) {
            // not funded, so Fail
            vow.vowStatus = uint8(VowStatus.Failed);
        } else {
            if (_ruling == 0 ||_ruling == 1) {
                vow.vowStatus = uint8(VowStatus.Achieved);
            } else if (_ruling == 2) {
                vow.vowStatus = uint8(VowStatus.Failed);
            } else {
                vow.vowStatus = uint8(VowStatus.Achieved);
            }
        }
        
        if (vow.vowStatus == uint8(VowStatus.Achieved) ) {
            emit VowAchieved(vow.achiever, dispute.vowId); 
        } else {
            emit VowFailed(vow.achiever, dispute.vowId); 
        }
    }
    
    /* Modifiers */
    
    modifier notSaved(Vow memory _vow) {
        require(block.timestamp < _vow.zeroDay + CLEAR_PERIOD, 
            "This vow can be saved");
        _;
    }
    
    modifier onlyArbitrator {
        require(msg.sender == address(arbitrator),
            "Can only be called by the arbitrator."); 
        _;
    }
    
    /* Views */
    
    function readVow(uint id) public view returns(uint, uint) {
        Vow memory _vow = vows[id];
        return(_vow.vowStatus, _vow.zeroDay);
    }
    
    function totalAchieverExpenses(uint _disputeID) public view returns (uint) {
        uint sum;
        uint end = disputes[_disputeID].nContributorsAchiever;
        
        for (uint i = 0; i < end; i++) {
            address contributor = contributorsAchiever[_disputeID][i];
            uint expense = expensesAchiever[_disputeID][contributor];
            sum += expense;
        }
        
        return sum;
    }
    
    function totalChallengerExpenses(uint _disputeID) public view returns (uint) {
        uint sum;
        uint end = disputes[_disputeID].nContributorsAchiever;
        
        for (uint i = 0; i < end; i++) {
            address contributor = contributorsChallenger[_disputeID][i];
            uint expense = expensesChallenger[_disputeID][contributor];
            sum += expense;
        }
        
        return sum;
    }
    
    function max(uint a, uint b) public pure returns (uint) {
        return a > b ? a : b;
    }
    
    function getAverage(uint a, uint b) public pure returns (uint) {
        return( (a + b) / 2 );
    }
    
    function hasContributedAchiever(uint _disputeID, address _contributor) public view returns(bool) {
        uint nContributors = uint256(disputes[_disputeID].nContributorsAchiever);
        for(uint i = 0; i < nContributors; i++) {
            if(contributorsAchiever[_disputeID][i] == _contributor) {
                return true;
            }
        }
        return false;
    }
    
    function hasContributedChallenger(uint _disputeID, address _contributor) public view returns(bool) {
        uint nContributors = uint256(disputes[_disputeID].nContributorsChallenger);
        for(uint i = 0; i < nContributors; i++) {
            if(contributorsChallenger[_disputeID][i] == _contributor) {
                return true;
            }
        }
        return false;
    }
    
    function remainingForAchiever(uint _id) public view returns (uint) {
        // returns remaining value to fully fund Fail side
    }
    
    function nextRoundStake(uint _id) public view returns (uint) {
        // This is the amount loser has to stake next round
        return ( disputes[_id].lastStake * appealMultiplier(_id) / MULTIPLIER_TO_DIV );
    }
    
    function appealMultiplier(uint _id) public view returns (uint) {
        // This returns multiplier * MULTIPLIER_TO_DIV, so be careful !
        uint newCost = fetchAppealCost(_id);
        return(newCost * MULTIPLIER_TO_DIV / disputes[_id].lastCost);
    }
    
    function fetchAppealCost(uint _id) public view returns(uint) {
        return(arbitrator.appealCost(disputes[_id].externalDisputeId, ARBITRATOR_EXTRA_DATA));
    }
}