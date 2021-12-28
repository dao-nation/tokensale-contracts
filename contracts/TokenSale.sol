pragma solidity 0.8.4;

import "./Crowdsale.sol";
import "./AllowanceCrowdsale.sol";
import "./WhitelistedCrowdsale.sol";


contract MyCrowdsale is Crowdsale, AllowanceCrowdsale, WhitelistedCrowdsale {
    constructor(
        uint256 rate,
        address payable wallet,
        IERC20 token,
        address tokenWallet  // <- new argument
    )
        AllowanceCrowdsale(tokenWallet)  // <- used here
        Crowdsale(rate, wallet, token)
        WhitelistedCrowdsale()
        public
    {

    }

    function _deliverTokens(
        address _beneficiary,
        uint256 _tokenAmount
    )
        internal override(Crowdsale, AllowanceCrowdsale)
    {
        AllowanceCrowdsale._deliverTokens(_beneficiary, _tokenAmount);
    }

    function _preValidatePurchase(
        address _beneficiary,
        uint256 _weiAmount
    )
        internal override(Crowdsale, WhitelistedCrowdsale)
        // isWhitelisted(_beneficiary)
        // onlyWhileOpen
    {
        WhitelistedCrowdsale._preValidatePurchase(_beneficiary, _weiAmount);
    }
}