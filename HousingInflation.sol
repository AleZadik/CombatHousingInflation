// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./TruflationTester.sol";

contract HouseInflation {
    TruflationTester truflationTester =
        TruflationTester(0x808F94acc9037958849cC9fb1EB297E950B08fa9);

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
        uint8 status; // SALE = 1, SOLD = 2, RENT = 3, RENTED = 4, OFF = 5
        uint256 creationDate; // TS in secs
        string location; // address str
        uint256 rentPrice; // Price in USD for entire rentDuration
        uint256 rentDuration; // Duration in days
        address renter; // Address of renter
        uint256 rentEnds; // TS in secs
    }
    uint256 public estateCount = 0;
    mapping(uint256 => Estate) public estates;
    mapping(address => Estate[]) public ownerEstates;

    function createEstate(
        string memory _name,
        uint256 _initialPrice,
        string memory _metadataURI,
        string memory _location
    ) public {
        uint256 ts = block.timestamp;
        estates[estateCount] = Estate(
            _name,
            msg.sender,
            _initialPrice,
            _initialPrice,
            _metadataURI,
            0,
            ts,
            _location,
            0,
            0,
            address(0),
            0
        );
        ownerEstates[msg.sender].push(estates[estateCount]);
        estateCount++;
        emit EstateCreated(
            _name,
            msg.sender,
            _initialPrice,
            _metadataURI,
            0,
            ts,
            _location,
            0,
            0,
            address(0),
            0
        );
    }

    function getOwnerEstateCount(address _owner) public view returns (uint256) {
        return ownerEstates[_owner].length;
    }

    function getOwnerEstateByIndex(address _owner, uint256 _index)
        public
        view
        returns (
            string memory,
            address,
            uint256,
            uint256,
            string memory,
            uint8,
            uint256,
            string memory
        )
    {
        Estate memory estate = ownerEstates[_owner][_index];
        return (
            estate.name,
            estate.owner,
            estate.initialPrice,
            estate.currentPrice,
            estate.metadataURI,
            estate.status,
            estate.creationDate,
            estate.location
        );
    }

    // quantity of estatesForSale
    uint256 public estatesForSaleCount = 0;
    mapping(uint256 => Estate) public estatesForSale;

    function listForSale(
        uint256 _estateId,
        uint256 _price,
        bool _followInflation
    ) public {
        Estate memory estate = estates[_estateId];
        require(
            estate.owner == msg.sender,
            "You are not the owner of this estate"
        );
        require(estate.status == 0, "Estate is already listed");
        if (_followInflation) {
            // inflation is 8% per year
            estate.currentPrice = (estate.initialPrice * 108) / 100;
        } else {
            estate.currentPrice = _price;
        }
        estate.status = 1;
        estates[_estateId] = estate;

        if (estatesForSale[_estateId].owner == address(0)) {
            estatesForSaleCount++;
        }
        ownerEstates[estate.owner][_estateId].status = 1;
        estatesForSale[_estateId] = estate;
        emit EstateListedForSale(_estateId, _price);
    }

    // list of estatesForRent & quantity of estatesForRent
    uint256 public estatesForRentCount = 0;
    mapping(uint256 => Estate) public estatesForRent;

    function listForRent(
        uint256 _estateId,
        uint256 _price,
        uint256 _duration
    ) public {
        Estate memory estate = estates[_estateId];
        require(
            estate.owner == msg.sender,
            "You are not the owner of this estate"
        );
        require(estate.status == 0, "Estate is already listed");
        estate.status = 3;
        estate.rentPrice = _price;
        estate.rentDuration = _duration;
        estates[_estateId] = estate;

        if (estatesForRent[_estateId].owner == address(0)) {
            estatesForRentCount++;
        }
        ownerEstates[estate.owner][_estateId].status = 3;
        estatesForRent[_estateId] = estate;
        emit EstateListedForRent(_estateId, _price, _duration);
    }

    // rent an estate
    function rentEstate(uint256 _estateId) public payable {
        Estate memory estate = estates[_estateId];
        require(estate.status == 3, "Estate is not listed for rent");
        require(
            msg.value == estate.rentPrice,
            "You must pay the exact rent price"
        );
        require(
            estate.renter == address(0),
            "Estate is already rented by someone"
        );
        require(
            estate.owner != msg.sender,
            "You are the owner of this estate"
        );
        payable(estate.owner).transfer(msg.value);
        estate.status = 4;
        estate.renter = msg.sender;
        estate.rentEnds = block.timestamp + (estate.rentDuration * 1 days); // after rentDuration days
        estates[_estateId] = estate;
        estatesForRent[_estateId] = estate;
        ownerEstates[estate.owner][_estateId] = estate;
        emit EstateRented(_estateId, msg.sender);
    }

    function concludeRent(uint256 _estateId) public {
        Estate memory estate = estates[_estateId];
        require(estate.status == 4, "Estate is not rented");
        require(
            estate.rentEnds < block.timestamp,
            "Rent duration has not ended yet"
        );
        estate.status = 0;
        estate.renter = address(0);
        estate.rentEnds = 0;
        estates[_estateId] = estate;
        estatesForRent[_estateId] = estate;
        ownerEstates[estate.owner][_estateId] = estate;
        emit EstateRentConcluded(_estateId);
    }

    // check if everything is ok, then transfer ownership, and add to ownerEstates
    function purchase(uint256 _estateId) public payable {
        Estate memory estate = estatesForSale[_estateId];
        require(estate.status == 1, "Estate is not for sale");
        require(
            msg.value == estate.currentPrice,
            "You are not paying the correct amount"
        );
        require(estate.owner != msg.sender, "You are the owner of this estate");
        payable(estate.owner).transfer(msg.value);

        // change owner of ownerEstates of estate.owner to msg.sender
        // this way we can still list the estate as a 'sold' by querying ownerEstates ;p
        ownerEstates[estate.owner][_estateId].owner = msg.sender;
        ownerEstates[estate.owner][_estateId].status = 2;

        estate.owner = msg.sender;
        estate.status = 0; // reset statu to off (for the next user)
        estates[_estateId] = estate;
        estatesForSale[_estateId].status = 2;
        ownerEstates[msg.sender].push(estate);
        emit EstatePurchased(_estateId, msg.sender);
    }


    // emit events
    event EstateCreated(
        string name,
        address owner,
        uint256 initialPrice,
        string metadataURI,
        uint8 status,
        uint256 creationDate,
        string location,
        uint256 rentPrice,
        uint256 rentDuration,
        address renter,
        uint256 rentEnds
    );
    event EstateListedForSale(uint256 estateId, uint256 price);
    event EstatePurchased(uint256 estateId, address buyer);
    event EstateListedForRent(uint256 estateId, uint256 price, uint256 duration);
    event EstateRented(uint256 estateId, address renter);
    event EstateRentConcluded(uint256 estateId);
}