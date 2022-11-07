//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Vault.sol";

contract testVault is Test{

    Vault vault;
    address attacker;
    uint balanceBefore;

    function setUp() public{
        vault = new Vault();

        attacker = msg.sender;
        vm.label(attacker, "attacker");
        vm.deal(attacker, 100 ether);

        vm.label(address(vault), "Vault Contract");
        
        balanceBefore = address(vault).balance;
        emit log_uint(balanceBefore);
    }

    function testDeposit() public {
        vm.startPrank(attacker);

        vault.deposit{value: 1 ether}();
        assertEq(address(vault).balance, balanceBefore + 1 ether);
        assertEq(vault.balances(attacker), 1 ether);
        emit log_uint(vault.balances(attacker));
        emit log_uint (address(vault).balance);

        vm.stopPrank();
    }

    function testWithdraw() public {
        vm.startPrank(attacker);

        vault.deposit{value: 2 ether}();
        emit log_uint(vault.balances(attacker));
        emit log_uint (address(vault).balance);
        emit log_uint (attacker.balance);

        vault.withdraw();
        assertEq(vault.balances(attacker), 0);
        assertEq(address(vault).balance, 0);
        assertEq(attacker.balance, 100 ether);

        vm.stopPrank();
    }

}