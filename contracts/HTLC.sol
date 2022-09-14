// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HTLC {
    uint256 public startTime;
    uint256 public lockTime = 10000 seconds;
    string public secret; //abracadabra
    bytes32 public hash =
        0xfd69353b27210d2567bc0ade61674bbc3fc01a558a61c2a0cb2b13d96f9387cd;
    address public recipient;
    address public owner;
    uint256 public amount;
    IERC20 public token;

    constructor(
        address _recipient,
        address _token,
        uint256 _amount
    ) {
        recipient = _recipient;
        owner = msg.sender;
        amount = _amount;
        token = IERC20(_token);
    }

    function fund() external {
        startTime = block.timestamp;
        token.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(string memory _secret) external {
        require(keccak256(abi.encodePacked(_secret)) == hash, "wrong secret");
        secret = _secret;
        token.transfer(recipient, amount);
    }

    function refund() external {
        require(block.timestamp > startTime + lockTime, "too early");
        token.transfer(owner, amount);
    }
}
