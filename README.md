# Achiever
Achiever is a dapp in which the users make a promise and put their money where their mouth is.

This is a solo-project for a [4-day Kleros Hackathon](https://blog.kleros.io/kleros-conference-law-memes-crowds-and-blockchain/).
The dapp consists on a static page and a Solidity contract. The static page approach is preferred in this implementation so that it can be hosted in ipfs. Evidence and claims are transferred using ipfs. Under certain rules that must be followed, users may challenge the promise by also staking some funds, and then Kleros will act as an oracle.
Stakes and appeals are made using *ETH*.

# Description, terminology and logic

A *Vow* is understood as a claim about the future. Promises are the first obvious example, but it can be used in a more general way, such as self-promises, payments, delivery of projects, return rates, or any prediction of any kind. The *Achiever*, creator of the Vow, stakes a collateral in ETH (*Bond*), along with a day in which the Vow must have been completed (*Zero-day*), and the documentation specifying the Vow that is kept (*pledge*).

A *Challenger* is an user that is convinced the Vow has not been Achieved, or, if the Zero-day has not come yet, the Vow will not be Achieved before it. The Challenger stakes a collateral (*Counter*) and pays for the cost of the Dispute. The sum of this values is referred to as *Serum*. Challenger has an incentive to do this, because the Bond will be awarded to the winner of the Dispute. The Challenger also places a *Claim* along with the Challenge. These funds are added to the *Treasure*. Treasure will spend funds to create the Dispute, and the remaining funds will be given to the winner.

The Dispute can start after a *Grace Period* after Zero-day. This Dispute must be ruled in the terms referred in the Claim. Alas, in the case the Claim is deemed invalid, even though the Vow has not been Achieved, it must be ruled as a loss for the Challenger. This Dispute can be appealed internally by the Arbitrator, but for the Arbitrator to be desirable, the final ruling must be coherent with this guideline, otherwise, users of the dapp are encouraged to change the Arbitrator or migrate elsewhere. More information about other guidelines Arbitrator should follow when ruling will follow later. Appeals can be crowdfunded.

Even if a Challenge fails, future Challenges can be made. The moment a Challenge is deemed valid, the Treasure is awarded to that Challenge. If no successful Challenges prove the Vow to have been failed, after a *Clear Period* after the last ruling, the Treasure will be awarded to the backers of the Achiever. Specifically:

- If there are no appeals, Treasure are simply awarded to either the Achiever or the Challenger of the last valid Challenge.
- If Vow is ruled as Achieved, and there have been any appeals supporting the Achiever in any Challenge, then treasure will be awarded in absolute terms to all backers of the Achiever, in proportion to their expenses.
- If Vow is ruled as Failed, and there have been appeals in the last Challenge, then treasure will be awarded in absolute terms to all backers of the Challenger, in proportion to their expenses.

Note: Invalid Challenges and crowdfunders of those Challenges will lose their funds, even if Vow is finally ruled as Failed.

Losers of the last round must stake aditional funds if they wish to appeal the last ruling.

Finally, in the case no one challenges the Achiever, then after a Grace Period after the Zero-day, the Vow will be Achieved and the Bond returned to the Achiever.

# Differences with current implementation

In the current Achiever.sol contract, at the time of this writing, the logic aforementioned is not the current implementation. There is currently only one possible Dispute, and so, if this was deployed, Arbitrator should not judge the validity of the Challenger's Claim and simply verify by itself if the Vow has been achieved or not. It is not adviced that this implementation is deployed yet.

# More technicalities, and an idea I had for a standard I could pioneer in this dapp

Following ERC-792, the `_extraData` field might cause some problems if Arbitrable contracts were implemented naively. If the developer wanted Achievers to customize the terms of the possible Disputes of their Vows, it might get expensive in terms of storage real fast. So, a first approach I thought of was to make `struct Vow` encode some small extra, customizable data in the form of a byte32 `extraData` variable. Then, the developer could make a function that decodes this encoding to deliver as `_extraData` to Arbitrator. That way, future Arbitrators that allowed to make customizable Disputes could read this data, and Achiever users could try out different settings for their Disputes. But then again, a new problem arose:

What if the Arbitrator is changed? This could be due to a variety of reasons: Arbitrator might no longer be functional, Arbitrator might give Rulings that users are not happy about, or Arbitrator upgrades their protocol and expects users to migrate.

We can add a `function changeArbitrator(...) external onlyGovernor;`, but what if the new Arbitrator has a different way of understanding `_extraData`? Then the normal approach would be create a new Arbitrable. But I just figured there is no need for that, there could be a decoding-contract standard.

Note that, in order for this situation to happen, there is no need for the custom information in Arbitrable to be encoded, even if the contract just held an `ARBITRATOR_EXTRADATA` constant that was fed the same way to Arbitrator, the same problem quickly arises: different Arbitrators might use different ways to read this extradata, so the need for creating new contracts would be inevitable if migration was needed.

My suggestion is to make an ERC standard for decoding bytes for not only this use case, but all use cases in which there might be a new way to read encoded/decoded data. Makeshift-naming here: create an interface `IDecoder` that only has a:

`function decode(bytes _data) external view returns(_bytes);`

There you go. Now our Arbitrable contract can have a global variable `decoderContract`, and call its method whenever there is a need to decode, or even just feed data to an external contract. Obvious example is KlerosLiquid, that can only read `_extraData` a certain way. Just put a `function changeDecoder(...) external onlyGovernor;` somewhere, that constructs a new `decoderContract` from a new address. So, when eventually a change needs to be done, it should suffice with deploying a new IDecoder contract that transforms the data to its needed form, and back in the Arbitrable having the governor call `changeDecoder`.

 Now our Arbitrable contract can go and change Arbitrator safely according to the ERC-792 standard. Please give me feedback so that I can know if I just reinvented the wheel, but anyway I know that, in case I build this, (and in case it wasn't made yet), I would like to be the "EIPs Champion" of this standard with this dapp. This could be implemented in other Kleros dapps too, so that if and when new Kleros Court contracts are made, the other dapps can update Arbitrator.
