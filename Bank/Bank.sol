// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./IBank.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
// Importar a interface do Oracle
import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

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
        // Garantir que a operação é válida
        require( (accountBalances[msg.sender])[token] >= amount, "Insufficient balance" ); 
        // transfer(address to, uint amount)
        IERC20(token).transfer(msg.sender, amount);
        // Atualizar o balanço do utilizador para reflectir a transferencia do token
        (accountBalances[msg.sender])[token] -= amount;
    }

    function exchangeRate(address oracle) external view returns (int256) {

        // Ir ao contrato Oracle do ChainLink e devolver o valor
        (, int256 answer, , , ) = AggregatorV3Interface(oracle).latestRoundData();
        return answer;
        // Garantir a pertinencia do exchange Rate recebido
    }

    function exchange(address tokenA, address tokenB, uint amount) external {
        
    }

    function approvePayment(uint amount, address token) external {

    }

    function getBalance(address account, address token) external view returns (uint amount) {
        return (accountBalances[account])[token];
    }

}