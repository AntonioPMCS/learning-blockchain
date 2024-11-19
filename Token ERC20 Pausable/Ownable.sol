// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Ownable {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized Access");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
}