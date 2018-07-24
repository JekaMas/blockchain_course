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

        // reserve 0 indexes as 'not defined'
        votes.push("");
        secrets.push("");
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

    function getVote(uint _voteType, bytes32 _userSecret) pure public returns (bytes32) {
        require(uint(VoteType.CON) == _voteType || uint(VoteType.PRO) == _voteType);

        return keccak256(abi.encodePacked(bytes32(_voteType), _userSecret));
    }

    modifier canVote(address _owner) {
        require(now >= startVoting);
        require(now < startReveal);

        require(mappedVotes[_owner] == 0);

        _;
    }

    modifier canReveal(address _owner) {
        require(now >= startReveal);
        require(now < terminationDate);

        require(votes[mappedVotes[_owner]] != "");

        require(mappedSecrets[_owner] == 0);
        _;
    }

    mapping (address => uint) internal mappedVotes;
    mapping (address => uint) internal mappedSecrets;
    mapping (uint => address) internal mappedSecretIdx;
    bytes32[] internal votes;
    bytes32[] internal secrets;
}
