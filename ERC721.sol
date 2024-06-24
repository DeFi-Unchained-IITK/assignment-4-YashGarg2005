// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721 {
    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _ownedTokensCount;
    mapping(uint256 => address) private _tokenApprovals; 
    mapping(address => mapping(address => bool)) private _operatorApprovals; // A nested mapping from owner address to operator address to a boolean indicating if the operator is approved to manage all of the owner’s assets.

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "Zero address not allowed");
        return _ownedTokensCount[owner]; //tokens owned by the adress
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "Token not exists");
        return owner;
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external payable {
        _transferFrom(from, to, tokenId);
    }

    function approve(address approved, uint256 tokenId) external payable { //to approve other person address
        address owner = _tokenOwner[tokenId];
        require(approved != owner, "Cannot approve yourself");

        _tokenApprovals[tokenId] = approved; //approved is the adress of the person whose token gets approved
        emit Approval(owner, approved, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) external {
        require(operator != msg.sender, "Cannot approve yourself");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint256 tokenId) external view returns (address) {
        return _tokenApprovals[tokenId];
    }

    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function _transferFrom(address from, address to, uint256 tokenId) internal {
        address owner = _tokenOwner[tokenId];
        require(owner == from, "Not token owner");
        require(to != address(0), "Cannot transfer to zero address");

        _clearApproval(tokenId);

        _ownedTokensCount[from]--;
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to]++;

        emit Transfer(from, to, tokenId);
    }

    function _clearApproval(uint256 tokenId) internal {
        delete _tokenApprovals[tokenId];
    }
    function mint(address to, uint256 tokenId) public {
    require(to != address(0), "Cannot mint to zero address");
    require(_tokenOwner[tokenId] == address(0), "Token already minted");

    _tokenOwner[tokenId] = to;
    _ownedTokensCount[to]++;

    emit Transfer(address(0), to, tokenId);
}
}