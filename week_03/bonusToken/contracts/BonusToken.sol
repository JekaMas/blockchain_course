pragma solidity ^0.4.0;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";

contract BonusToken is MintableToken, DetailedERC20 {

    constructor(uint prefund) public
        DetailedERC20("my test token", "MTT", 18)
    {
        balances[msg.sender] = prefund;
        totalSupply_ = balances[msg.sender];
        emit Transfer(address(0), msg.sender, totalSupply_);
    }

    modifier notFrozen(address owner) {
        require(freezedFounds[owner] < now);
        _;
    }

    function freeze(uint toDate) public {
        require(toDate > now);
        require(freezedFounds[msg.sender] < toDate);

        freezedFounds[msg.sender] = toDate;
    }

    function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    mapping (address => uint) public freezedFounds;
}
