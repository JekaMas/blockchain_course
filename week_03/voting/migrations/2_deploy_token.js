'use strict';

const voting = artifacts.require('Voting.sol');
const startVoting = new Date();
const startReveal = addDays(startVoting, 2);
const terminationDate = addDays(startReveal, 2);

module.exports = function(deployer, network) {
    deployer.deploy(voting, startVoting.getTime(), startReveal.getTime(), terminationDate.getTime());
};

function addDays(date, days) {
    var result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
}