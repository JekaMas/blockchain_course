'use strict';

const token = artifacts.require('VulnerableOne.sol');

module.exports = function(deployer, network) {
    deployer.deploy(token);
};
