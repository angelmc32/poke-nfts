// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import { Base64 } from "../libraries/base64.sol";

contract PokemonFactory is ERC721URIStorage, VRFConsumerBase {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  address internal VRFCoordinator = 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B; // address that verifies the random function
  bytes32 internal keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
  uint256 internal link_fee = 0.1 * 10 ** 18;
  uint256 public randomResult;

  struct Pokemon {
    uint16 speciesId;
    uint32 personalityValue;
    string nickname;
    uint16 level;
    uint32 expPoints;
    uint256 HP;
    uint256 Attack;
    uint256 Defense;
    uint256 SpAttack;
    uint256 SpDefense;
    uint256 Speed;
    uint8[6] IndValues;
    uint8[6] EffortValues;
    string heldItem;
    uint dateMet;
    string locationMet;
    bool hasPokerus;
  }

  // We need to pass the name of our NFTs token and its symbol.
  constructor(address _VRFCoordinator, address _LinkToken) 
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    ERC721("Pokemon", "POKEMON") {
    /* keyHash = _keyhash;
    link_fee = _link_fee; */
    console.log("This is my Pokemon NFT Factory contract. Woah!");
  }

  function getRandomNumber() 
    public returns (bytes32 requestId) {
      return requestRandomness(keyHash, link_fee);
  }

  function fulfillRandomness (bytes32 requestId, uint256 randomness) internal override {
    randomResult = randomness;
  }
  
  function mintPokemonNFT() public {
  
    uint256 newItemId = _tokenIds.current();
    
  }
}