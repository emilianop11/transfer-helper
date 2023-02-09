// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract Helper {
    address warrantyTokenAddress;
    address escrowContractOwner;

    constructor(address _tokenAddress) {
        warrantyTokenAddress = _tokenAddress;
        escrowContractOwner = msg.sender;
    }

    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function transferFrom(address _from, address _to, uint256 _amount) public {
        require(msg.sender == escrowContractOwner, "method can only be called by owner");
        ERC20(warrantyTokenAddress).transferFrom(_from, _to, _amount);
    }

    function swapForMatic(address payable _to, uint256 _maticAmount, uint256 _tokenAmount) public {
        // this matic should be held as balance in the contract.
        // msg.sender pays for the tx fee, and matic gets deducted from the contract balance
        require(msg.sender == escrowContractOwner, "method can only be called by owner");
        ERC20(warrantyTokenAddress).transferFrom(_to, escrowContractOwner, _tokenAmount);
        bool sent = _to.send(_maticAmount);
        require(sent, "Failed to send Ether");
    }

    function transferFromWithFee(address _from, address _to, uint256 _amount, uint256 _feeBase) public {
        // tx fee gets paid by the msg.sender
        require(msg.sender == escrowContractOwner, "method can only be called by owner");
        require(_feeBase > 0, "fee base cant be 0");
        require(ERC20(warrantyTokenAddress).balanceOf(_from) > (_amount + (_amount/_feeBase)), "Sender doesnt have sufficient funds");

        ERC20(warrantyTokenAddress).transferFrom(_from, escrowContractOwner, _amount/_feeBase);
        ERC20(warrantyTokenAddress).transferFrom(_from, _to, _amount);
    }

    function transferFromWithReferrer(address _from, address _to, uint256 _amount, uint256 _feeBase, address _referrer) public {
        require(msg.sender == escrowContractOwner, "method can only be called by owner");
        require(_feeBase > 0, "fee base cant be 0");
        require(ERC20(warrantyTokenAddress).balanceOf(_from) > (_amount + (_amount/_feeBase)), "Sender doesnt have sufficient funds");

        ERC20(warrantyTokenAddress).transferFrom(_from, _referrer, _amount/(2*_feeBase));
        ERC20(warrantyTokenAddress).transferFrom(_from, escrowContractOwner, _amount/(2*_feeBase));
        ERC20(warrantyTokenAddress).transferFrom(_from, _to, _amount);
    }
}