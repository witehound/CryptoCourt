// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Jury {
    uint256 public jurorCount = 0;
    mapping(address => bool) public JuryMap;

    function becomeAJuror() external {
        require(jurorCount <= 12, "No more spot for a new juror");
        require(!JuryMap[msg.sender], "You are already registered as a juror");
        JuryMap[msg.sender] = true;
        jurorCount++;
    }
}
