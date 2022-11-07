// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Vault {

    error ZeroAmountDeposited();
    error YouHaveZeroBalance();

    mapping (address => uint) public balances;

    event VaultBalance(uint balance);
    event withdrawalMade(address _address, uint amount);
    event depositMade(address _address, uint amount);

    function deposit () external payable{
        if (msg.value <= 0) revert ZeroAmountDeposited();
        balances[msg.sender] += msg.value;
        
        emit depositMade(msg.sender, msg.value);
        emit VaultBalance(address(this).balance);      
    }

    function withdraw () external {
        if(balances[msg.sender] == 0) revert YouHaveZeroBalance();
        uint balanceBefore = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(balanceBefore);
        
        emit withdrawalMade(msg.sender, balanceBefore);
        emit VaultBalance(address(this).balance);   
    }

    receive () external payable {
        balances[msg.sender] += msg.value;
    }
}