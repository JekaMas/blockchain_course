'use strict';

import expectThrow from './helpers/expectThrow';
import {assertBigNumberEqual} from "./helpers/asserts";

const bonusToken = artifacts.require('BonusToken.sol');

const initialAmount = 1000;

contract('BonusTokenTest', function(accounts) {

    it('test construction and pre-found', async function() {
        //given
        const token = await bonusToken.new(wei(initialAmount));

        //then
        assertBigNumberEqual(await token.totalSupply(), wei(1000));
    });

    it('test can order', async function() {
        //given
        const token = await bonusToken.new(wei(initialAmount), {from: accounts[0]});

        //when
        await token.transfer(accounts[1], 1, {from: accounts[0]});

        //then
        await token.makeOrder(1, now()+60, {from: accounts[1]});
    });

    it('test cant transfer freezed', async function() {
        //given
        const token = await bonusToken.new(wei(initialAmount), {from: accounts[0]});

        //when
        await token.transfer(accounts[1], 1, {from: accounts[0]});
        await token.makeOrder(1, now()+60, {from: accounts[1]});

        //then
        await expectThrow(token.makeOrder(1, now()+60, {from: accounts[1]}));
    });

    it('test complete order', async function() {
        //given
        const token = await bonusToken.new(wei(initialAmount), {from: accounts[0]});

        let eventHandler = token.NewOrder({fromBlock: 0, toBlock: 'latest'});
        eventHandler.watch(async function(error, result) {
            if (!error) {
                //then
                await token.orderComplete(result.args.id, {from: accounts[0]});
                console.log("event", result.args, await token.balanceOf(accounts[1]))

                assertBigNumberEqual(await token.balanceOf(accounts[1]), 11);
            }
        });

        //when
        await token.transfer(accounts[1], 10, {from: accounts[0]});
        await token.makeOrder(10, now()+60, {from: accounts[1]});
    });

    it('test complete expired order', async function() {
        //given
        const token = await bonusToken.new(wei(initialAmount), {from: accounts[0]});

        let eventHandler = token.NewOrder({fromBlock: 0, toBlock: 'latest'});
        eventHandler.watch(function(error, result) {
            if (!error) {
                //then
                setTimeout(async function() {
                    console.log("event", result.args)
                    await token.orderComplete(result.args.id, {from: accounts[0]});

                    assertBigNumberEqual(await token.balanceOf(accounts[1]), 9);
                }, 4000);
            }
        });

        //when
        await token.transfer(accounts[1], 10, {from: accounts[0]});
        await token.makeOrder(10, now()+1, {from: accounts[1]});
    });

    it('test contract owner can mint', async function() {
        //given
        const token = await bonusToken.new(wei(initialAmount), {from: accounts[0]});

        //when
        await token.mint(accounts[1], wei(2), {from: accounts[0]});

        //then
        assertBigNumberEqual(await token.totalSupply(), wei(1002));
        assertBigNumberEqual(await token.balanceOf(accounts[1]), wei(2));
    });

    it('test contract owner can mint many accounts', async function() {
        //given
        const token = await bonusToken.new(wei(initialAmount), {from: accounts[0]});

        //when
        await token.mint(accounts[1], wei(2), {from: accounts[0]});
        await token.mint(accounts[2], wei(3), {from: accounts[0]});

        //then
        assertBigNumberEqual(await token.totalSupply(), wei(1005));
        assertBigNumberEqual(await token.balanceOf(accounts[1]), wei(2));
        assertBigNumberEqual(await token.balanceOf(accounts[2]), wei(3));
    });
});

// converts amount of token into token-wei (smallest token units)
function wei(amount) {
    return web3.toWei(amount, 'ether');
}

function now() {
    return Math.floor(Date.now() / 1000);
}