// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9; 

import "./gsToken.sol";
import "./gsNft.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract vendingMachine is IERC721Receiver {
  
    address immutable contractOwner;

    gsToken public _gsToken;
    gsNft public _gsNft;

    mapping (uint256 => address) public nftOwner; 
    mapping (address => uint256) private depositTime; 
    mapping (address => uint) private stakeWithdrawals; 
    mapping (address => uint256) private lastStake;

    uint private daysDiff;
    uint private availableWithdrawl; 

    constructor(gsToken _tokenAddress, gsNft _nftAddress) {
        contractOwner = msg.sender;
        _gsToken = _tokenAddress;
        _gsNft = _nftAddress;
    }

    function depositNft(uint256 _tokenId) external {
        nftOwner[_tokenId] = msg.sender;
        depositTime[msg.sender] = block.timestamp;
        _gsNft.safeTransferFrom(msg.sender, address(this), _tokenId);
    }

    function withdrawNft(uint256 _tokenId) external {
        require(nftOwner[_tokenId] == msg.sender, "Must be owner to withdraw");
        
        //clear the state in the contract for this nft
        depositTime[msg.sender]=0;
        nftOwner[_tokenId] = address(0);

        _gsNft.safeTransferFrom(address(this), msg.sender, _tokenId);
    }

    //calculate the time since deposit and check against the # of withdrawls the user already made
    //if stakes available, mint to contract then xfer to user
    function withdrawStake() external {
        //converts to days since deposit
        daysDiff = (block.timestamp - depositTime[msg.sender]) / 60 / 60 / 24;
        //checks against any withdrawals already made 
        availableWithdrawl = daysDiff - stakeWithdrawals[msg.sender];

        require(depositTime[msg.sender] != 0, "no deposited nft");
        require(availableWithdrawl > 0, "no stake available");

        //if there is a full days worth available, mint and xfer to user
        //increment stakeWithdrawals to keep track of the 24 hour periods    
        for (availableWithdrawl; availableWithdrawl >= 1; availableWithdrawl--){
            _gsToken.mint();
            _gsToken.transferFrom(address(this), msg.sender, 10);
            stakeWithdrawals[msg.sender]++;
        }
    }

     function checkStake() external returns (uint256) {
        //converts to days since deposit
        daysDiff = (block.timestamp - depositTime[msg.sender]) / 60 / 60 / 24;

        return daysDiff;
    }

    function mintGs() external {
        _gsToken.mint();
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4){
        return IERC721Receiver.onERC721Received.selector;
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

    function getContractNftBalance() external view returns (uint256) {
        return _gsNft.balanceOf(address(this));
    }
}