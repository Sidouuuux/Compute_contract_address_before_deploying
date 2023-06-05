const { expect } = require("chai");

describe("Create2 contract", function () {
  let Contract;
  let contract;
  let owner;
  beforeEach(async function () {
    [owner] = await ethers.getSigners();

    Contract = await ethers.getContractFactory("Factory");
    contract = await Contract.deploy();
    await contract.deployed();
  });

  it("Should deploy contract at expected address", async function () {
    const byteCode = await contract.getBytecode(owner.address);
    const computedAddress = await contract.getAddress(byteCode, 2140);    
    await expect(await contract.deploy(2140))
      .to.emit(contract, "Deployed")
      .withArgs(computedAddress);
  });
});
