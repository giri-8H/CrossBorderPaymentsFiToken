// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CrossBorderPayment {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    event PaymentSent(address indexed sender, address indexed receiver, uint amount);

    function sendPayment(address payable receiver) public payable {
        require(msg.value > 0, "Payment must be greater than 0");
        require(receiver != address(0), "Invalid receiver address");

        (bool success, ) = receiver.call{value: msg.value}("");
        require(success, "Transfer failed");

        emit PaymentSent(msg.sender, receiver, msg.value);
    }
}
