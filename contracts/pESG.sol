pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract pESG is ERC20Burnable { 
    constructor(address owner) ERC20("Alpha ESG", "pESG") {
        _mint(owner, 600000000000000000000000);
    }
}
