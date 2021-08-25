// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Deployer {
    event Deployed(address contractAddress, bytes salt);

    /**
    * Computes the address of the contract to be deployed
    *
    * contractAddress = keccak256(0xFF, sender, salt, bytecode)
    */
    function computeAddress(bytes memory _bytecode, bytes memory _salt) public view returns (address) {
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(_bytecode)));

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint(hash)));
    }

    /**
    * Deploys new smart contract using CREATE2 opcode
    *
    * create2(v, p, n, s)
    *
    * v - Wei sent with the current call; msg.value
    * p - Actual code starts after skipping the first 32 bytes; 0x20 = 32
    * n - Load the size of code contained in the first 32 bytes
    * s - Big-endian 256-bit value; Salt from function arguments
    *
    * Create2 creates new contract with code at memory :p: to :p: + :n: and send :v: wei and return the new address
    * where new address = first 20 bytes of keccak256(0xff + address(this) + s + keccak256(mem[p…(p+n)))
    */
    function deploy(bytes memory _bytecode, bytes memory _salt) public payable returns(address contractAddress) {
        assembly {
            // create2(v, p, n, s)
            // contractAddress = keccak256(0xFF, sender, salt, bytecode)
            contractAddress := create2(callvalue(), add(_bytecode, 0x20), mload(_bytecode), _salt)
        }

        require(contractAddress != address(0), "Deployer: Failed on deploy with create2");

        emit Deployed(contractAddress, _salt);
    }
}