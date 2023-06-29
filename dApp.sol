//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract votingdApp { 
     
	//weight : A voter is assigned weight, to mean how many times the voter can vote. 
	// to store in each voter a representation
    // to check the number of votes the person has been able to cast.
	// to check if the voter wants to/ has assigned their vote right to another person. 
    //To check if the voter has voted or not.

	struct Voter {
		uint weight;
		string voter;
		uint vote;
		address delegate;
        bool voted;
    }
	
	// define structure of:
	// candidate that has been voted
	//how many votes they have earned.

	struct Proposal{
		string name;
        uint voteCount;
        }

	// we need the incharge of this smart contract who initiates this voting and gives voting power to each voter.

	address public leader;
//map the address to the Voter structure then delegate variable voters.
	mapping(address => Voter) public voters;

//store an array of proposals
	Proposal[] public proposals;

//give voting right to the account that is going to deploy this smart contract.

	constructor(){ 
	string[3] memory proposalNames=["Blue", "Red", "Green"];
	leader = msg.sender;  // leader should be the account deploying the smart contract and give him voting power of 1.
	
    voters[leader].weight=1;
	for(uint i=0; i < proposalNames.length; i++){
		proposals.push(Proposal({name:proposalNames[i], voteCount:0}));
		
		}
	}
	function giveRightTovote(address  voter) public {
		require(msg.sender==leader, "only leader can give voting rights");
		require(voters[voter].voted, "voter already voted");
		require(voters[voter].weight ==0);
		voters[voter].weight=1;
	}

    function delegate(address to) public{
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "you already voted");
        require(to !=msg.sender, "self delegation is not allowed");
        while(voters[to].delegate !=address(0)){
            to=voters[to].delegate;
            require(to !=msg.sender,"Found loop in delegation");
        }
        sender.voted=true;
        sender.delegate=to;
        Voter storage delegate_ =voters[to];
        if(delegate_.voted){
            proposals[delegate_.vote].voteCount ==sender.weight;
        }
        else{
            delegate_.weight ==sender.weight;
        }
    }
    function vote(uint proposal)public{
        Voter storage sender=voters[msg.sender];
        require(sender.weight !=0, "has no right to vote");
        require(!sender.voted, "Already voted");
        sender.voted=true;
        sender.vote=proposal;
        proposals[proposal].voteCount +=sender.weight;
    }

    function winningProposal()public view returns(uint winningProposal_){
        uint winningVoteCount = 0;
        for(uint p=0; p < proposals.length; p++){
            if(proposals[p].voteCount > winningVoteCount){
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;

            }
        }
    }
    function winnername() public view returns(string memory winnername_){
        winnername_ =proposals[winningProposal()].name;
    }
	
}