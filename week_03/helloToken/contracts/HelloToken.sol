pragma solidity ^0.4.0;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract HelloToken is StandardToken {

    constructor() public {
        balances[msg.sender] = 1000 ether;
        totalSupply_ = balances[msg.sender];
        emit Transfer(address(0), msg.sender, totalSupply_);
    }

    function freeze(uint toDate) public {
        require(toDate > now);
        require(freezedFounds[msg.sender] < toDate);

        freezedFounds[msg.sender] = toDate;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(freezedFounds[msg.sender] <= now);
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(freezedFounds[_from] <= now);
        return super.transferFrom(_from, _to, _value);
    }

    mapping (address => uint) public freezedFounds;
}
