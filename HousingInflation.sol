// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./TruflationTester.sol";

contract HouseInflation {
    TruflationTester truflationTester = TruflationTester(0x808F94acc9037958849cC9fb1EB297E950B08fa9);
    
    function yoyInflation() public view returns (string memory) {
        return truflationTester.yoyInflation();
    }
    
    function requestYoyInflation() public {
        truflationTester.requestYoyInflation();
    }

    struct Estate {
        string name;
        address owner;
        uint256 initialPrice; // Price in USD at time of creation
        uint256 currentPrice;
        string metadataURI; // OPTIONAL
        string status; // SALE, SOLD, RENT, RENTED, OFF
        uint256 creationDate; // TS in secs
        string location; // address str
    }
    uint256 public estateCount = 0;
    mapping(uint256 => Estate) public estates;
    uint256[] public estateIds;

    function createEstate(string memory _name, uint256 _initialPrice, string memory _metadataURI, string memory _location) public {
        if(userByAddress[msg.sender] == 0) {
            createUser(msg.sender);
            emit UserCreated(msg.sender);
        }
        estateCount++;
        uint256 ts = block.timestamp;
        estates[estateCount] = Estate(_name, msg.sender, _initialPrice, _initialPrice, _metadataURI, "OFF", ts, _location);
        estateIds.push(estateCount);
        users[userByAddress[msg.sender]].estates.push(estateCount);
        emit EstateCreated(_name, msg.sender, _initialPrice, _metadataURI, "OFF", ts, _location);
    }
    struct User {
        address wallet;
        uint256[] estateIds;
    }
    uint256 public userCount = 0;
    uint256[] public userIds;
    mapping(uint256 => User) public users;
    mapping(address => uint256) public userByAddress;

    function createUser(address _wallet) public {
        users[userCount++] = User(_wallet, new uint256[](0));
        userIds.push(userCount);
    }

    // emit events
    event EstateCreated(string name, address owner, uint256 initialPrice, string metadataURI, string status, uint256 creationDate, string location);
    event UserCreated(address wallet);
}