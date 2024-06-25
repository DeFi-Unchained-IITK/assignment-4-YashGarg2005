// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/forge-std/src/Test.sol";
import "MyNft.sol";

contract YashNFTTest is Test {
    YashNFT public yashNFT;
    address public owner = address(1);
    address public recipient = address(2);

    function setUp() public {
        vm.prank(owner); // Set msg.sender to owner
        yashNFT = new YashNFT(owner);
    }

    function testInitialOwner() public {
        assertEq(yashNFT.owner(), owner);
    }

    function testMinting() public {
        vm.prank(owner); // Set msg.sender to owner
        yashNFT.safeMint(recipient);

        assertEq(yashNFT.ownerOf(0), recipient);
        assertEq(yashNFT.balanceOf(recipient), 1);
    }

    function testBurning() public {
        vm.prank(owner); // Set msg.sender to owner
        yashNFT.safeMint(recipient);

        vm.prank(recipient); // Set msg.sender to recipient
        yashNFT.burn(0);

        // Verify that the token has been burned
        vm.expectRevert(); // Expect any revert
        yashNFT.ownerOf(0);
    }

    function testSupportsInterface() public {
        assertTrue(yashNFT.supportsInterface(type(IERC721).interfaceId));
        assertTrue(yashNFT.supportsInterface(type(IERC721Enumerable).interfaceId));
        assertTrue(yashNFT.supportsInterface(type(IERC721Metadata).interfaceId));
    }
}