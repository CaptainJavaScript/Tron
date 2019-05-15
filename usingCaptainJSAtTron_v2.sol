pragma solidity ^0.4.25;

import "./IsOwnableAndDestructable.sol";

contract usingCaptainJSAtTron_v2 is IsOwnableAndDestructable {

    address CaptainsAddress;

    constructor () internal {
    }

    function SetCaptainsAddress(address Address) public {
        CaptainsAddress = Address;
        emit LogEvent("Captains Address changed...");
    }

    function Run(uint UniqueIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint BudgetForCallback) public payable {
        ICaptainJSAtTron Captain = ICaptainJSAtTron(CaptainsAddress);
        uint Price = Captain.CalculateRun(RuntimeSlices, BudgetForCallback, false); 
        Captain.Run.value(Price)(UniqueIdentifier, JavaScriptCode, InputParameter, RequiredNpmPackages, RuntimeSlices, BudgetForCallback);
    }

    
    function Callback(uint UniqueIdentifier, uint InMinutesFromNow, uint BudgetForCallback) public payable {
        ICaptainJSAtTron Captain = ICaptainJSAtTron(CaptainsAddress);
        uint Price = Captain.CalculateCallback(InMinutesFromNow, BudgetForCallback, false); 
        Captain.Callback.value(Price)(UniqueIdentifier, InMinutesFromNow, BudgetForCallback);
    }


    modifier onlyCaptainsOrdersAllowed {
        require(
            msg.sender == CaptainsAddress,
            "row, row, row your boat seaman. Only the real captain can call this function..."
        );
        _;
    }

    // legacy
    function Run(uint UniqueIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint BudgetForCallback, uint Gas) public payable {
        Run(UniqueIdentifier, JavaScriptCode, InputParameter, RequiredNpmPackages, RuntimeSlices, BudgetForCallback);
    }

    function RingShipsBell(uint UniqueIdentifier, uint InMinutesFromNow, uint BudgetForCallback, uint Gas) public payable {
        Callback(UniqueIdentifier, InMinutesFromNow, BudgetForCallback);
    }


}

contract ICaptainJSAtTron {
    function Run(uint UniqueJobIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint BudgetForCallback) external payable;
    function Callback(uint UniqueIdentifier, uint InMinutesFromNow, uint BudgetForCallback) external payable;

    function CalculateRun(uint RuntimeSlices, uint BudgetForCallback, bool SendEvent) public  returns(uint);
    function CalculateCallback(uint InMinutesFromNow, uint BudgetForCallback, bool SendEvent) public  returns (uint);
}