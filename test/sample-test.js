const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TokenSaleTest", function () {
  let
    PGIVE,
    deployer,
    addr1,
    pGIVE,
    DAI,
    dai,
    TokenSale,
    tokenSale

  beforeEach(async () => {
    [deployer, addr1] = await ethers.getSigners();

    PGIVE = await ethers.getContractFactory('pGIVE');
    pGIVE = await PGIVE.deploy(addr1.address);

    DAI = await ethers.getContractFactory('DAI');
    dai = await DAI.deploy(9);

    TokenSale = await ethers.getContractFactory('TokenSale')
    tokenSale = await TokenSale.deploy()
    
    await tokenSale.initialize(
      pGIVE.address,
      dai.address,
      1,
      addr1.address,
      1000
    );
  
  });

  it("Should be able to buy tokens", async function () {
    
  });
});
