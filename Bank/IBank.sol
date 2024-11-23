// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface IBank {

    function deposit(uint amount, address token) external;
    function withdraw(uint amount, address token) external;
    function exchangeRate(address tokenA, address tokenB) external view;
    function exchange(address tokenA, address tokenB, uint amount) external;
    function approvePayment(uint amount, address token) external;
    function getBalance(address account, address token) external view returns(uint);
}
