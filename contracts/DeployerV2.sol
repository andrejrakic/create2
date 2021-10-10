// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";
import { Greeter } from "./Greeter/Greeter.sol";

contract DeployerV2 {
    event Deployed(address contractAddress, bytes32 salt);

    function computeAddress(bytes32 _salt) public view returns(address) {
        bytes memory _bytecode = type(Greeter).creationCode;

        return Create2.computeAddress(_salt, keccak256(_bytecode));
    }

    function deployGreeter(bytes32 _salt) public payable returns(address greeterAddress) {
        greeterAddress = Create2.deploy(0, _salt, type(Greeter).creationCode);

        emit Deployed(greeterAddress, _salt);
    }

}