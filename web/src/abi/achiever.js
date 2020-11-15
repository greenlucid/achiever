const achieverData = {
	address: "0x514910771af9ca656af840dff83e8264ecf986ca",
	abi: [
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": true,
					"internalType": "contract IArbitrator",
					"name": "_arbitrator",
					"type": "address"
				},
				{
					"indexed": true,
					"internalType": "uint256",
					"name": "_disputeID",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_metaEvidenceID",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_evidenceGroupID",
					"type": "uint256"
				}
			],
			"name": "Dispute",
			"type": "event"
		},
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": true,
					"internalType": "contract IArbitrator",
					"name": "_arbitrator",
					"type": "address"
				},
				{
					"indexed": true,
					"internalType": "uint256",
					"name": "_evidenceGroupID",
					"type": "uint256"
				},
				{
					"indexed": true,
					"internalType": "address",
					"name": "_party",
					"type": "address"
				},
				{
					"indexed": false,
					"internalType": "string",
					"name": "_evidence",
					"type": "string"
				}
			],
			"name": "Evidence",
			"type": "event"
		},
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": true,
					"internalType": "uint256",
					"name": "_metaEvidenceID",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "string",
					"name": "_evidence",
					"type": "string"
				}
			],
			"name": "MetaEvidence",
			"type": "event"
		},
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": true,
					"internalType": "contract IArbitrator",
					"name": "_arbitrator",
					"type": "address"
				},
				{
					"indexed": true,
					"internalType": "uint256",
					"name": "_disputeID",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_ruling",
					"type": "uint256"
				}
			],
			"name": "Ruling",
			"type": "event"
		},
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": false,
					"internalType": "address",
					"name": "_achiever",
					"type": "address"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_vowId",
					"type": "uint256"
				}
			],
			"name": "VowAchieved",
			"type": "event"
		},
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_vowId",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_internalDispute",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_externalDispute",
					"type": "uint256"
				}
			],
			"name": "VowAppealed",
			"type": "event"
		},
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": false,
					"internalType": "address",
					"name": "_challenger",
					"type": "address"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_vowId",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_internalDispute",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "string",
					"name": "_claim",
					"type": "string"
				}
			],
			"name": "VowChallenged",
			"type": "event"
		},
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_vowId",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_internalDispute",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_externalDispute",
					"type": "uint256"
				}
			],
			"name": "VowDisputeStarted",
			"type": "event"
		},
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": false,
					"internalType": "address",
					"name": "_achiever",
					"type": "address"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_vowId",
					"type": "uint256"
				}
			],
			"name": "VowFailed",
			"type": "event"
		},
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": false,
					"internalType": "address",
					"name": "_contributor",
					"type": "address"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_vowId",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_amount",
					"type": "uint256"
				}
			],
			"name": "VowFundedAchieve",
			"type": "event"
		},
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": false,
					"internalType": "address",
					"name": "_contributor",
					"type": "address"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_vowId",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_amount",
					"type": "uint256"
				}
			],
			"name": "VowFundedFail",
			"type": "event"
		},
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": false,
					"internalType": "address",
					"name": "_achiever",
					"type": "address"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_vowId",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "uint256",
					"name": "_bond",
					"type": "uint256"
				},
				{
					"indexed": false,
					"internalType": "string",
					"name": "_vowfile",
					"type": "string"
				}
			],
			"name": "VowMade",
			"type": "event"
		},
		{
			"inputs": [],
			"name": "ARBITRATOR_EXTRA_DATA",
			"outputs": [
				{
					"internalType": "bytes",
					"name": "",
					"type": "bytes"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				}
			],
			"name": "achieveCleanVow",
			"outputs": [],
			"stateMutability": "nonpayable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				}
			],
			"name": "appealCrowdfundAchieve",
			"outputs": [],
			"stateMutability": "payable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				}
			],
			"name": "appealCrowdfundFail",
			"outputs": [],
			"stateMutability": "payable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				}
			],
			"name": "appealMultiplier",
			"outputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				}
			],
			"name": "appealToAchieve",
			"outputs": [],
			"stateMutability": "payable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				}
			],
			"name": "appealToFail",
			"outputs": [],
			"stateMutability": "payable",
			"type": "function"
		},
		{
			"inputs": [],
			"name": "arbitrator",
			"outputs": [
				{
					"internalType": "contract IArbitrator",
					"name": "",
					"type": "address"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				}
			],
			"name": "bootDispute",
			"outputs": [],
			"stateMutability": "nonpayable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				},
				{
					"internalType": "string",
					"name": "_evidence",
					"type": "string"
				}
			],
			"name": "challengeVow",
			"outputs": [],
			"stateMutability": "payable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				},
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"name": "contributorsAchiever",
			"outputs": [
				{
					"internalType": "address",
					"name": "",
					"type": "address"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				},
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"name": "contributorsChallenger",
			"outputs": [
				{
					"internalType": "address",
					"name": "",
					"type": "address"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"name": "disputes",
			"outputs": [
				{
					"internalType": "uint64",
					"name": "vowId",
					"type": "uint64"
				},
				{
					"internalType": "uint64",
					"name": "nContributorsAchiever",
					"type": "uint64"
				},
				{
					"internalType": "uint64",
					"name": "nContributorsChallenger",
					"type": "uint64"
				},
				{
					"internalType": "uint32",
					"name": "currentRound",
					"type": "uint32"
				},
				{
					"internalType": "uint8",
					"name": "disputeStatus",
					"type": "uint8"
				},
				{
					"internalType": "uint256",
					"name": "externalDisputeId",
					"type": "uint256"
				},
				{
					"internalType": "uint256",
					"name": "currentAchiever",
					"type": "uint256"
				},
				{
					"internalType": "uint256",
					"name": "currentChallenger",
					"type": "uint256"
				},
				{
					"internalType": "uint256",
					"name": "treasure",
					"type": "uint256"
				},
				{
					"internalType": "uint256",
					"name": "lastStake",
					"type": "uint256"
				},
				{
					"internalType": "uint256",
					"name": "lastCost",
					"type": "uint256"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				},
				{
					"internalType": "address",
					"name": "",
					"type": "address"
				}
			],
			"name": "expensesAchiever",
			"outputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				},
				{
					"internalType": "address",
					"name": "",
					"type": "address"
				}
			],
			"name": "expensesChallenger",
			"outputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				}
			],
			"name": "fetchAppealCost",
			"outputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "a",
					"type": "uint256"
				},
				{
					"internalType": "uint256",
					"name": "b",
					"type": "uint256"
				}
			],
			"name": "getAverage",
			"outputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"stateMutability": "pure",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_disputeID",
					"type": "uint256"
				},
				{
					"internalType": "address",
					"name": "_contributor",
					"type": "address"
				}
			],
			"name": "hasContributedAchiever",
			"outputs": [
				{
					"internalType": "bool",
					"name": "",
					"type": "bool"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_disputeID",
					"type": "uint256"
				},
				{
					"internalType": "address",
					"name": "_contributor",
					"type": "address"
				}
			],
			"name": "hasContributedChallenger",
			"outputs": [
				{
					"internalType": "bool",
					"name": "",
					"type": "bool"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_zeroDay",
					"type": "uint256"
				},
				{
					"internalType": "string",
					"name": "_vowfile",
					"type": "string"
				}
			],
			"name": "makeVow",
			"outputs": [],
			"stateMutability": "payable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "a",
					"type": "uint256"
				},
				{
					"internalType": "uint256",
					"name": "b",
					"type": "uint256"
				}
			],
			"name": "max",
			"outputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"stateMutability": "pure",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				}
			],
			"name": "nextRoundStake",
			"outputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "id",
					"type": "uint256"
				}
			],
			"name": "readVow",
			"outputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				},
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_disputeID",
					"type": "uint256"
				},
				{
					"internalType": "uint256",
					"name": "_ruling",
					"type": "uint256"
				}
			],
			"name": "rule",
			"outputs": [],
			"stateMutability": "nonpayable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_disputeID",
					"type": "uint256"
				},
				{
					"internalType": "string",
					"name": "_evidence",
					"type": "string"
				}
			],
			"name": "submitEvidence",
			"outputs": [],
			"stateMutability": "nonpayable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_disputeID",
					"type": "uint256"
				}
			],
			"name": "totalAchieverExpenses",
			"outputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_disputeID",
					"type": "uint256"
				}
			],
			"name": "totalChallengerExpenses",
			"outputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				}
			],
			"name": "updateLocalDispute",
			"outputs": [],
			"stateMutability": "nonpayable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "",
					"type": "uint256"
				}
			],
			"name": "vows",
			"outputs": [
				{
					"internalType": "address",
					"name": "achiever",
					"type": "address"
				},
				{
					"internalType": "uint8",
					"name": "vowStatus",
					"type": "uint8"
				},
				{
					"internalType": "uint64",
					"name": "zeroDay",
					"type": "uint64"
				},
				{
					"internalType": "uint64",
					"name": "disputeId",
					"type": "uint64"
				},
				{
					"internalType": "bool",
					"name": "disputed",
					"type": "bool"
				},
				{
					"internalType": "bool",
					"name": "paid",
					"type": "bool"
				},
				{
					"internalType": "uint256",
					"name": "bond",
					"type": "uint256"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_id",
					"type": "uint256"
				}
			],
			"name": "winnerCashout",
			"outputs": [],
			"stateMutability": "nonpayable",
			"type": "function"
		},
		{
			"inputs": [],
			"name": "withdrawOrphanFunds",
			"outputs": [],
			"stateMutability": "nonpayable",
			"type": "function"
		}
	]
}
