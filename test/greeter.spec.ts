import { expect } from 'chai';
import { ethers } from 'hardhat';
import { Contract } from 'ethers';
import { getCreate2Address, keccak256 } from 'ethers/lib/utils';
import { bytecode } from '../artifacts/contracts/Greeter/Greeter.sol/Greeter.json';

describe(`Greeter`, async function () {
	let deployer: Contract;

	beforeEach(async function () {
		const deployerFactory = await ethers.getContractFactory(`DeployerV2`);
		deployer = await deployerFactory.deploy();
		await deployer.deployed();
	});

	it('should have the same computed addresses', async () => {
		const salt = keccak256([0x12]);

		// Precompute address using Deployer smart contract
		const solidityPrecomputed = await deployer.computeAddress(salt);

		// Precomupte address using ethers.js library
		const initCodeHash = keccak256(bytecode);
		const ethersPrecomputed = getCreate2Address(deployer.address, salt, initCodeHash);

		expect(solidityPrecomputed).to.equal(ethersPrecomputed);
	});
});
