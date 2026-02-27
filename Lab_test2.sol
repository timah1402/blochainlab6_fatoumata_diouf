// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Election{
    struct candidate{
        uint256 id;
        string name;
        uint256 votecount;
    }

    struct electiondata{
        uint256 starttime;
        uint256 endtime;
        bool isActive;
        candidate[] candidate;
    }

    address public owner;
    mapping(uint256=>electiondata) public elections;
    uint256 public currentelectionid;

    event electionstarted (uint256 electionid, uint256 starttime, uint256 endtime);
    event candidateadded(uint256 electionid, uint256 candidateid, string name);
    event votedcast (uint256 electionid,uint256 candidateid,address voter);
    event electionended(uint256 electionid, uint256 winnerid,uint256 votecount);

    modifier onlyowner(){
        require(msg.sender==owner,"only owner can call this function");
        _;
    }
    modifier onlyduringelection(uint256 electioid){
        require(elections[electioid].isactive,"the electio is not active");
        _;
    }
    
    function startelection(uint duration) public onlyowner{
        currentelectionid++;
        elections[currentelectionid]=electiondata({
            starttime:block.timestamp,
            endtime:block.timestamp+duration,
            isActive:true,
            candidate:new candidate[](0)
        });
        emit electionstarted(currentelectionid,block.timestamp,block.timestamp+duration);
    }

    function addCandidate(uint256 electionId, string memory name) public onlyowner onlyduringelection(electionId) {
        uint256 candidateId = elections[electionId].candidates.length;
        elections[electionId].candidates.push(candidate({
            id: candidateId,
            name: name,
            voteCount: 0
        }));
        emit candidateadded(electionId, candidateId, name);
    }

    function vote(uint256 electionId, uint256 candidateId) public onlyduringelection(electionId) {
        require(
            block.timestamp <= elections[electionId].endTime,
            "Election has ended"
        );

       

        elections[electionId].candidates[candidateId].voteCount++;
        emit votedcast(electionId, candidateId, msg.sender);
    }


    function endElection(uint256 electionId) public onlyowner {
        require(
            block.timestamp > elections[electionId].endTime,
            "Election has not ended yet"
        );

        electiondata storage election = elections[electionId];
        election.isActive = false;

        uint256 winnerId = 0;
        uint256 maxVotes = 0;

        for (uint256 i = 0; i < election.candidates.length; i++) {
            if (election.candidates[i].voteCount > maxVotes) {
                maxVotes = election.candidates[i].voteCount;
                winnerId = election.candidates[i].id;
            }
        }

        emit electionended(electionId, winnerId, maxVotes);
    }



    
}