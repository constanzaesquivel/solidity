// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract Faucet{

    address payable owner;

    constructor() payable {   
        owner = payable(msg.sender); 
    }   

    modifier onlyOwner {
    require(owner == msg.sender, "Only owner can do this");
    _;
    }
    
    function getBalance() private view returns (uint256) {
        return address(this).balance;
    }

    function inject() external payable onlyOwner returns(uint256) {
    }

    function send() external payable {
        require(owner != to,"Owner can't do this");
        require(getBalance >= 0.01 ether, "Insufficient balance");
        
        address payable to = payable(msg.sender);
        uint256 amount = 0,01 ether;

        to.transfer(amount); 
    }

    function emergencyWithrow() external onlyOwner {

        uint256 amount = getBalance();
        owner.transfer(amount); 
    }

    function setOwner(address payable newOwner) external onlyOwner{
        owner = newOwner;
    }

    function destroy() external onlyOwner{
        selfdestruct(owner);
    }

}