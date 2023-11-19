pragma solidity >=0.8.2 <0.9.0;

import "./User.sol";
import "./Event.sol";

contract Storage {
    // Mapping from user's wallet address to their User detail
    mapping (address => User) users;
    mapping (uint => Event) public events;
    uint public eventCount;

    addres public owner;
    // fixing the contract creator
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    event AddUser(address Address);

    function AddUser() public {
        require(users[msg.sender].balance == 0, "User already exists");
        users[msg.sender] = new User(msg.balance, true, 0);
        emit AddUser(msg.sender);
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

    function placeBet(uint betId, bool betOnYes, uint amount) public returns (string status) {
        // check betId
        require(events[betId].isActive == false, "Incorrect event");

        // check user balance
        require("Not enough Balance", msg.balance < amount);

        // if he bet "yes"
        if(betOnYes) {
            events[eventId].yesBets.push(Bet({user: msg.sender, amount: amount}));
        } else {
            events[eventId].noBets.push(Bet({user: msg.sender, amount: amount}));
        }
    }

    function calculateExodus(uint betId) public returns (){
        uint sumYes = sumPick(betId, true);
        uint sumNo = sumPick(betId, false);



    }
    function sumPick(uint betId, bool yes) {
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
    }
}