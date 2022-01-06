pragma solidity ^0.8.5;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

library Merkle {
    /**
     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
     * defined by `root`. For this, a `proof` must be provided, containing
     * sibling hashes on the branch from the leaf to the root of the tree. Each
     * pair of leaves and each pair of pre-images are assumed to be sorted.
     */
    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash <= proofElement) {
                // Hash(current computed hash + current element of the proof)
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                // Hash(current element of the proof + current computed hash)
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }

        // Check if the computed hash (root) is equal to the provided root
        return computedHash == root;
    }
}

contract GreenFreak is ERC721Enumerable, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using Counters for Counters.Counter;


    mapping(address => bool) private whitelist;

    string private baseURI;
    bool private saleActive = false;
    bool private allowWhitelistRedemption = false;

    bytes32 public  merkleRoot;
    uint256 private whitelistMaxMint = 1;

    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _numAirdroped;
    Counters.Counter private _numMinted;

    // Total number: 5500
    uint256 public constant MAX_PUBLIC_MINT = 5500;
    uint256 public constant AIRDROP_RESERVE = 500;

    uint256 public constant MAX_DUCKY_ET_PURCHASE = 5;
    uint256 public  PRICE_DUCKY_ET = 0;


    constructor(
        string memory name,
        string memory symbol,
        string memory uri) ERC721(name, symbol) {
        baseURI = uri;
    }

    function startSale() external onlyOwner {
        require(!saleActive, "The sale is active already");
        PRICE_DUCKY_ET = 30000000000000000;// 0.03 ETH
        saleActive = true;
    }

    function pauseSale() external onlyOwner {
        require(saleActive, "The sale is not active, so it cannot be paused");
        saleActive = false;
    }

    function allowEarlyRedemption() external onlyOwner {
        require(!allowWhitelistRedemption, "The whitelist redemption is active already");
        allowWhitelistRedemption = true;
    }

    function pauseEarlyRedemption() external onlyOwner {
        require(allowWhitelistRedemption, "The whitelist redemption is not active, so it cannot be paused");
        allowWhitelistRedemption = false;
    }

    function setWhitelistMaxMint(uint256 amount) external onlyOwner {
        whitelistMaxMint = amount;
    }
    //set merkelproof root whitelist
    function whitelist(bytes32 merkleRoot_) external onlyOwner {
//        for(uint i = 0; i < to.length; i++){
//            whitelist[to[i]] = true;
//        }
        merkleRoot = merkleRoot_;
    }

    function mint(uint256 numberOfDucky, bytes32[] calldata merkleProof) external payable nonReentrant {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));

        require(
            saleActive ||
            (Merkle.verify(merkleProof, merkleRoot, leaf) &&  !whitelist[msg.sender] && numberOfDucky <= whitelistMaxMint && allowWhitelistRedemption),
            "You may not mint a Green Freak yet. Stay tuned!");
        require(numberOfDucky > 0, "You cannot mint 0  Green Freak.");
        require(SafeMath.add(_numMinted.current(), numberOfDucky) <= MAX_PUBLIC_MINT, "Exceeds maximum supply.");
        require(numberOfDucky <= MAX_DUCKY_ET_PURCHASE, "Exceeds maximum in one transaction.");
        require(getNFTPrice(numberOfDucky) <= msg.value, "Amount of Ether sent is not correct.");

        whitelist[msg.sender] = true;

        for(uint i = 0; i < numberOfDucky; i++){
            uint256 tokenIndex = _tokenIdCounter.current();
            _numMinted.increment();
            _tokenIdCounter.increment();
            _safeMint(msg.sender, tokenIndex);
        }
    }

    function airdrop(address[] calldata to, uint256[] calldata numberOfDucky)
    external
    onlyOwner
    {
        require(to.length == numberOfDucky.length, "The arrays must be the same length.");

        uint256 sum = 0;
        for(uint i = 0; i < numberOfDucky.length; i++){
            sum = sum + numberOfDucky[i];
        }

        require(SafeMath.add(_numAirdroped.current(), sum) <= AIRDROP_RESERVE, "Exceeds maximum airdrop reserve.");

        for(uint i = 0; i < to.length; i++){
            for(uint j = 0; j < numberOfDucky[i]; j++){
                uint256 tokenId = _tokenIdCounter.current();
                _tokenIdCounter.increment();
                _numAirdroped.increment();
                _safeMint(to[i], tokenId);
            }

        }
    }

    function getNFTPrice(uint256 amount) public view returns (uint256) {
        return SafeMath.mul(amount, PRICE_DUCKY_ET);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        Address.sendValue(payable(msg.sender), balance);
    }

    function setBaseURI(string memory uri) external onlyOwner {
        baseURI = uri;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}
