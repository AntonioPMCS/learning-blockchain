// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Hedgehog {

    mapping(address=>uint) private balances;
    uint public totalSupply = 0;
    uint public constant initialBalance = 10000000;

    string private _name;
    string private _symbol;


    constructor (string memory tokenName, string memory tokenSymbol) {
        // Alocação inicial de tokens (initialSupply)
        totalSupply += initialBalance;
        balances[msg.sender] = 100000000;
        _name = tokenName;
        _symbol = tokenSymbol;
    }

    function balanceOf(address _account) view public returns (uint amount) {
        return balances[_account];
    }

    function transfer(address _recipient, uint _amount) public {
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

}