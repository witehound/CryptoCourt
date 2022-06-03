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
}
