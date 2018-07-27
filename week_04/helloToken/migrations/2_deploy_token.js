'use strict';

const token = artifacts.require('HelloToken.sol');


module.exports = function(deployer, network) {
    deployer.deploy(token);
};
