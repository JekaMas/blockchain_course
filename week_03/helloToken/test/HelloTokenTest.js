'use strict';

import expectThrow from './helpers/expectThrow';

const helloToken = artifacts.require('HelloToken.sol');

contract('HelloTokenTest', function(accounts) {

    it('test construction', async function() {
        const token = await helloToken.new();
    });

    it('test can transfer not freezed', async function() {
        //given
        const token = await helloToken.new({from: accounts[0]});

        //when
        await token.transfer(accounts[1], 1000, {from: accounts[0]});

        //then
        await token.transfer(accounts[1], 1000, {from: accounts[0]});
    });

    it('test cant transfer freezed', async function() {
        //given
        const token = await helloToken.new({from: accounts[0]});

        //when
        await token.transfer(accounts[1], 1000, {from: accounts[0]});
        await token.freeze(20000000000, {from: accounts[0]});

        //then
        await expectThrow(token.transfer(accounts[1], 1000, {from: accounts[0]}));
    });
});
