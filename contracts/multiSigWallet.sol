pragma solidity ^0.6.2;

contract multiSigWallet{

 // Types of consensus: 1. Atleast one  2. Majority  3. All  

  uint constant maxOwners = 3;

  uint consensusType= 1;  
  
  address[] owners;
  mapping(address=>bytes) op_signs;
  event Received(address src, uint amount);
  event Sent(address dst, uint amount);
  event NewOwner(address owner);
  
  constructor(uint _consensusType) public {
    require(1<= _consensusType && _consensusType <=3);
    owners.push(msg.sender);
    consensusType = _consensusType;
  }
  

 function addOwner(address _owner) public _isOwner _noDuplicate(_owner){
  require(owners.length < maxOwners);
  owners.push(_owner);
  emit NewOwner(_owner);
 }
 
 function send(uint amount, address payable dst) public payable _approveSendEthers(amount, dst) _isOwner _isValidAddress(dst){
      require(amount <= address(this).balance,"Error: not enough balance");
      dst.transfer(amount);
      clearSigns();
      emit Sent(dst,amount);
  }
 
 function changeConsensusType(uint _type) public _isOwner{
  require(1<= _type && _type <=3 );
  consensusType= _type;
 }
 
 function signSendEthers(uint amt, address dst) public payable _isOwner _isValidAddress(dst) {
  op_signs[msg.sender]= abi.encodeWithSignature("send:",dst,amt);
 }
 
 function recieve() external payable {
    emit Received(msg.sender, msg.value);
  }
  
  function getBalance() external view returns (uint) {
   return address(this).balance;
  }
  
   
 function recoverSigner(bytes32 signMsg, bytes memory signature) internal pure returns (address)
  {
    bytes32 r;
    bytes32 s;
    uint8 v;
    require(signature.length == 65);
     assembly {
      r := mload(add(signature, 0x20))
      s := mload(add(signature, 0x40))
      v := byte(0, mload(add(signature, 0x60)))
    }  
    
    return ecrecover(signMsg, v, r, s);
  }
  
 
    
 function consensus1(bytes32 data) internal view returns(bool){
  uint counter = 0;
  bool approved;
  for(uint i=0; i< owners.length; i++){
   approved= recoverSigner(data,op_signs[owners[i]]) == owners[i];
    if(approved){
    counter ++;
    }
    
    if(counter >=1)
    {
      return true;
    }
    
  }
 
  return false; 
  }
  
    
 function consensus2(bytes32 data) internal view returns(bool){
  uint counter = 0;
  uint midWay= (owners.length /2);
  bool approved= true;
  for(uint i=0; i< owners.length; i++){
    approved= recoverSigner(data,op_signs[owners[i]]) == owners[i];
    if(approved)
    {
      counter++;
    }
    if(counter >= midWay){
       return true;
    }
     
  }

  return false; 
  }
  
  
   function consensus3(bytes32 data) internal view returns(bool){
   bool approved= true;
    for(uint i=0; i< owners.length; i++){
     approved= recoverSigner(data,op_signs[owners[i]]) == owners[i];
    if(!approved){
      break;
    }
  }
     return approved;
  }
  
  
  
  function clearSigns() public {
    for(uint i=0; i< owners.length; i++){
    op_signs[owners[i]]= "";
  }
  }
  
  
  function isOwner(address _owner) external view returns (bool) {
    for(uint i=0;i< owners.length;i++){
    if (owners[i] == _owner)
     return true;
  }
    return false;  
  }

  function getConsensus() external view returns (uint) {
    return consensusType;
  }

  modifier _approveSendEthers(uint amt, address dst)  {
  bytes32 data=keccak256(abi.encodePacked(dst,amt));
  bool appr;
  if (consensusType == 1)
    appr= consensus1(data);
  else if (consensusType == 2)
    appr = consensus2(data);
  else if (consensusType == 3)
    appr = consensus3(data);
    require(appr,"Error: Transcation not approved");
   _;
  }
  

  modifier _isOwner{
  bool appr;
  for(uint i=0;i< owners.length;i++){
    appr = (owners[i] == msg.sender);
    if(appr)
    break;
  }
  require(appr,"Error: not owner");
   _;
  }
  
  modifier _isValidAddress(address _dst){
    require(_dst != address(0),"Error: Null address");
    _;
  }
  modifier _noDuplicate(address _owner){
  bool appr;
  for(uint i=0;i< owners.length;i++){
    appr = ! (owners[i] == _owner);
    if(appr)
    break;
  }
  require(appr,"Error: not owner");
   _;
  }
  
}
