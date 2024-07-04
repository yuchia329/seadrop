import pkg from "hardhat";
const { ethers } = pkg;

/**
 * @type {import('ethers').Wallet}
 */
let rd, customer;

async function main() {
  const accounts = await ethers.getSigners();
  rd = accounts[0];
  customer = accounts[1];

  const SeaDrop = await ethers.getContractFactory("SeaDrop", rd);
  /** @type {import('../typechain-types').SeaDrop} */
  const seadrop = await SeaDrop.deploy();
  // const seadrop = await SeaDrop.attach(
  //   "0xe0B23d0d68574E3805B08ed0422d6696223399A7"
  // );

  // deploy by customer
  const ERC721SeaDrop = await ethers.getContractFactory(
    "ERC721SeaDrop",
    customer
  );

  const erc721seadrop = await ERC721SeaDrop.connect(customer).deploy(
    "MnemonicX 2048",
    "MNCX",
    [seadrop.address]
  );

  // erc721seadrop.setBaseURI(
  //   "https://staging.asusmeta.co/secux/MNCX/metadata/mneonicx-2048-lootbox.json"
  // );

  // const ERC721PartnerSeaDrop = await ethers.getContractFactory(
  //   "ERC721PartnerSeaDrop",
  //   customer
  // );
  /** @type {import('../typechain-types').ERC721PartnerSeaDrop} */
  // let erc721PartnerSeaDrop = await ERC721PartnerSeaDrop.deploy("", "", rd.address, [
  //   seadrop.address,
  // ]);

  console.log("SeaDrop", seadrop.address);
  console.log("ERC721SeaDrop", erc721seadrop.address);
  // console.log("ERC721PartnerSeaDrop", erc721PartnerSeaDrop.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
