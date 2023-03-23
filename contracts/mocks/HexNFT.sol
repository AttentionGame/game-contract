// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../interfaces/IERC721Consumable.sol";

contract HexNFT is IERC721Consumable, ERC721 {
    enum AssetStatus {
        Listed,
        Delisted
    }
    struct Asset {
        uint256 assetId;
        address paymentToken;
        uint256 minPeriod;
        uint256 maxPeriod;
        uint256 maxFutureTime;
        uint256 pricePerSecond;
        uint256 totalRents;
        AssetStatus status;
    }
    using Counters for Counters.Counter;

    Counters.Counter internal _total;
    mapping(uint256 => address) private _consumers;
    mapping(uint256 => Asset) private _assets;

    constructor() ERC721("Attention Game NFT", "HexNFT") {
    }

    function mint(address _to, uint256 _tokenId) public {
        _safeMint(_to, _tokenId);
    }

    function consumerOf(uint256 _tokenId) external view returns (address) {
        return _consumers[_tokenId];
    }

    function changeConsumer(address _consumer, uint256 _tokenId) external {
        address owner = ownerOf(_tokenId);
        require(
            owner == msg.sender,
            "Only token owner can set consumer"
        );
        _changeConsumer(owner, _consumer, _tokenId);
    }

    function generateAssets(address receiver) external {
        _total.increment();
        mint(receiver, _total.current());
        _assets[_total.current()].assetId = 1;
    }

    /**
     * @dev Changes the consumer
     * Requirement: `tokenId` must exist
     */
    function _changeConsumer(address _owner, address _consumer, uint256 _tokenId) internal {
        _consumers[_tokenId] = _consumer;
        emit ConsumerChanged(_owner, _consumer, _tokenId);
    }

    function assetAt(uint256 _assetId) external view returns (Asset memory) {
        return _assets[_assetId];
    }

    function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId) internal virtual override (ERC721) {
        super._beforeTokenTransfer(_from, _to, _tokenId);

        _changeConsumer(_from, address(0), _tokenId);
    }
}
