// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../lib/solmate/src/tokens/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();

contract NFT is ERC721 {

    string public baseURI;

    uint256 public currentTokenId;
    uint256 public constant MAX_CAPACITY = 10_000;
    uint256 public constant MINT_PRICE = 0.08 ether;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) ERC721(_name, _symbol) {
        baseURI = _baseURI;
    }

    function mintTo(address recipient) public payable returns (uint256) {
        if (msg.value != MINT_PRICE) {
            revert MintPriceNotPaid();
        }

        uint256 newItemId = ++currentTokenId;
        _safeMint(recipient, newItemId);
        return newItemId;
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        if (ownerOf(id) == address(0)) {
            revert NonExistentTokenURI();
        }
        if (bytes(baseURI).length > 0) {
            return string(abi.encodePacked(baseURI, Strings.toString(id)));
        } else {
            return "";
        }
    }
}