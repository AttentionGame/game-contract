<div align="center">

# Attention Game

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

## Overview

Attention game is an on-chain NFT social game experiment inspired by Status as a Service, exploring the idea of a decentralized social ecosystem where NFTs can be used for showcasing or advertising, and featuring HexNFTs that can be minted only if adjacent to an existing one, and can be staked with other NFTs for display and token rewards.

## Development

**Prerequisites**

- [hardhat](https://hardhat.org/) - framework used for the development and testing of the contracts
- `node version >= 14.14.0`

1. After cloning, run:

```
npm install
```

2. Set up the config file by executing:

```bash
cp config.sample.ts config.ts
``` 

### Compilation

Before you deploy the contracts, you will need to compile them using:

```
npx hardhat compile
```

### Deployment

**Prerequisite**

Before running the deployment `npx hardhat` script, you need to create and populate the `config.ts` file. You can use
the `config.sample.ts` file and populate the following variables:

```markdown
YOUR-INFURA-API-KEY YOUR-ETHERSCAN-API-KEY
```

### Tests

#### Unit Tests

```bash
npx hardhat test
```

#### Coverage

```bash
npm run coverage
```

or

```bash
npx hardhat coverage --solcoverjs .solcover.ts
```
