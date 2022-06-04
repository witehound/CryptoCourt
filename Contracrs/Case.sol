// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Case {
    string public Title;
    string public Description;
    address public Judge;
    address public Plaintiff;
    address public Defendant;
    State public CaseState = State.Created;

    argument[] public arguments;

    uint256[2] public votes = [0, 0];
    uint256 public jurorCount = 0;
    mapping(address => bool) public JuryMap;
    mapping(address => bool) public voted;

    mapping(address => uint256) public argumentsCount;
    struct argument {
        string argument;
        address maker;
    }

    enum State {
        NotCreated,
        Created,
        Started,
        Ended
    }

    constructor(
        string memory _title,
        string memory _desc,
        address _deff
    ) {
        require(msg.sender != _deff);
        Title = _title;
        Description = _desc;
        Plaintiff = msg.sender;
        Defendant = _deff;
        CaseState = State.Created;
    }

    //case functions

    function becomeJudge() public {
        require(msg.sender != Plaintiff, "Plattiff cant become judge");
        require(msg.sender != Defendant, "Defendant cant become judge");
        Judge = msg.sender;
        CaseState = State.Started;
    }

    function whoIsJudge() public view returns (address) {
        return Judge;
    }

    function startTrial() public {
        require(CaseState == State.Created, "trial cant start just yet");
        require(msg.sender == Judge, "only judge can start trial");
        CaseState = State.Started;
    }

    //juorr functions

    function becomeAJuror() public {
        require(jurorCount <= 12, "No more spot for a new juror");
        require(!JuryMap[msg.sender], "You are already registered as a juror");
        require(
            msg.sender != Plaintiff && msg.sender != Defendant,
            "only plantiff or defendant can make argument"
        );
        require(CaseState == State.Started, "wait till trial has started");
        JuryMap[msg.sender] = true;
        jurorCount++;
    }

    function checkAJuror(address Juror) public view returns (bool) {
        return JuryMap[Juror];
    }

    function jurorVoteYes() public {
        require(JuryMap[msg.sender] == true, "only a juror can vote");
        require(voted[msg.sender] == false, "already voted");
        require(CaseState == State.Started, "wait till trial has started");
        votes[0]++;
    }

    function jurorVoteNo() public {
        require(JuryMap[msg.sender] == true, "only a juror can vote");
        require(voted[msg.sender] == false, "already voted");
        require(CaseState == State.Started, "wait till trial has started");
        votes[1]++;
    }

    //arguement functions

    function makeArgument(string memory _argument) public {
        require(
            msg.sender == Plaintiff || msg.sender == Defendant,
            "only plantiff or defendant can make argument"
        );
        require(
            argumentsCount[msg.sender] <= 2,
            "only allowed to make 3 arguments"
        );
        require(CaseState == State.Started, "case must be started!");
        argument memory newArgument = argument({
            argument: _argument,
            maker: msg.sender
        });
        argumentsCount[msg.sender] += 1;
        arguments.push(newArgument);
    }

    //views

    function getVotesCount() public view returns (uint256[2] memory) {
        return votes;
    }
}
