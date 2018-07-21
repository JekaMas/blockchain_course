pragma solidity ^0.4.0;

contract Voting {
    uint private startVoting;
    uint private startReveal;
    uint private terminationDate;

    enum VoteType {CON, PRO}

    constructor(uint _startVoting, uint _startReveal, uint _terminationDate) public
    {
        require(_startReveal >= now);
        require(_startVoting < _startReveal);
        require(_startReveal < _terminationDate);

        startVoting = _startVoting;
        startReveal = _startReveal;
        terminationDate = _terminationDate;
    }

    function vote(bytes32 _vote) public canVote(msg.sender) returns (bool) {

        mappedVotes[msg.sender] = votes.push(_vote) - 1;

        return true;
    }

    function reveal(bytes32 _secret) public canReveal(msg.sender) returns (bool) {

        uint256 _secretIdx = secrets.push(_secret) - 1;
        mappedSecrets[msg.sender] = _secretIdx;
        mappedSecretIdx[_secretIdx] = msg.sender;

        return true;
    }

    function calculate() public view returns (uint256, uint256) {
        uint256 _pros;
        uint256 _cons;
        address _userAddress;
        bytes32 _userSecret;
        bytes32 _userVote;

        for (uint _secretIdx = 0; _secretIdx < secrets.length; _secretIdx++) {
            _userAddress = mappedSecretIdx[_secretIdx];
            _userVote = votes[mappedVotes[_userAddress]];
            _userSecret = secrets[_secretIdx];

            if (keccak256(abi.encodePacked(bytes32(uint(VoteType.CON)), _userSecret)) == _userVote) {
                _cons++;
                continue;
            }
            if (keccak256(abi.encodePacked(bytes32(uint(VoteType.PRO)), _userSecret)) == _userVote) {
                _pros++;
                continue;
            }
        }

        return (_cons, _pros);
    }

    modifier canVote(address owner) {
        require(now >= startVoting);
        require(now < startReveal);

        require(votes[mappedVotes[owner]] == 0);
        _;
    }

    modifier canReveal(address owner) {
        require(now >= startReveal);
        require(now < terminationDate);

        require(votes.length > 0);
        require(votes[mappedVotes[owner]] > 0);

        require(secrets[mappedSecrets[owner]] == 0);
        _;
    }

    mapping (address => uint) mappedVotes;
    mapping (address => uint) mappedSecrets;
    mapping (uint => address) mappedSecretIdx;
    bytes32[] votes;
    bytes32[] secrets;
}
