// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    uint256 private seed;
    // Solidity events magic
    event NewWave(address indexed from, uint256 timestamp, string message);

    // Wave Struct
    // A struct is a custom datatype where we can customize what we want to store
    struct Wave {
        address waver; // address of the waver
        string message; // message of the wave
        uint256 timestamp; // timestamp of the wave
    }

    // Variable Waves
    // Lets us store all the waves anyone has sent ever
    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("I AM THE SMARTEST CONTRACT. 3000 IQ");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "You can only wave once every 15 minutes"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        // store the wave data in the array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        seed = (block.difficulty + block.timestamp + seed) % 100;

        emit NewWave(msg.sender, block.timestamp, _message);

        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdrawl more than this contract is worth "
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdrawl money from contract");
        }
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}
