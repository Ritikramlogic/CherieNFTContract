// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CherieNFT is ERC721, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct accountInfo{
        uint256 [] tokenId;
        address [] user_address;
        uint256 [] sequenceID;
    }

    struct TokenID{
        uint sequenceID;
    }

    mapping(string => accountInfo) Accounts;
    mapping(uint => TokenID) TID;
    string[][] public userAddresses; 
    string [] public accountID;

    constructor() ERC721("ChirieNFT", "CNT") {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) public onlyOwner {
        for (uint i=0; i<5; i++) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
      }
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }


  function buyPieces(uint256 no_pieces,address user_address,string memory account_id) public returns(string memory, uint256[] memory,address ,uint256[] memory) {
        for (uint i=0; i<no_pieces; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(user_address, tokenId);
            Accounts[account_id].user_address.push(user_address);
            Accounts[account_id].tokenId.push(tokenId);
            Accounts[account_id].sequenceID.push(tokenId);
            TID[tokenId].sequenceID = tokenId;
        }
    return (account_id,Accounts[account_id].tokenId,user_address,Accounts[account_id].sequenceID);
  }


 function tradePieces(string memory account_id,string memory account_id2,uint[] memory tokens,address user_address) payable public returns(string memory, uint256[] memory,address ,uint256[] memory) {
        for(uint i=0; i<tokens.length; i++){
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(user_address, tokenId);
            // delete Accounts[account_id2].tokenId[tokens[i]];
            Accounts[account_id].user_address.push(user_address);
            Accounts[account_id].tokenId.push(tokenId);
            Accounts[account_id].sequenceID.push(tokenId);
            TID[tokenId].sequenceID = tokenId;
            // transferFrom(0xAf80DB1B7ce3247275fe98BB007b1165BFA98aCf,user_address,tokenId);
    }
    return (account_id,Accounts[account_id].tokenId,user_address,Accounts[account_id].sequenceID);
  }


    function getTokenID(string memory account_id) public view returns(uint256[] memory ){
        return Accounts[account_id].tokenId;
    }

     function getUserAddress(string memory account_id) public view returns(address[] memory ){
        return Accounts[account_id].user_address;
    }

    function getSequenceID(uint id) public view returns(uint){
          return TID[id].sequenceID;
    }
   
}

