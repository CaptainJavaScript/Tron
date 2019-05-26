pragma solidity ^0.4.25;

contract ISeamanJSAtTron {

    function CaptainsResult(uint UniqueIdentifier, string  Result, bool IsError) external;
    function CaptainsCallback(uint UniqueIdentifier) external;
}
