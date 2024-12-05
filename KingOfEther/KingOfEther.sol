// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract KingOfEther {

    address payable public king;
    address payable public wizard;
    uint public throneAmount;
    uint constant INTMAX = 500 ether;
    uint public fee = 10;//%

    event NewKing(address indexed oldKing, address indexed newKing, uint indexed throneAmount);
    event FeesWithdrawn(address indexed wizard, uint indexed amount);

    constructor () {
        king = payable(msg.sender);
        wizard = payable(msg.sender);
        throneAmount = 500 wei;
    }

    function becomeKing () payable external {
        require (msg.value == throneAmount, "Not the right amount to be King");
        // Enviar o valor para o rei anterior
        king.transfer( msg.value - calculateTotalFee(msg.value) ); // <---- Old King
        // Emit the event to the blockchain (make it easy for the frontends)
        emit NewKing(king, msg.sender, throneAmount);
        // Eleger o novo Rei
        king = payable(msg.sender); // <------ New King
        // Dobrar o valor de throneAmount
        if (throneAmount * 2 >= INTMAX) {
            throneAmount = 500 wei;
        } else {
            throneAmount = throneAmount * 2;
        }
    }

    function withdrawFees() external {
        emit FeesWithdrawn(wizard, address(this).balance);
        // Enviar o valor para o wizard
        wizard.transfer(address(this).balance); 
    }

    function calculateTotalFee(uint amount) internal view returns (uint) {
        return ( (amount * fee) / 100 ); // assumes amount * fee % 100 é um número inteiro
    }

}