'use strict';

const token = artifacts.require('Bonus.sol');


module.exports = function(deployer, network) {
    deployer.deploy(token);
};
