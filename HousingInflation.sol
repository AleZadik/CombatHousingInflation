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
        estates[estateCount++] = Estate(_name, msg.sender, _initialPrice, _initialPrice, _metadataURI, "OFF", block.timestamp, _location);
        estateIds.push(estateCount);
    }
}