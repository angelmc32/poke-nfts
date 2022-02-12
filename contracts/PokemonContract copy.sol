pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
/* import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol"; */
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import { Base64 } from "../libraries/base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract PokemonFactory is ERC721URIStorage {
  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  
  string baseSvg = "randomstring";
  string[] firstWords = ["Bulbasaur", "Charmander", "Squirtle", "Chikorita", "Cyndaquil", "Totodile", "Treecko", "Torchic", "Mudkip", "Turtwig", "Chimchar", "Piplup", "Snivy", "Tepig", "Oshawott", "Chespin", "Fennekin", "Froakie", "Rowlet", "Litten", "Popplio", "Grookey", "Scorbunny", "Sobble"];
  string[] secondWords = ["Hardy", "Lonely", "Brave", "Adamant", "Naughty", "Bold", "Docile", "Relaxed", "Impish", "Lax", "Timid", "Hasty", "Serious", "Jolly", "Naive", "Modest", "Mild", "Quiet", "Bashful", "Rash", "Calm", "Gentle", "Sassy", "Careful", "Quirky"];
  string[] thirdWords = ["PokeBall", "GreatBall", "UltraBall", "LuxuryBall", "PremierBall", "SafariBall", "FastBall", "LevelBall", "RepeatBall", "TimerBall", "DuskBall", "QuickBall"];

  struct Pokemon {
    uint256 HP;
    uint256 Attack;
    uint256 Defense;
    uint256 SpAttack;
    uint256 SpDefense;
    uint256 Speed;
  }

  // We need to pass the name of our NFTs token and its symbol.
  constructor() ERC721 ("PokeLettersNFT", "POKELET") {
    console.log("This is my Pokemon NFT Factory contract. Woah!");
  }

  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // Seed for random generator. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  // A function our user will hit to get their NFT.
  function mintPokedexNFT() public {
     // Get the current tokenId, this starts at 0.
    uint256 newItemId = _tokenIds.current();
    
    // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));
    
    // I concatenate it all together, and then close the <text> and <svg> tags.
    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A collection of Pokemon assigned with letters.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalSvg);
    console.log("--------------------\n");

     // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);

    _setTokenURI(newItemId, finalTokenUri);
    
    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();
    
    console.log("A new Pokemon NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

  }
}