const multiSigWallet = artifacts.require("multiSigWallet");
module.exports = function(deployer) {
  deployer.deploy(multiSigWallet, "1");
};