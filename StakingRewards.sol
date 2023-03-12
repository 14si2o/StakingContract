// SPDX-Licencse-Identifier: MIT
pragma solidity ^0.8.13; 

import "./IERC20.sol";

contract StakingRewards {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;

    address public owner;

    uint public duration;
    uint public finishAt;
    uint public updatedAt;
    uint public rewardRate;
    uint public rewardPerTokenStored;
    mapping(address => uint) public userRewardPerTokenPaid;
    mapping(address => uint) public rewards;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    modifier onlyOwner() {
        require(msg.sender == owner, "not the owner");
        _;
    }

    constructor(address _stakingToken, address _rewardsToken){
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    function setRewardsDuration(uint _duration)  external onlyOwner {
        require(finishAt < block.timestamp, "the rewards duration is not finished");
        duration = _duration;

    }
    function notifyRewardAmount(uint _amount) external onlyOwner {
        if(block.timestamp > finishAt){
            rewardRate = _amount / duration;
        } else {
            uint remainingRewards = rewardRate * (finishAt - block.timestamp);
            rewardRate = (remainingRewards + _amount) / duration;
        }

        require(rewardRate > 0, "reward rate equals to zero" );
        require(
            rewardRate * duration <= rewardsToken.balanceOf(address(this)),
            "reward amount > balance"
        );

        finishAt = block.timestamp + duration;
        updatedAt = block.timestamp;
    }
    function stake(uint _amount) external {
        require(_amount > 0, "amount equals 0");
        stakingToken.transferFrom(msg.sender,address(this),_amount);
        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;
    }
    function withdraw(uint _amount) external {}
    function earned(address _account) external view returns (uint) {}
    function getReward() external {}










}

