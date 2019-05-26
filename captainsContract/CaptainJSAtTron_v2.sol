pragma solidity ^0.4.25;

import "./IsOwnableAndDestructable.sol";
import "./ISeamanJSAtTron.sol";

contract CaptainJSAtTron_v2 is IsOwnableAndDestructable {


    uint PricePerSlice;
    uint PricePerBellRing;

    constructor () public {
        PricePerSlice      = 200000;
        PricePerBellRing   =   1000; 
    }

    event PriceInformationEvent(address Requestor, uint Amount, uint BudgetForCallback, uint Price);

    function CalculateRun(uint RuntimeSlices, uint BudgetForCallback, bool SendEvent) public returns(uint) {
        uint Price = (RuntimeSlices * PricePerSlice) + BudgetForCallback;
        if(SendEvent) {
            emit PriceInformationEvent(msg.sender, RuntimeSlices, BudgetForCallback, Price);
            CommitFlag = true;
        }
        return Price;
    }

    function CalculateCallback(uint InMinutesFromNow, uint BudgetForCallback, bool SendEvent) public returns (uint) {
        uint Price = (InMinutesFromNow * PricePerBellRing) + BudgetForCallback;
        if(SendEvent) {
            emit PriceInformationEvent(msg.sender, InMinutesFromNow, BudgetForCallback, Price);
            CommitFlag = true;
        }
        return Price;
    }


    event NextJobToExecuteEvent(
        uint UniqueJobIdentifier, 
        address ClientAddress, 
        string JavaScriptCode, 
        string InputParameter, 
        string RequiredNpmPackages, 
        uint RuntimeSlices, 
        uint GasForCallback, 
        uint GasPriceInWei, 
        bool HasVoucherCode);
        
    function Run(uint UniqueJobIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint BudgetForCallback) external payable {
        uint Price = CalculateRun(RuntimeSlices, BudgetForCallback, false);

        require(msg.value >= Price, concat(
            "row, row, row your boat seaman... price = ",
            uintToString(Price),
            " / you sent ",
            uintToString(msg.value)
        ));
        
        emit NextJobToExecuteEvent(UniqueJobIdentifier, msg.sender, JavaScriptCode, InputParameter, RequiredNpmPackages, RuntimeSlices, BudgetForCallback, 1, false);
        CommitFlag = true;
    }


    function Callback(uint UniqueIdentifier, uint InMinutesFromNow, uint BudgetForCallback) external payable {
        uint Price = CalculateCallback(InMinutesFromNow, BudgetForCallback, false);
        
        require(
            msg.value >= Price, concat(
            "row, row, row your boat seaman... price = ",
            uintToString(Price),
            " / you sent ",
            uintToString(msg.value)
        ));

        emit NextShipBell(UniqueIdentifier, InMinutesFromNow, msg.sender, BudgetForCallback, 1, false);
        CommitFlag = true;
    }

    function JSResult(address Seaman, uint UniqueJobIdentifier, string  Result, bool IsError) external onlyOwner {
        ISeamanJSAtTron(Seaman).CaptainsResult(UniqueJobIdentifier, Result, IsError);
    }

    function WakeUpSeaman(address Seaman, uint UniqueIdentifier) external onlyOwner {
        ISeamanJSAtTron(Seaman).CaptainsCallback(UniqueIdentifier);
    }


    event NextShipBell(
        uint UniqueIdentifier, 
        uint InMinutesFromNow, 
        address ClientAddress, 
        uint GasForCallback, 
        uint GasPriceInWei, 
        bool HasVoucher);




}
