const multiSigWallet = artifacts.require('multiSigWallet');
const ethers = require('ethers')
contract("multiSigWallet", accounts => {
   let wallet

   before(() => {
      return multiSigWallet.deployed().then(instance => {
            wallet = instance
      })
   })
   
    it("should be able to send balance to contract", async () => {
          await wallet.recieve({value: web3.utils.toWei('20', 'ether')})
          let walletBalance= await wallet.getBalance()
         assert.equal("20000000000000000000", walletBalance,"Contract successfully recieved ethers")    
     })

    
     it("should be able to add new Owner to  contract", async () => {
      await wallet.addOwner(accounts[1])
      let res= await wallet.isOwner(accounts[1])
      assert.equal(true,res, "Owner Successfully added")
     })


      
     it("should be able to change Consensus type", async () => {
      await wallet.changeConsensusType(2)
      let res= await wallet.getConsensus()
       assert.equal(2,res, "Owner Successfully added")
     })
     
     
   /*  it("should be able to sign transcation", async () => {
      let amt =web3.utils.toWei('2', 'ether')
      await wallet.changeConsensusType(1)
      await wallet.signSendEthers(accounts[3],amt)
     })

     it("should be able to send transcation", async () => {
   //    let res= await wallet.send(accounts[3], amt )
     // console.log(res)
      // assert.equal(2,res, "Owner Successfully added")
     })
  */

})