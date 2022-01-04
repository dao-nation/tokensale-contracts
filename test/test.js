const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TokenSaleTest", function () {
  let
    PESG,
    deployer,
    addr1,
    addr2,
    pESG,
    DAI,
    dai,
    TokenSale,
    tokenSale
    tokenSaleInitialSupply = 150000,
    
  beforeEach(async () => {
    [deployer, addr1, addr2] = await ethers.getSigners();

    PESG = await ethers.getContractFactory('pESG');
    pESG = await PESG.deploy(addr1.address);

    DAI = await ethers.getContractFactory('DAI');
    dai = await DAI.deploy(1337);

    TokenSale = await ethers.getContractFactory('TokenSale')
    tokenSale = await TokenSale.deploy()
    
    await tokenSale.initialize(
      pESG.address,
      dai.address,
      1,
      addr1.address,
      1000
    );
    
    await dai.mint(addr2.address, 1500);
    await pESG.connect(addr1).transfer(tokenSale.address, tokenSaleInitialSupply);
  });

  it("Should be able to buy tokens", async function () {
    await tokenSale.approveBuyer(addr2.address);
    await dai.connect(addr2).approve(tokenSale.address, 500);
    await tokenSale.connect(addr2).buyPESG(500);

    expect(await pESG.balanceOf(tokenSale.address)).to.be.equal(tokenSaleInitialSupply - 500);
    expect(await dai.balanceOf(addr1.address)).to.be.equal(500);
  });

  it("Should not be able to buy tokens if exceeds user cap", async function () {
    await tokenSale.approveBuyer(addr2.address);
    await dai.connect(addr2).approve(tokenSale.address, 500);
    await tokenSale.connect(addr2).buyPESG(500);

    await tokenSale.approveBuyer(addr2.address);
    await dai.connect(addr2).approve(tokenSale.address, 500);
    await expect(tokenSale.connect(addr2).buyPESG(700)).to.be.revertedWith("Amount exceeds buyer cap limit");
  });

  it("Should not be able to buy tokens if not in WL", async function () {
    await expect(tokenSale.connect(addr2).buyPESG(500)).to.be.revertedWith("Buyer not approved.");
  });

  
});
