'use strict';

const voting = artifacts.require('Voting.sol');

module.exports = function(deployer, network) {
    deployer.deploy(voting, startVoting, startReveal, terminationDate);
};
