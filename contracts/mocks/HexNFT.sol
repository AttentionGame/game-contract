// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "../interfaces/IERC721Hexagon.sol";

contract HexNFT is IERC721Hexagon, ERC721 {
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
    mapping(address => Hexagon) public hexgrid;
    mapping(string => address) public hexagonOwner;
    mapping(uint256 => Hexagon) public idToHexagon;
    mapping(uint256 => address) public idToShowNFT;

    constructor() ERC721("Attention Game NFT", "HexNFT") {
    }

    function isLinked(string memory q, string memory r, string memory s) public returns (bool) {
        return true;
    }

    function distance(string memory q, string memory r, string memory s) public pure returns (uint256) {
        bytes32 qx = keccak256(abi.encodePacked(q));
        bytes32 rx = keccak256(abi.encodePacked(r));
        bytes32 sx = keccak256(abi.encodePacked(s));
        uint256 x = uint256(qx);
        uint256 y = uint256(rx);
        uint256 z = uint256(sx);
        return uint256(Math.max(Math.max(x, y), z));
    }

    function mint(string memory q, string memory r, string memory s) public {
        _total.increment();
        _safeMint(msg.sender, _total.current());
        Hexagon memory hexagon = Hexagon(q, r, s);
        hexgrid[msg.sender] = hexagon;
        string memory hexagonKey = string(abi.encodePacked("q", q, ",r", r, ",s", s));
        hexagonOwner[hexagonKey] = msg.sender;
        idToHexagon[_total.current()] = hexagon;
        emit CreateHexagon(msg.sender, hexagonKey, hexagon);
    }
    
    function setShowNFT(uint256 _tokenId, address _nftAddress) public {
        address owner = ownerOf(_tokenId);
        require(
            owner == msg.sender,
            "Only token owner can set showNFT"
        );
        idToShowNFT[_tokenId] = _nftAddress;
    }

    function showNFT(uint256 _tokenId) public view returns(address) {
        return idToShowNFT[_tokenId];
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
