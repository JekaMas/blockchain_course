'use strict';

import expectThrow from './helpers/expectThrow';
import {assertBigNumberEqual} from "./helpers/asserts";

const contract = artifacts.require('VulnerableOne.sol');

contract('VulnerableOneTest', function(accounts) {

    it('test construction and pre-found', async function() {
        //given
        const token = await contract.new({from: accounts[0]});

        //then
        assert(await token.users_map(accounts[0]), {});
        assert(await token.is_super_user(accounts[0]), true);
    });
});

// converts amount of token into token-wei (smallest token units)
function wei(amount) {
    return web3.toWei(amount, 'ether');
}

function now() {
    return Math.floor(Date.now() / 1000);
}