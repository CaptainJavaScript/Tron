pragma solidity ^0.4.25;

import "./usingCaptainJSAtTron_v2.sol";


contract HelloSeaman_v1 is usingCaptainJSAtTron_v2 {
    
    constructor () public { }

    uint constant EXAMPLE1 = 1;
    uint constant EXAMPLE2 = 2;

    event DemoRunsEvent();

    function Demo() public payable {
        // execute a JavasCript call:   
        //uint UniqueIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint BudgetForCallback) public payable {
     
        Run(EXAMPLE1, "json:https://api.kraken.com/0/public/Ticker?pair=ETHUSD", "result.XETHZUSD.a[0]", "-", 2, 5000);    

        // register a simple callback 
        Callback(EXAMPLE2, 20, 100000);

        emit DemoRunsEvent();    
    }

    function CaptainsResult(uint UniqueIdentifier, string  Result, bool IsError) external onlyCaptainsOrdersAllowed {
        emit LogEvent(
            concat("CaptainsResult received with UID = ", uintToString(UniqueIdentifier), " and a result of ", Result)
        );
    }

    function CaptainsCallback(uint UniqueIdentifier) external onlyCaptainsOrdersAllowed {
        emit LogEvent(
            concat("Callback received with UID = ", uintToString(UniqueIdentifier))
        );
    }

}