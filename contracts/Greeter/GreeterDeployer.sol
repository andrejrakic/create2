// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Deployer } from "../Deployer.sol";
import { Greeter } from "./Greeter.sol";

contract GreeterDeployer is Deployer {
    function getBytecode(string memory _greeting) public pure returns (bytes memory) {
        bytes memory bytecode = type(Greeter).creationCode;

        return abi.encodePacked(bytecode, abi.encode(_greeting));
    }

    function deployGreeter(string memory _greeting, bytes memory _salt) public payable returns(address greeterAddress) {
        bytes memory _bytecode = getBytecode(_greeting);

        greeterAddress = deploy(_bytecode, _salt);
    }
}