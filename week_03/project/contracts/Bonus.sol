pragma solidity ^0.4.0;

import "zeppelin-solidity/contracts/token/ERC20/BasicToken.sol";

contract Bonus is BasicToken {

    address public owner;

    constructor() public {
        balances[msg.sender] = 42;
        totalSupply_ = balances[msg.sender];
        owner = msg.sender;
        emit Transfer(address(0), msg.sender, totalSupply_);
    }
    struct order {
        uint cost;
        uint timeToGet;
        bool done;
    }
    mapping (address => order) allOrders;

    event eventTime(uint orderTime, uint nowTime);

    function makeOrder(uint _cost, uint _timeToGet) public {
        emit eventTime(_timeToGet, now - 30 minutes);

        require(_timeToGet >= now - 1 hours);
        // todo: сделать проверку время заказа и реальноого времени
        allOrders[msg.sender] = order(_cost, _timeToGet, false);

        emit eventTime(_timeToGet, allOrders[msg.sender].timeToGet);
    }

    function compliteOrder(address _user) public {
        //выполняется проверка что msg.sender это владелец контракта
        require(msg.sender == owner);

        //создаю _order, в который помещаю структуру из массива allOrders по ключу msg.sender
        order storage _order = allOrders[_user];

        emit eventTime(_order.timeToGet, now - 30 minutes);
        if (_order.timeToGet >= (now - 30 minutes)) {
            transfer(_user, 1);
        }

        //присвоение значения true переменной done структуры order из массива allOrders по ключу msg.sender
        _order.done = true;
    }
}
