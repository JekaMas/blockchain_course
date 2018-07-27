pragma solidity 0.4.23;

import "zeppelin-solidity/contracts/math/SafeMath.sol";

/*
todo:
contract creator becomes the first superuser.
Then he adds new users and superusers. Every superuser can add new users and superusers;
If user sends ether, his balance is increased. Then he can withdraw ether from his balance;
*/

contract VulnerableOne {
    using SafeMath for uint;

    struct UserInfo {
        uint256 created;
        uint256 ether_balance;
    }

    mapping (address => UserInfo) public users_map;
    mapping (address => bool) is_super_user;
    address[] users_list;

    modifier onlySuperUser() {
        require(is_super_user[msg.sender] == true);
        _;
    }

    //fixme: a dead code
    event UserAdded(address new_user);

    constructor() public {
        set_super_user(msg.sender);
        add_new_user(msg.sender);
    }

    // fixme: anyone can add a superuser
    function set_super_user(address _new_super_user) public {
        is_super_user[_new_super_user] = true;
    }

    function pay() public payable {
        require(users_map[msg.sender].created != 0);
        users_map[msg.sender].ether_balance += msg.value;
    }

    function add_new_user(address _new_user) public onlySuperUser {
        require(users_map[_new_user].created == 0);
        users_map[_new_user] = UserInfo({ created: now, ether_balance: 0 });
        users_list.push(_new_user);
    }

    // fixme: onlySuperUser should be added
    function remove_user(address _remove_user) public {
        //fixme: msg.sender -> _remove_user
        require(users_map[msg.sender].created != 0);
        //fixme Do not delete a user only mark he/she as deleted. Gas DoS issue.
        delete(users_map[_remove_user]);

        bool shift = false;
        for (uint i=0; i<users_list.length; i++) {
            if (users_list[i] == _remove_user) {
                shift = true;
            }
            if (shift == true) {
                // fixme: wont work if users_list.length == 1 || i == users_list.length-1
                users_list[i] = users_list[i+1];
            }
        }
    }

    function withdraw() public {
        //fixme: reentrancy
        msg.sender.transfer(users_map[msg.sender].ether_balance);
        users_map[msg.sender].ether_balance = 0;
    }

    function get_user_balance(address _user) public view returns(uint256) {
        return users_map[_user].ether_balance;
    }

}