// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9; 

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FukuNFT is ERC721 {

    string public _name;
    string public _symbol;

    uint256 public tokenSupply;
    uint256 public constant MAX_SUPPLY = 6;
    uint256 public constant PRICE = .000001 ether;

    address immutable contractOwner;

    constructor() ERC721("FUKU NFTS", "FUKU"){
        contractOwner = msg.sender;
    }

    function mint() external payable {
        require(tokenSupply < 6, "supply exhausted");
        require(msg.value == PRICE, "wrong price");

        _mint(msg.sender, tokenSupply);
        tokenSupply++;
    }

    function viewBalance() external view returns (uint256){
        return address(this).balance;
    }

    function withdraw() external {
        require(msg.sender == contractOwner, "Only Contract Owner can withdraw");
        payable(msg.sender).transfer(address(this).balance);
    }

    function _baseURI() internal override pure returns (string memory){
        return "ipfs://QmZodqA5bbX5CpHtLogLGcyTgsZr1XfGY38VYcDMeSHa6G/";
    }
}