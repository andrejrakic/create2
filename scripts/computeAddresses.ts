import { ethers, run } from 'hardhat';
import { getCreate2Address, keccak256 } from 'ethers/lib/utils';
import { bytecode } from '../artifacts/contracts/Greeter/Greeter.sol/Greeter.json';

const main = async () => {
	await run('compile');

	const deployerFactory = await ethers.getContractFactory(`DeployerV2`);
	const deployer = await deployerFactory.deploy();
	await deployer.deployed();

	for (let i = 0x0; i < 0x12; i++) {
		const salt = keccak256([i]);
		const initCodeHash = keccak256(bytecode);
		const address = getCreate2Address(deployer.address, salt, initCodeHash);
		console.log(address);
	}
};

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
