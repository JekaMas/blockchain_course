'use strict';

const Hello = artifacts.require('HelloWorld.sol');

const _name = "Who are you"

module.exports = function(deployer, network) {
    deployer.deploy(Hello, _name);
};
