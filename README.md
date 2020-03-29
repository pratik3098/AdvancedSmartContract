## AdvancedSmartContractFinalAssignment
 Pratik Patil
 101284380
## Overview
 This is a multisignature wallet to send and recieve ethers using signing and verification patterns.

## Description
  The wallet can have maximum of 3 owners. 
  The wallet supports three consensus mechanisms:
  1. Atleast one owner 2. Majority of owners 3.All of the owners 
  
  Based on these consenus mechnaisms a transcation is approved for sending the ethers. 


## Signing and verification 
  When approving the send transcation, the signature is verified to see if the signee  is one of the owner of the wallet and is the one invoking this transcation. 


## Approval of the transcation
  If the signature is verified successfully, the payee address and the amount to be sent are hashed together and stored in the maping with aprroval flag as true.

## Sending the ethers
 Based on the current consensus mechanisms of the wallet, the approval flags are checked for the hash of payee address and amount to be sent, if the consensus is reached, then the ethers are transferred to the payee address. 
 Once, the ethers are sent the approval flag is set to false for the perticular hash for all the owners.


## Security 
 Currently the measures are taken to ensure that only the owners can perform the diffrent operations in the wallet such as adding new owner, changing consensus, destroy  and approving the send transactions.  
 However, the wallet can be made more secure by adding the consensus requirement for addOwner, changeConsensus, destroy operations, thus preventing the manipulating the wallet ownership.
 When approving the transactions, error checking has been done to ensure wallet has enought balance and the payee is a valid address.







