import hardhat, { ethers } from 'hardhat';

async function deployAttentionGame(
	stakingToken: string,
	rewardsToken: string,
	duration: string,
) {
	await hardhat.run('compile');

	console.log("Deploying...");
	const AttentionGame = await ethers.getContractFactory("AttentionGame");
	const attentionGame = await AttentionGame.deploy(
		stakingToken,
		rewardsToken,
		duration
	);
	await attentionGame.deployTransaction.wait(10);
	console.log("Attention game deployed to:", attentionGame.address);

	/**
	 * Verify Contracts
	 */
	console.log('Verifying Attention Game on Etherscan...');
	await hardhat.run('verify:verify', {
		address: attentionGame.address,
		constructorArguments: [stakingToken, rewardsToken, duration]
	});
}

module.exports = deployAttentionGame;