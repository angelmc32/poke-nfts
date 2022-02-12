// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
/* import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.1/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.1/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.1/contracts/utils/Counters.sol"; */

contract PokemonFactory is ERC721, Ownable {

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol) {            
        }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 fee = 1 ether;

    struct Pokemon {
        uint16 speciesId;
        uint256 id;
        uint256 personalityValue;
        string nickname;
        uint8 level;
        uint32 expPoints;
        uint8[6] effortValues;
        uint8[6] individualValues;
        /* uint16 hitPoints;
        uint16 attack;
        uint16 defense;
        uint16 spAttack;
        uint16 spDefense;
        uint16 speed; */
    }

    Pokemon[] public mintedPokemons;

    event NewPokemon(address indexed owner, uint256 id, uint256 personalityValue);

    // Helpers
    function _genRandomNumber(uint256 _mod) internal view returns(uint256) {
        uint256 randomNum = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        return randomNum % _mod;
    }

    /* function _genRandomPersonalityValue(string memory _userSeed) internal pure returns(uint256) {
        uint256 randomNum = uint256(keccak256(abi.encodePacked(_userSeed)));
        return randomNum % 10**16;
    } */

    function updateFee(uint256 _newFee) external onlyOwner() {
        fee = _newFee;
    }

    function withdraw() external payable onlyOwner() {
        address _owner = owner();
        payable(_owner).transfer(address(this).balance);
    }

    // Creation
    function _createPokemon(string memory _nickname) internal {

        // Get the current tokenId, this starts at 0 and increments for every "mint"
        uint256 newPokemonNFTId = _tokenIds.current();

        uint256 randPersonalityValue = _genRandomNumber(10**16);
        uint8[6] memory newPokemonEVs = [0,0,0,0,0,0];
        uint8[6] memory newPokemonIVs = [15,15,15,15,15,15];

        Pokemon memory newPokemon = Pokemon(1, newPokemonNFTId, randPersonalityValue, _nickname, 5, 0, newPokemonEVs, newPokemonIVs);

        mintedPokemons.push(newPokemon);

        _safeMint(msg.sender, newPokemonNFTId);

        emit NewPokemon(msg.sender, newPokemonNFTId, newPokemon.personalityValue);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }

    function createRandomPokemon(string memory _nickname) public payable {
        require(msg.value == fee, "The fee is not correct");
        _createPokemon(_nickname);
    }

    // Getters
    function getMintedPokemons() public view returns(Pokemon[] memory) {
        return mintedPokemons;
    }

}