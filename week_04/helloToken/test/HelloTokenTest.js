'use strict';

import expectThrow from './helpers/expectThrow';

const helloToken = artifacts.require('HelloToken.sol');

var Web3 = require('web3');
var web3;
if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

contract('HelloTokenTest', function(accounts) {

    it('test construction', async function() {
        console.log('Balance before the contract deploy: ', await getBalance(accounts[0]));

        const token = await helloToken.new();

        console.log('Balance after the contract deploy: ', await getBalance(accounts[0]));


        var token20 = new web3.eth.Contract(token.abi, token.address);

        let tokens = await token20.methods.balanceOf(accounts[0]).call();
        console.log("The user has tokens: ", tokens);

        await token20.methods.transfer(accounts[1], 1000).send({from: accounts[0], gas: 3000000});

        console.log("The user0 has tokens: ", await token20.methods.balanceOf(accounts[0]).call());
        console.log("The user1 has tokens: ", await token20.methods.balanceOf(accounts[1]).call());
    });
});

async function getBalance(accountAddress) {
    return web3.eth.getBalance(accountAddress, function (error, result) {
        if (!error) {
            return web3.utils.fromWei(result, 'ether');
        } else {
            console.log(error);
        }
    });
}