const multiSigWallet = artifacts.require('multiSigWallet');

contract("multiSigWallet", accounts => {
   let wallet
   const bal = web3.utils.toWei('20', 'ether');

   before(() => {
      return multiSigWallet.deployed().then(instance => {
            wallet = instance;
      });
   });
   
    it("should be able to send balance to contract", async () => {
          await wallet.recieve({value: bal})
          let walletBalance= await wallet.getBalance();
         assert.equal("20000000000000000000", walletBalance,"Ethers successfully recieved")    
     });
})