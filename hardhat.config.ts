import { task } from 'hardhat/config';
import '@nomiclabs/hardhat-waffle';
import '@nomiclabs/hardhat-etherscan';
import 'hardhat-abi-exporter';
import 'hardhat-typechain';
import 'solidity-coverage';
import 'hardhat-gas-reporter';
import * as config from './config';

module.exports = {
	solidity: {
		version: '0.8.10',
		settings: {
			optimizer: {
				enabled: true,
				runs: 9999,
				details: {
					yul: false
				}
			},
		},
	},
	defaultNetwork: 'hardhat',
	namedAccounts: {
		deployer: {
			default: 0, // here this will by default take the first account as deployer
		},
	},
	networks: config.networks,
	etherscan: config.etherscan,
	gasReporter: {
		enabled: !!(process.env.REPORT_GAS)
	},
};
