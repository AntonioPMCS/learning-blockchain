// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./Ownable.sol";

/**
 * @title Hedgehog
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Hedgehog is Ownable {

    mapping(address=>uint) private balances;
    uint public totalSupply = 0;
    uint public constant initialBalance = 10000000;

    string private _name;
    string private _symbol;

    bool public paused = false;

    modifier notPaused() {
        require(!paused, "Contract is Paused");
        _;
    }

    constructor (string memory tokenName, string memory tokenSymbol) {
        // Alocação inicial de tokens (initialSupply)
        mint(msg.sender, initialBalance);
        _name = tokenName;
        _symbol = tokenSymbol; 
    }

    function balanceOf(address _account) view public returns (uint amount) {
        return balances[_account];
    }

    function transfer(address _recipient, uint _amount) public notPaused {
        require(balances[msg.sender] >= _amount, "Insufficient Balance");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
    }

    function symbol() view public returns (string memory) {
        return _symbol;
    }

    function name() view public returns (string memory) {
        return _name;
    }

    function decimals() public view virtual returns (uint8) {
        return 4;
    }

    function mint(address to, uint amount ) public onlyOwner notPaused {
        balances[to] += amount;
        totalSupply += amount;
    }

    function burn(address from, uint amount) public onlyOwner notPaused {
        balances[from] -= amount;
        totalSupply -= amount;
    }

    function setPaused(bool state) public onlyOwner {
        require(paused != state, "Trying to set paused to the same value");
        paused = state;
    }
}