// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "hardhat/console.sol";


/// @title Dookies - Privacy Preserving Advertisement Infra
/// @author Jamshed Cooper & Dookies team

contract Dookies  {
    using SafeERC20 for IERC20;
    /// @dev Variables required for AddCampaign
    address public dookiesToken;
    bool public isBookingOpen;
    address public owner;

    /// @dev AdCampaign and list of AdCampaigns
    struct AdCampaign {
        string name; //name of ad
        address owner; //wallet of owner
        string adCreative; //IPFS link
        uint256 storedValue; //Amount of GHO use is willing to spend
        bool paused; //Is contract paused/OFF or ON
        //string targetAudience; //A , seperated list of tags for ad matching engine
        //uint256 freqAds; //frequency of ads shown per user per day
        //string timezone; //A , seperated list of timezones when the ad is displayed
    }
    AdCampaign[] public adList;
    mapping(string => AdCampaign) public adLookup;

    /// @dev List of Valid publishers and mapping of Ads and Publishers
    address[] public publisherList;
    mapping(address => AdCampaign) public publisherToAd;

    /// @notice Modifiers - Ensure onlyByOwner
    modifier onlyByOwner() {
        console.log("only by owner", msg.sender, owner);
        require(msg.sender == owner,"owner can only call");
        _;
    }

    /// @dev Create and Deploy contract
    /// @dev Called by the Owner of the Rayze Restaurant Network

    constructor(address _dookiesToken) {
        dookiesToken = _dookiesToken;
        isBookingOpen = false;
        owner = msg.sender;
    }

    /// @dev register the AdCampaign
    /// @dev will be called to create a new Ad Campaign
    function registerAdCampaign(
        string memory _name, //name of ad
        string memory _adCreative //IPFS link
    ) public payable {

        AdCampaign memory newAd = AdCampaign({
            name: _name,
            owner: msg.sender,
            adCreative: _adCreative,
            storedValue: msg.value,
            paused: false
        });
        adList.push(newAd);
        adLookup[_name] = newAd;

        IERC20(dookiesToken).safeTransferFrom(
            msg.sender,
            address(this),
            msg.value
        );
    }


    /// @dev set booking of Ads open/closed
    function setBookingOpen(bool _isBookingOpen) public onlyByOwner {
        isBookingOpen = _isBookingOpen;
    }
}
