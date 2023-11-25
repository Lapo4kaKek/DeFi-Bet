pragma solidity >=0.8.2 <0.9.0;

import "./User.sol";
import "./Event.sol";

contract Storage {
    // Mapping from user's wallet address to their User detail
    mapping (address => User) users;
    mapping (uint => Event) public events;
    uint public eventCount;

    address immutable owner;
    // fixing the contract creator
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    event UserAdded(address Address);

    function AddUser() public {
        require(users[msg.sender].balance == 0, "User already exists");
        users[msg.sender] = User(address(msg.sender).balance, true, 0);
        emit UserAdded(msg.sender);
    }

    function addEvent(string memory title) public {
        events[eventCount] = Event({
            title: title,
            isActive: true,
            yesBets: new Storage[](0),
            noBets: new Storage[](0)
        });
        eventCount++;
    }

    function placeBet(uint betId, bool betOnYes, uint amount) public returns (string memory status) {
        // check betId
        require(events[betId].isActive == false, "Incorrect event");
        // check user balance
        require("Not enough Balance", msg.balance < amount);

        // if he bet "yes"
        if(betOnYes) {
            events[betId].yesBets.push(Bet({user: msg.sender, amount: amount}));
            return "Succes!";
        } else {
            events[betId].noBets.push(Bet({user: msg.sender, amount: amount}));
            return "Succes!";
        }
    }

    function calculateExodus(uint betId) public returns (uint256 result){
        uint sumYes = sumPick(betId, true);
        uint sumNo = sumPick(betId, false);
        uint256 res = 1;
        return res;
    }
    function sumPick(uint betId, bool yes) public onlyOwner returns(uint256 result){
        uint amount = 0;
        if (yes) {
            for (uint i = 0; i < events[betId].yesBets.length(); i++) {
                amount += events[betId].yesBets[i];
            }
            return amount;
        }
        for (uint i = 0; i < events[betId].noBets.length(); i++) {
            amount += events[betId].yesBets[i];
        }
        return amount;
    }

    function settleBets(uint betId, bool outcomeYes) public onlyOwner {
        // we should calculate exodus event
        require(events[betId].isActive, "The event is not active");

        uint totalBetsYes = sumPick(betId, true); 
        uint totalBetsNo = sumPick(betId, false);
        uint totalBets = totalBetsYes + totalBetsNo;

        if (outcomeYes) {
            for(int i = 0; i < events[betId].yesBets.length(); i++) {
                uint amount_out = (events[betId].yesBets[i].amount / totalBetsNo) * totalBets;
                users[events[betId].noBets[i].userAddress].balance += amount_out;
            }
        } else {
            for(int i = 0; i < events[betId].noBets.length(); i++) {
                uint amount_out = (events[betId].noBets[i].amount / totalBetsNo) * totalBets;
                users[events[betId].noBets[i].userAddress].balance += amount_out;
            }
        }
    }
}