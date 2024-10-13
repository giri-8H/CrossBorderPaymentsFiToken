
# Instant Cross-Border Payments Using FiToken

## Introduction

This project demonstrates instant cross-border payments using a blockchain-based solution powered by **FiToken**, a stablecoin pegged to a basket of currencies. The solution leverages Ethereum smart contracts, allowing users to send payments directly to recipients across borders with minimal fees and real-time transactions.

## Key Features

- **Instant Cross-Border Payments**: Enables real-time payments across international borders.
- **FiToken Integration**: Transactions are conducted using **FiToken**, a stablecoin pegged to multiple currencies, minimizing volatility.
- **Smart Contracts**: Automates transaction validation and processing using Ethereum smart contracts.
- **Multi-Currency Wallet**: A decentralized wallet supports holding both **FiToken** and other fiat currencies.

## Technology Stack

- **Ethereum Blockchain**: The platform used for deploying and executing smart contracts.
- **Solidity**: The programming language for writing smart contracts.
- **Truffle**: A development framework for Ethereum.
- **Ganache**: A local blockchain for testing and development.
- **Web3.js**: JavaScript library to interact with the Ethereum blockchain.

## Prerequisites

- **Node.js** (v16.x or later) and npm (v7.x or later)
- **Truffle** (v5.11.5)
- **Ganache** (v7.9.1) – for a local Ethereum blockchain
- A web browser extension like **MetaMask** (for interacting with the DApp)

## Getting Started

### 1. Clone the Repository

git clone https://github.com/giri-8H/CrossBorderPaymentsFiToken.git
cd cross-border-payments-fitoken


### 2. Install Dependencies

Ensure you have all required dependencies installed:

npm install


### 3. Start Ganache

Start the local Ethereum blockchain using Ganache:


ganache-cli

OR use the **Ganache GUI** and ensure it runs on port `7545`.

### 4. Compile the Smart Contracts

Compile the **FiToken** smart contract and other related contracts:

truffle compile


### 5. Deploy the Smart Contracts

Deploy the compiled smart contracts to the Ganache local blockchain:

truffle migrate --network development


### 6. Interact with the Smart Contracts

truffle console --network development

## Smart Contracts Overview

### FiToken.sol

The smart contract for **FiToken**, a stablecoin pegged to a basket of currencies. It allows users to exchange, send, and receive **FiToken** for cross-border payments.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract FiToken {
    string public name = "FiToken";
    string public symbol = "FIT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply) {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_from != address(0), "Invalid sender address");
        require(_to != address(0), "Invalid receiver address");
        require(_value <= balanceOf[_from], "Insufficient balance");
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
```

### CrossBorderPayment.sol

This contract handles cross-border payments using **FiToken**.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface FiToken {
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
}

contract CrossBorderPayment {
    address public owner;
    FiToken public token;

    event PaymentSent(address indexed sender, address indexed receiver, uint amount);

    constructor(address _tokenAddress) {
        owner = msg.sender;
        token = FiToken(_tokenAddress);
    }

    function sendPayment(address receiver, uint amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(token.transferFrom(msg.sender, receiver, amount), "Payment failed");
        emit PaymentSent(msg.sender, receiver, amount);
    }
}
```

## How to Use

1. **Sender**: Deposits **FiToken** into the smart contract.
2. **Smart Contract**: Transfers the specified amount of **FiToken** to the receiver after verifying the sender’s balance and completing the transaction on-chain.
3. **Receiver**: Receives **FiToken** in their wallet, which can be exchanged or used in the local market.

## Frontend Interaction

To interact with the deployed contracts, you can use a frontend interface. Here's a simplified code to integrate with Web3.js:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cross-Border Payments Demo</title>
</head>
<body>
    <h1>Send Cross-Border Payment</h1>
    <input type="text" id="receiver" placeholder="Receiver Address">
    <input type="text" id="amount" placeholder="Amount (in Ether)">
    <button id="sendPayment">Send Payment</button>

    <script src="https://cdn.jsdelivr.net/npm/web3@1.6.0/dist/web3.min.js"></script>
    <script>
        // const web3 = new Web3(Web3.givenProvider || "http://localhost:7545");
        let web3;
        let contract;
        const contractAddress = "0x7f12b1E0b1534788c0a53c9c97E9f39FFeb556Fd"; // Replace with your contract address
        const contractABI = [
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "sender",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "receiver",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "PaymentSent",
      "type": "event"
    },
    {
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "address payable",
          "name": "receiver",
          "type": "address"
        }
      ],
      "name": "sendPayment",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function",
      "payable": true
    }
  ]; // Replace with the ABI from the build folder

  // Initialize the contract
//   const contract = new web3.eth.Contract(contractABI, contractAddress);

        async function load() {
            if (window.ethereum) {
                web3 = new Web3(window.ethereum);
                await ethereum.enable();
                const accounts = await web3.eth.getAccounts();
                console.log('Connected account:', accounts[0]);

                contract = new web3.eth.Contract(contractABI, contractAddress);
                console.log(contract)
            } else {
                alert('Please install MetaMask or another Ethereum wallet.');
            }
        }

        async function sendPayment() {
            const receiver = document.getElementById('receiver').value;
            const amount = document.getElementById('amount').value;
            const accounts = await web3.eth.getAccounts();

           
            try {
                await contract.methods.sendPayment(receiver).send({
                    from: accounts[0],
                    value: web3.utils.toWei(amount, 'ether')
                });
                alert('Payment sent!');
            } catch (error) {
                console.error('Error sending payment:', error);
            }

            alert('Payment Sent!');
        }

        document.getElementById('sendPayment').onclick = sendPayment;

        window.onload = load;
    </script>
</body>
</html>

```

