// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EnsName {
    uint256 public itemCount;

    struct Item {
        uint256 itemId;
        string name;
        uint256 tokenId;
        uint256 price;
        bool listed;
        address payable seller;
    }

    mapping(uint256 => Item) public items;

    IERC721 public immutable ensContract;

    constructor() {
        ensContract = IERC721(0x161ac1BAD1b9cfE7a940aaCe6BC998d41Cbb536a);
    }

    //functionj to list ens domains

    function listENS(
        string memory _name,
        uint256 _tokenId,
        uint256 _price
    ) public {
        require(_price > 0, "priceshould be greater than 0");

        itemCount++;
        items[itemCount] = Item(
            itemCount,
            _name,
            _tokenId,
            _price,
            true,
            payable(msg.sender)
        );
    }

    //function to buy ens domain

    function buyENS(uint256 _itemId) public payable {
        Item memory eachItem = items[_itemId];
        require(msg.value >= eachItem.price, "Price sent is not correct");
        require(_itemId > 0 && _itemId <= itemCount, "Wrong itemID");
        require(
            eachItem.listed == true,
            "This item is not been listed for sale"
        );
        eachItem.listed = false;
        (bool sent, ) = eachItem.seller.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }

    receive() external payable {}
}
