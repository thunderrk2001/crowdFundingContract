pragma solidity >=0.7.0 <0.9.0;
contract Fund{
address  public manager;
string public fundName;
string public desc;
uint public minAmount;
uint public lastTimeStamp;
uint public approversCount=0;
mapping(address=>uint) public approvers;

struct request{
string requestName;
string requestDesc;
uint requestedAmount;
address payable receiverAddress;
uint voteCount;
bool isCompleted;
}
mapping(int=>request) public requests;
int private requestsCount=-1;
constructor(address _manager,string  memory _fundName,string memory _desc,uint  _minAmount,uint _minTime)
{
require(bytes(_fundName).length>2 ,"Fund Name should have proper title");
require(_minAmount>0 ,"Minimum amount of eth shoud greater than 0");
require(_minTime>=3600 ,"Min time should greater than or equal to 3600 seconds");
manager=_manager;
fundName=_fundName;
desc=_desc;
minAmount=_minAmount;
lastTimeStamp=block.timestamp+_minTime;
}
function donate() public payable
{require(msg.value>=minAmount,"Donatation less than minAmount is not accepted");
if(approvers[msg.sender]==0)
approversCount=approversCount+1;
approvers[msg.sender]=approvers[msg.sender]+msg.value;
}
function getBalance() public view returns(uint)
{
return address(this).balance;
}
modifier isManager{
    require(msg.sender==manager,"you dont have authority to create requests");
    _;
}
function createRequest(string memory _requestName,string memory _requestDesc,uint _requestedAmount,
address _receiverAddress
) public isManager  payable {
require(_requestedAmount<=address(this).balance);
request memory newRequest =request(_requestName,_requestDesc,
_requestedAmount,payable(_receiverAddress),
0,false
);
requestsCount++;
requests[requestsCount]=newRequest;

}
function withdraw(int idx) public isManager payable{
    require(idx>=0 && idx<=requestsCount);
    //require(requests[idx].voteCount>=approversCount/2);
    require(requests[idx].isCompleted==false);
    requests[idx].receiverAddress.transfer(requests[idx].requestedAmount);
    requests[idx].isCompleted=true;
}


}
