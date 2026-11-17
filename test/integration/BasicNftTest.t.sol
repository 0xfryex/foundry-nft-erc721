//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract testBasicNft is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("USER");
    address public USER_TWO = makeAddr("USER_TWO");

    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    string public constant SHIBA =
        "ipfs://QmVkSb3LdGggVoTU3TeJbVhDdhacvZh9w3USbN3hJvyXRK/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsSame() public {
        string memory expectedName = "Dogie";
        string memory realName = basicNft.name();

        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(realName))
        );
    }

    function testUserCanMintNft() public {
        vm.prank(USER);
        basicNft.mintNFT(PUG);

        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(PUG)) ==
                keccak256(abi.encodePacked(basicNft.tokenURI(0)))
        );
    }

    function testMultipleMintsIncrementCorrectly() public {
        vm.prank(USER);
        basicNft.mintNFT(PUG);

        vm.prank(USER_TWO);
        basicNft.mintNFT(SHIBA);

        assertEq(basicNft.balanceOf(USER), 1);
        assertEq(basicNft.balanceOf(USER_TWO), 1);

        assertEq(basicNft.ownerOf(0), USER);
        assertEq(basicNft.ownerOf(1), USER_TWO);

        assertEq(basicNft.tokenURI(0), PUG);
        assertEq(basicNft.tokenURI(1), SHIBA);
    }
}
