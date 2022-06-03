// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "./Jury.sol";

contract Case {
    string public Title;
    string public Description;
    address public Judge;
    address public Plaintiff;
    address public Defendant;
    State public state;
    argument[] public arguments;

    mapping(address => uint256) public argumentsCount;

    struct argument {
        string argument;
        address maker;
    }

    enum State {
        Created,
        Started,
        Ended
    }

    constructor(
        string memory _title,
        string memory _desc,
        address _deff
    ) {
        Title = _title;
        Description = _desc;
        Plaintiff = msg.sender;
        Defendant = _deff;
        state = State.Created;
    }

    function becomeJudge() public {
        require(msg.sender != Plaintiff, "Plattiff cant become judge");
        require(msg.sender != Defendant, "Defendant cant become judge");
        Judge = msg.sender;
        state = State.Started;
    }

    function whoIsJudge() public view returns (address) {
        return Judge;
    }

    function makeArgument(string memory _argument) public {
        require(
            msg.sender == Plaintiff || msg.sender == Defendant,
            "only plantiff or defendant can make argument"
        );
        require(
            argumentsCount[msg.sender] <= 3,
            "only allowed to make 3 arguments"
        );
        argument memory newArgument = argument({
            argument: _argument,
            maker: msg.sender
        });
        argumentsCount[msg.sender] += 1;
        arguments.push(newArgument);
    }
}
