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
}