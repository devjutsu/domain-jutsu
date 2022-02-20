// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {StringUtils} from "./libraries/StringUtils.sol";
import {Base64} from "./libraries/Base64.sol";

import "hardhat/console.sol";

contract Domains is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public tld;
    address payable public owner;

    // We'll be storing our NFT images on chain as SVGs
    string svgPartOne =
        '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#a)" d="M0 0h270v270H0z"/><defs><filter id="d" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="290" width="290"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><path d="M72.863 42.949a4.382 4.382 0 0 0-4.394 0l-10.081 6.032-6.85 3.934-10.081 6.032a4.382 4.382 0 0 1-4.394 0l-8.013-4.721a4.52 4.52 0 0 1-1.589-1.616 4.54 4.54 0 0 1-.608-2.187v-9.31a4.27 4.27 0 0 1 .572-2.208 4.25 4.25 0 0 1 1.625-1.595l7.884-4.59a4.382 4.382 0 0 1 4.394 0l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616 4.54 4.54 0 0 1 .608 2.187v6.032l6.85-4.065v-6.032a4.27 4.27 0 0 0-.572-2.208 4.25 4.25 0 0 0-1.625-1.595L41.456 24.59a4.382 4.382 0 0 0-4.394 0l-14.864 8.655a4.25 4.25 0 0 0-1.625 1.595 4.273 4.273 0 0 0-.572 2.208v17.441a4.27 4.27 0 0 0 .572 2.208 4.25 4.25 0 0 0 1.625 1.595l14.864 8.655a4.382 4.382 0 0 0 4.394 0l10.081-5.901 6.85-4.065 10.081-5.901a4.382 4.382 0 0 1 4.394 0l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616 4.54 4.54 0 0 1 .608 2.187v9.311a4.27 4.27 0 0 1-.572 2.208 4.25 4.25 0 0 1-1.625 1.595l-7.884 4.721a4.382 4.382 0 0 1-4.394 0l-7.884-4.59a4.52 4.52 0 0 1-1.589-1.616 4.53 4.53 0 0 1-.608-2.187v-6.032l-6.85 4.065v6.032a4.27 4.27 0 0 0 .572 2.208 4.25 4.25 0 0 0 1.625 1.595l14.864 8.655a4.382 4.382 0 0 0 4.394 0l14.864-8.655a4.545 4.545 0 0 0 2.198-3.803V55.538a4.27 4.27 0 0 0-.572-2.208 4.25 4.25 0 0 0-1.625-1.595l-14.993-8.786z" fill="#000"/><g fill="#65C9FF"/><path d="M156 180.611V199h4c39.765 0 72 32.235 72 72v9H32v-9c0-39.765 32.235-72 72-72h4v-18.389c-17.237-8.189-29.628-24.924-31.695-44.73C70.48 135.058 66 130.052 66 124v-14c0-5.946 4.325-10.882 10-11.834V92c0-30.928 25.072-56 56-56s56 25.072 56 56v6.166c5.675.952 10 5.888 10 11.834v14c0 6.052-4.48 11.058-10.305 11.881-2.067 19.806-14.458 36.541-31.695 44.73Z" fill="#908071"/><g transform="translate(32 36)"><mask id="b"><path d="M124 144.611V163h4c39.765 0 72 32.235 72 72v9H0v-9c0-39.765 32.235-72 72-72h4v-18.389c-17.237-8.189-29.628-24.924-31.695-44.73C38.48 99.058 34 94.052 34 88V74c0-5.946 4.325-10.882 10-11.834V56c0-30.928 25.072-56 56-56s56 25.072 56 56v6.166c5.675.952 10 5.888 10 11.834v14c0 6.052-4.48 11.058-10.305 11.881-2.067 19.806-14.458 36.541-31.695 44.73Z" fill="#fff"/></mask><path mask="url(#b)" d="M156 79v23c0 30.928-25.072 56-56 56s-56-25.072-56-56V79v15c0 30.928 25.072 56 56 56s56-25.072 56-56V79Z" fill="#000" fill-opacity=".1"/></g><g transform="translate(0 170)"><mask id="c"><path d="M165.96 29.295c36.976 3.03 66.04 34 66.04 71.757V110H32v-8.948c0-38.1 29.592-69.287 67.045-71.832-.03.373-.045.75-.045 1.128 0 11.863 14.998 21.48 33.5 21.48 18.502 0 33.5-9.617 33.5-21.48 0-.353-.013-.704-.04-1.053Z" transform="translate(-92 -4)" fill="#fff"/></mask><path fill="#262E33" d="M165.96 29.295c36.976 3.03 66.04 34 66.04 71.757V110H32v-8.948c0-38.1 29.592-69.287 67.045-71.832-.03.373-.045.75-.045 1.128 0 11.863 14.998 21.48 33.5 21.48 18.502 0 33.5-9.617 33.5-21.48 0-.353-.013-.704-.04-1.053Z"/><ellipse transform="translate(92 4)" fill-opacity=".16" fill="#000" fill-rule="evenodd" mask="url(#c)" cx="40.5" cy="27.848" rx="39.635" ry="26.914"/></g><path fill-opacity=".6" fill="#000" d="M93.16 112.447c1.847-3.797 6.004-6.447 10.838-6.447 4.816 0 8.961 2.63 10.817 6.407.552 1.122-.233 2.04-1.024 1.36-2.451-2.107-5.932-3.423-9.793-3.423-3.74 0-7.124 1.235-9.56 3.228-.891.728-1.818-.014-1.278-1.125Zm57 0c1.847-3.797 6.004-6.447 10.838-6.447 4.816 0 8.961 2.63 10.817 6.407.552 1.122-.233 2.04-1.024 1.36-2.451-2.107-5.932-3.423-9.793-3.423-3.74 0-7.124 1.235-9.56 3.228-.891.728-1.818-.014-1.278-1.125Zm-29.303-18.219c0-.009 0-.009 0 0m-27.27-4.336c-2.343.438-4.5 1.896-5.435 4.207-.351.868-.76 2.825-.444 3.708.12.336.325.294 1.248.236 1.688-.106 3.977-2.38 5.792-2.787 2.527-.566 5.235-.141 7.748.432 4.315.985 9.99 4.1 14.45 2.482.332-.12 4.675-3.247 3.423-3.893-.445-.37-3.232-.192-3.747-.278-2.394-.402-4.892-1.064-7.249-1.672-5.14-1.327-10.406-3.447-15.787-2.435m52.496 4.318c-.002-.01-.002-.01 0 0m27.332-4.319c2.342.438 4.5 1.896 5.434 4.207.351.868.76 2.825.444 3.708-.12.336-.325.294-1.248.236-1.688-.106-3.977-2.38-5.792-2.787-2.527-.566-5.235-.141-7.748.432-4.315.985-9.99 4.1-14.45 2.482-.332-.12-4.675-3.247-3.423-3.893.445-.37 3.232-.192 3.747-.278 2.394-.402 4.892-1.064 7.249-1.672 5.14-1.326 10.406-3.446 15.787-2.434"/><path d="M120 130c0 4.418 5.373 8 12 8s12-3.582 12-8" fill="#00000" fill-opacity=".16"/><rect fill-opacity=".7" fill="#000" fill-rule="evenodd" x="42" y="18" width="24" height="6" rx="3" transform="translate(78 134)"/><g/><path fill="#2C1B18" fill-rule="evenodd" d="M114.18 149.737c2.183-1.632 15.227-2.258 17.578-3.648.734-.434 1.303-.873 1.742-1.309.439.436 1.009.875 1.742 1.31 2.351 1.389 15.395 2.015 17.578 3.647 2.21 1.654 3.824 5.448 3.647 8.414-.212 3.56-4.106 12.052-13.795 13.03-2.114-2.353-5.435-3.87-9.172-3.87-3.737 0-7.058 1.517-9.172 3.87-9.69-.978-13.583-9.47-13.795-13.03-.176-2.966 1.437-6.76 3.647-8.414m.665 17.164.017.007-.017-.007m79.018-38.916c-.389-5.955-1.585-11.833-2.629-17.699-.281-1.579-1.81-12.286-2.5-12.286-.232 9.11-1.032 18.08-2.064 27.14-.309 2.708-.632 5.416-.845 8.134-.171 2.196.135 4.848-.397 6.972-.679 2.706-4.08 5.232-6.725 6.165-6.6 2.326-12.105-7.303-17.742-10.12-7.318-3.656-19.897-4.527-27.38.239-7.645-4.766-20.224-3.895-27.542-.239-5.637 2.817-11.142 12.446-17.742 10.12-2.645-.933-6.047-3.459-6.725-6.165-.532-2.124-.226-4.776-.397-6.972-.213-2.718-.536-5.426-.845-8.135-1.032-9.059-1.833-18.029-2.065-27.139-.689 0-2.218 10.707-2.5 12.286-1.043 5.866-2.24 11.744-2.627 17.7-.4 6.119.077 12.181 1.332 18.177a165.44 165.44 0 0 0 2.049 8.541c.834 3.143-.32 9.262.053 12.488.707 6.104 3.582 18.008 6.811 23.259 1.561 2.538 3.39 4.123 5.433 6.168 1.967 1.97 2.788 5.021 4.91 7.118 3.956 3.908 9.72 6.234 15.64 6.806 5.311 4.507 14.14 7.457 24.134 7.457 9.995 0 18.823-2.95 24.135-7.457 5.919-.572 11.683-2.898 15.64-6.806 2.121-2.097 2.942-5.149 4.909-7.118 2.042-2.045 3.872-3.63 5.433-6.168 3.229-5.251 6.104-17.155 6.81-23.259.374-3.226-.78-9.345.054-12.488.75-2.828 1.45-5.676 2.05-8.54 1.254-5.997 1.73-12.06 1.332-18.179Z"/><path fill="#000" d="M133 98.111c-11.037 0-12.63-9.084-35.33-10.37-22.683-1.024-29.854 5.708-29.893 10.369.037 4.293-1.128 15.45 13.589 28.519 14.772 15.512 29.905 10.252 35.33 5.185 5.438-2.341 11.644-23.354 16.304-23.334 4.66.022 10.865 20.992 16.306 23.334 5.424 5.067 20.557 10.327 35.33-5.185 14.716-13.069 13.55-24.226 13.588-28.519-.04-4.662-7.21-11.394-29.895-10.37C145.63 89.027 144.037 98.11 133 98.11Z"/><path fill="#6F383B" d="M122.13 108.481c.38-7.658-12.914-15.839-27.177-15.555-14.256.299-16.111 9.453-16.306 12.963-.349 8.133 8.367 26.415 24.459 25.926 16.091-.51 18.803-18.28 19.023-23.334Zm22.517 0c-.38-7.658 12.914-15.839 27.177-15.555 14.255.299 16.11 9.453 16.305 12.963.35 8.133-8.367 26.415-24.458 25.926-16.092-.51-18.804-18.28-19.024-23.334Z"/><defs><linearGradient id="a" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="red"/><stop offset=".7"/></linearGradient></defs><text x="104" y="250" font-size="14" fill="#D00" filter="url(#d)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgPartTwo = "</text></svg>";

    mapping(string => address) public domains;
    mapping(string => string) public records;

    constructor(string memory _tld) payable ERC721("Jutsu Name Service", "JNS")
    {
        owner = payable(msg.sender);
        tld = _tld;
        console.log("%s name service deployed", _tld);
    }

    function register(string calldata name) public payable {
        require(domains[name] == address(0));

        uint256 _price = price(name);
        require(msg.value >= _price, "Not enough Matic paid");

        // Combine the name passed into the function  with the TLD
        string memory _name = string(abi.encodePacked(name, ".", tld));
        // Create the SVG (image) for the NFT with the name
        string memory finalSvg = string(
            abi.encodePacked(svgPartOne, _name, svgPartTwo)
        );
        uint256 newRecordId = _tokenIds.current();
        uint256 length = StringUtils.strlen(name);
        string memory strLen = Strings.toString(length);

        console.log(
            "Registering %s.%s on the contract with tokenID %d",
            name,
            tld,
            newRecordId
        );

        // Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        _name,
                        '", "description": "A domain on the Jutsu name service", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '","length":"',
                        strLen,
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log(
            "\n--------------------------------------------------------"
        );
        console.log("Final tokenURI", finalTokenUri);
        console.log(
            "--------------------------------------------------------\n"
        );

        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        domains[name] = msg.sender;

        _tokenIds.increment();
    }

    function price(string calldata name) public pure returns (uint256) {
        uint256 len = StringUtils.strlen(name);
        require(len > 0);
        if (len == 3) {
            return 5 * 10**17;
        } else if (len == 4) {
            return 3 * 10**17; 
        } else {
            return 1 * 10**17;
        }
    }

    function getAddress(string calldata name) public view returns (address) {
        return domains[name];
    }

    function setRecord(string calldata name, string calldata record) public {
        require(domains[name] == msg.sender);
        records[name] = record;
    }

    function getRecord(string calldata name)
        public
        view
        returns (string memory)
    {
        return records[name];
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to withdraw Matic");
    }
}
