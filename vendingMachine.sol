// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9; 

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./gsNft.sol";

contract vendingMachine {

    address immutable contractOwner;

    IERC20 public _gsToken;
    gsNft public _gsNft;

    constructor(IERC20 _tokenAddress, gsNft _nftAddress) {
        contractOwner = msg.sender;
        _gsToken = _tokenAddress;
        _gsNft = _nftAddress;
    }

    function depositToMint() external {
        require(_gsToken.balanceOf(msg.sender) >= 10, "not enough GS to mint");

        //_gsToken.approve(msg.sender, 100);
        _gsToken.transferFrom(msg.sender, address(this), 10);
        _gsNft.mint(msg.sender);
    }

    function getUserNftBalance() external view returns (uint256){
        return _gsNft.balanceOf(msg.sender);
    }

    function getGsContractBalance() external view returns (uint256) {
        return _gsToken.balanceOf(address(this));
    }

    function getUserGsBalance() external view returns (uint256) {
        return _gsToken.balanceOf(msg.sender);
    }

    function getUserGsContractAllowance() external view returns (uint256) {
        return _gsToken.allowance(msg.sender, address(this));
    }
}