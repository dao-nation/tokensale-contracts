pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract pGIVE is ERC20Burnable { 
    constructor(address owner) ERC20("Alpha GIVE", "pGIVE") {
        _mint(owner, 600000000000000000000000);
    }
}