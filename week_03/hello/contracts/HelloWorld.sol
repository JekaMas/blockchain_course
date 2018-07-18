pragma solidity ^0.4.0;

contract HelloWorld {
    string userName;

    constructor(string name) public {
        userName = name;
    }

    function modify_name(string name) public {
        userName = name;
    }

    function hello() public view returns (string) {
        return userName;
    }
}
