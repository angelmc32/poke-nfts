pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PokemonBaseData is Ownable {

  mapping(uint256 => PokemonBaseStats) public speciesIdToPokemonBaseStats;
    string[] public listOfPokemonNames;

    struct PokemonBaseStats {
        uint256 hp;
        uint256 atk;
        uint256 def;
        uint256 spa;
        uint256 spd;
        uint256 spe;
        string type1;
        string type2;
        uint256 number; 
        string pokemonName;
    }

}