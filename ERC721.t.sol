// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {ERC721} from "ERC721.sol";

contract ERC721Test is Test {
    ERC721 public token;
    address public owner = address(1);
    address public recipient = address(2);
    uint256 public tokenId = 1;

    function setUp() public {
        token = new ERC721();
        vm.prank(owner);
        token.mint(owner, tokenId);
    }

    function testBalanceOf() public {
        assertEq(token.balanceOf(owner), 1);
    }

    function testOwnerOf() public  {
        assertEq(token.ownerOf(tokenId), owner);
    }


    function testApprove() public {
        vm.prank(owner);
        token.approve(recipient, tokenId);
        assertEq(token.getApproved(tokenId), recipient);
    }

    function testSetApprovalForAll() public {
        vm.prank(owner);
        token.setApprovalForAll(recipient, true);
        assertTrue(token.isApprovedForAll(owner, recipient));
    }

    function testSafeTransferFrom() public {
        vm.prank(owner);
        token.safeTransferFrom(owner, recipient, tokenId);
        assertEq(token.ownerOf(tokenId), recipient);
        assertEq(token.balanceOf(owner), 0);
        assertEq(token.balanceOf(recipient), 1);
    }

    function testClearApprovalOnTransfer() public {
        vm.prank(owner);
        token.approve(recipient, tokenId);
        vm.prank(owner);
        token.safeTransferFrom(owner, recipient, tokenId);
        assertEq(token.getApproved(tokenId), address(0));
    }
}