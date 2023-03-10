// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9; 

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract gsNft is ERC721 {
    uint256 public tokenSupply;

    address[] private _admins;

    address immutable contractOwner;

    constructor() ERC721("Gabe NFT", "GS"){
        contractOwner = msg.sender;
        _admins.push(contractOwner);
    }

    function mint(address account) external payable {
        require(isAdmin(msg.sender), "Only admins can mint");
        _mint(account, tokenSupply);
        tokenSupply++;
    }

    function getTokenSupply() external view returns (uint256){
        return tokenSupply;
    }

    /*this function will add the account address passed in to the admins list
    * must be an admin to use
    */ 
    function addAdmins(address account) public {
        require((isAdmin(msg.sender)), "Sorry, only admins can add"); 
        _admins.push(account);
    }

    /*this function will check to the account address passed in against the 
     * admins list and return a bool
    */ 
    function isAdmin(address account) public view returns (bool){
        bool accountAdmin = false; 
        for (uint i=0; i < _admins.length; i++){
            if (_admins[i] == account) 
                accountAdmin = true; 
        }
        return accountAdmin;
    }
}