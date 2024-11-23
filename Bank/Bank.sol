// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./IBank.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Bank is IBank {

    mapping(address=>mapping(address => uint)) private accountBalances;

    constructor () {}

    function deposit(uint amount, address token) external {

        // Transferir o token do utilizador para o smart contract do banco
        // transferFrom(address from, address to, uint amount)
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        // Atualizar o balanço do utilizador desse token transferido
        (accountBalances[msg.sender])[token] += amount;
    }

    function withdraw(uint amount, address token) external {
        
    }

    function exchangeRate(address tokenA, address tokenB) external view {

    }

    function exchange(address tokenA, address tokenB, uint amount) external {

    }

    function approvePayment(uint amount, address token) external {

    }

    function getBalance(address account, address token) external view returns (uint amount) {
        return (accountBalances[account])[token];
    }

}