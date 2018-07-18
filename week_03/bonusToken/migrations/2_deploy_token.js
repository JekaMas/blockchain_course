'use strict';

const token = artifacts.require('BonusToken.sol');

const initialAmount = 1000;

module.exports = function(deployer, network) {
    deployer.deploy(token, web3.toWei(initialAmount, 'ether'));
};
