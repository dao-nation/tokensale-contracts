pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSale is Ownable {

  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  event SaleStarted( address indexed activator, uint256 timestamp );
  event SaleEnded( address indexed activator, uint256 timestamp );
  event SellerApproval( address indexed approver, address indexed seller, string indexed message );

  IERC20 public dai;
  IERC20 public pESG;

  address private _saleProceedsAddress;
  uint256 public pESGPrice;
  bool public initialized;
  uint256 buyerCapLimit;

  mapping( address => bool ) public approvedBuyers;
  mapping( address => uint256 ) public buyerCap;
  constructor() {}
    
  function initialize( 
    address pESG_, 
    address dai_,
    uint256 pESGPrice_,
    address saleProceedsAddress_,
    uint256 buyerCapLimit_
  ) external onlyOwner {
    require( !initialized );

    pESG = IERC20( pESG_ );
    dai = IERC20( dai_ );

    pESGPrice = pESGPrice_;
    _saleProceedsAddress = saleProceedsAddress_;
    initialized = true;
    buyerCapLimit = buyerCapLimit_;
  }

  function disable() external onlyOwner {
    initialized = false;
  }

  
  function setBuyerCapLimit(uint256 newBuyerCapLimit_) external onlyOwner {
    buyerCapLimit = newBuyerCapLimit_;
  }
    
  function resetBuyerCap(address buyer_) external onlyOwner{
      buyerCap[buyer_] = 0;
  }

  function setPESGPrice( uint256 newPESGPrice_ ) external onlyOwner() returns ( uint256 ) {
    pESGPrice = newPESGPrice_;
    return pESGPrice;
  }

  function _approveBuyer( address newBuyer_ ) internal onlyOwner() returns ( bool ) {
    approvedBuyers[newBuyer_] = true;
    return approvedBuyers[newBuyer_];
  }

  function approveBuyer( address newBuyer_ ) external onlyOwner() returns ( bool ) {
    return _approveBuyer( newBuyer_ );
  }

  function approveBuyers( address[] calldata newBuyers_ ) external onlyOwner() returns ( uint256 ) {
    for( uint256 iteration_ = 0; newBuyers_.length > iteration_; iteration_++ ) {
      _approveBuyer( newBuyers_[iteration_] );
    }
    return newBuyers_.length;
  }

  function _calculateAmountPurchased( uint256 amountPaid_ ) internal returns ( uint256 ) {
    return amountPaid_.mul( pESGPrice );
  }

  function buyPESG( uint256 amountPaid_ ) external returns ( bool ) {
    require( approvedBuyers[msg.sender], "Buyer not approved." );
    
    uint256 pESGAmountPurchased_ = _calculateAmountPurchased( amountPaid_ );
    
    uint256 newCap = buyerCap[msg.sender].add(pESGAmountPurchased_);  
    require( buyerCapLimit == 0 || newCap <= buyerCapLimit, "Amount exceeds buyer cap limit");

    dai.safeTransferFrom( msg.sender, _saleProceedsAddress, amountPaid_ );
    pESG.safeTransfer( msg.sender, pESGAmountPurchased_ );
    buyerCap[msg.sender] = newCap;
    return true;
  }

  function withdrawTokens( address tokenToWithdraw_ ) external onlyOwner() returns ( bool ) {
    IERC20( tokenToWithdraw_ ).safeTransfer( msg.sender, IERC20( tokenToWithdraw_ ).balanceOf( address( this ) ) );
    return true;
  }
}
