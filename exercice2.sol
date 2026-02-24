// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract SimpleToken{
    mapping(address => uint256) private balances;
    address public owner;

    event Transfer(address from ,address indexed to, uint256 amount);
    event Mint(address indexed to ,uint256 amount);
    event Burn(address indexed from ,uint256 amount);

   
    modifier onlyPositive(uint256 _amount){
        require(_amount > 0 , "Amount must be positive");
        _;
    }

    modifier onlyEnough(uint256 _amount){
        require(balances[msg.sender] >= _amount , "Insufficient balance");
        _;
    }
    constructor(){
        owner = msg.sender;
    }

    function mint(address _to,uint256 _amount) external  onlyPositive(_amount){
        balances[_to] += _amount;
        emit Mint(_to,_amount);
    }

    function burn(uint256 _amount) external  onlyPositive(_amount) onlyEnough(_amount){
        balances[msg.sender] -= _amount;
        emit Burn(msg.sender,_amount);
    }

    


    }
    


    
   
 
    

