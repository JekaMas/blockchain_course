pragma solidity ^0.4.0;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";

contract BonusToken is MintableToken, DetailedERC20 {

    constructor(uint prefund) public
    DetailedERC20("CustomerBonusToken", "CBT", 18)
    {
        balances[msg.sender] = prefund;
        totalSupply_ = balances[msg.sender];
        emit Transfer(address(0), msg.sender, totalSupply_);
    }

    event NewOrder(address indexed owner, uint id, uint256 amount, uint toDate);
    event NewXXX(address indexed owner, order o, bool res);

    function transfer(address _to, uint256 _value) public canPay(msg.sender, _value) returns (bool) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public canPay(_from, _value) returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function makeOrder(uint256 _price, uint _toDate) public canPay(msg.sender, _price) returns (bool) {
        require(_toDate > now);

        uint _orderID = orders.push(order(false, msg.sender, _toDate, _price))-1;
        balancesFrozen[msg.sender] += _price;

        emit NewOrder(msg.sender, _orderID, _price, _toDate);

        return true;
    }

    function orderComplete(uint _orderID) public returns (bool) {
        // check is owner
        order storage userOrder = orders[_orderID];
        require(!userOrder.complete);

        // check signatures of user and seller
        // check is the order belongs to the user

        userOrder.complete = true;
        balancesFrozen[msg.sender] -= userOrder.price;

        //bonus
        //todo: make `1 hours` constant changeable by the contract owner
        if ((userOrder.toDate+1 hours) >= now) {
            //todo: make bonus percent constant changeable by the contract owner
            transfer(userOrder.owner, userOrder.price/10);
        } else {
            transferFrom(msg.sender, owner, userOrder.price/10);
        }

        return true;
    }

    function availableBalanceOf(address who) public view returns (uint256) {
        return balanceOf(who)-balancesFrozen[who];
    }

    modifier canPay(address owner, uint256 _price) {
        require((balanceOf(msg.sender)-balancesFrozen[msg.sender]) >= _price);
        _;
    }

    struct order {
        bool complete;
        address owner;
        uint toDate;
        uint256 price;
    }
    order[] orders;

    mapping(address => uint256) balancesFrozen;
}
