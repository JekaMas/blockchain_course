const casinoContract = artifacts.require("Casino.sol");

const minimumBet = 0.1;
const maxAmountOfBets = 3;
const waitForNBlocks = 3;

module.exports = function(deployer, network, accounts) {
    deployer.deploy(casinoContract, web3.toWei(minimumBet, 'ether'), maxAmountOfBets, waitForNBlocks, {from: accounts[0]});
};