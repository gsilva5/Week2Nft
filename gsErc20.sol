// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9; 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract gsToken is ERC20 {

    address contractOwner; 
    uint256 public constant MAX_SUPPLY = 10000; 

    constructor() ERC20("Gabe", "GS"){
        contractOwner = msg.sender;
    }

    function mint() external {
        require(totalSupply() <= 9900, "max supply reached");
        approve(tx.origin, 10);
        _mint(msg.sender, 100);
    } 

    function burn() external {
        require(balanceOf(msg.sender) >= 100, "not enough tokens to burn");
        _burn(msg.sender, 100);
    }
}