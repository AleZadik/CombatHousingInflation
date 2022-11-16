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
        mapping(address => Estate[]) public ownerEstates;

        function createEstate(string memory _name, uint256 _initialPrice, string memory _metadataURI, string memory _location) public {
            if(userByAddress[msg.sender].wallet == address(0)) {
                createUser(msg.sender);
                emit UserCreated(msg.sender);
            }
            uint256 ts = block.timestamp;
            estates[estateCount] = Estate(_name, msg.sender, _initialPrice, _initialPrice, _metadataURI, "OFF", ts, _location);
            ownerEstates[msg.sender].push(estates[estateCount]);
            estateCount++;
            emit EstateCreated(_name, msg.sender, _initialPrice, _metadataURI, "OFF", ts, _location);
        }
        struct User {
            address wallet;
        }
        uint256 public userCount = 0;
        mapping(uint256 => User) public users;
        mapping(address => User) public userByAddress;

        function createUser(address _wallet) public {
            require(userByAddress[_wallet].wallet == address(0), "User already exists");
            users[userCount] = User(_wallet);
            userByAddress[_wallet] = users[userCount];
            userCount++;
        }

        function getOwnerEstateCount(address _owner) public view returns (uint256) {
            return ownerEstates[_owner].length;
        }

        function getOwnerEstateByIndex(address _owner, uint256 _index) public view returns (string memory, address, uint256, uint256, string memory, string memory, uint256, string memory) {
            Estate memory estate = ownerEstates[_owner][_index];
            return (estate.name, estate.owner, estate.initialPrice, estate.currentPrice, estate.metadataURI, estate.status, estate.creationDate, estate.location);
        }

        mapping(uint256 => Estate) public estatesForSale;
    
        function listForSale(uint256 _estateId, uint256 _price, bool _followInflation) public {
            Estate memory estate = estates[_estateId];
            require(estate.owner == msg.sender, "You are not the owner of this estate");
            require(estate.status == "OFF", "Estate is already listed");
            if(_followInflation) {
                estate.currentPrice = estate.currentPrice * (1 + (stringToUint(yoyInflation()) / 100));
            } else {
                estate.currentPrice = _price;
            }
            estate.status = "SALE";
            estates[_estateId] = estate;
            estatesForSale[_estateId] = estate;
            emit EstateListedForSale(_estateId, _price);
        }

        // emit events
        event EstateCreated(string name, address owner, uint256 initialPrice, string metadataURI, string status, uint256 creationDate, string location);
        event UserCreated(address wallet);
        event EstateListedForSale(uint256 estateId, uint256 price);
    }