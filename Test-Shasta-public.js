console.log("starting...");

const TronWeb = require('tronweb');
const SHASTA = 'https://api.shasta.trongrid.io';

const tronWeb = new TronWeb(
    SHASTA, SHASTA, SHASTA,
    '<your private key goes here'
);

const OwnersWalletAtSHASTA = "<your shasta wallet address>";

const CaptainsAddressAtSHASTA = "TGQZKU6uebCMuy5iTthB12PUc2A1BsjkDr";
const CaptainsAddressAtSHASTAhex = "41469c1d25bf7c4c02f110a8d8cdfeb949a0e64f2b";
const HelloSeaman_v1AtSHASTA = "TB4TEvEnbjM66ici2QjP92rpYkJWJPJajS";


var CaptainsContract;
var SeamansContract;

const _1TRX = 1000000;

function ToTRX(amount) {
    return Math.abs(amount * _1TRX);
}

async function PriceInformationEvent(err, {result}) {
    if(err)
        console.log("ERROR@PriceInformationEvent");
    else
    {
        var Requestor = result.Requestor; 
        var Amount = result.Amount;
        var BudgetForCallback = result.BudgetForCallback;
        var Price = result.Price;

        console.log("----> PriceInformationEvent: Requestor: " + Requestor + ", Amount: " + Amount + ", Budget: " + BudgetForCallback + ", Price: " + Price + " ...");
    } 
}

async function DemoRunsEvent(err, {result}) {
    if(err)
        console.log("ERROR@DemoRunsEvent");
    else
        console.log("----> DemoRunsEvent fired");
}


async function NextShipBell(err, {result}) {
    if(err)
        console.log("ERROR@NextShipBell");
    else
    {
        console.log("|----------------NextShipBell:");
        console.log(result);
    } 
}


async function NextJobToExecuteEvent(err, {result}) {
    if(err)
        console.log("ERROR@NextJobToExecuteEvent");
    else
    {
        console.log("|----------------NextJobToExecuteEvent:");
        console.log(result);

    } 

    const balanceAFTER = await tronWeb.trx.getBalance(CaptainsAddressAtSHASTA);
    console.log("balance AFTER = " + balanceAFTER);
}

async function LogEvent(err, {result}) {
    if(err)
        console.log("ERROR@LOGEVENT");
    else
    {
        var Message = result.message; 

        console.log("----> LogEvent: " + Message + "...");
    } 
}

function RunTest() {
    var Budget = ToTRX(0.01);
    var Transfer = ToTRX(0.5);
    console.log("RunTest / Budget = " + Budget + ", Transfer Value = " + Transfer);
    SeamansContract.Run(1, "math:log2(16)", "", "mathjs", 1, Budget).send({shouldPollResponse: true, callValue: Transfer}).catch(function(err) { console.log(err); }).then( console.log("RUN EXECUTED") );
}


function CallbackTest() {
    var Budget = ToTRX(0.01);
    var Transfer = ToTRX(0.5);
    console.log("CallbackTest / Budget = " + Budget + ", Transfer Value = " + Transfer);
    SeamansContract.Callback(2, 1, Budget).send({shouldPollResponse: true, callValue: Transfer}).catch(function(err) { console.log(err); }).then( console.log("CALLBACK EXECUTED") );
}

function SetCaptainsAddress() {
    console.log("SetCaptainsAddress to " + CaptainsAddressAtSHASTAhex);
    SeamansContract.SetCaptainsAddress(CaptainsAddressAtSHASTAhex).send({shouldPollResponse: true, callValue: 0}).catch(function(err) { console.log(err); }).then( console.log("SETCAPTAINSADDRESS EXECUTED") );
}


function CalculateCallback() {
    console.log("Calculating callback price...");
    CaptainsContract.CalculateCallback(1, ToTRX(0.01), true).send({shouldPollResponse: true, callValue: 0}).catch(function(err) { console.log(err); }).then( console.log("CALCULATE CALLBACK EXECUTED") );
}


function CalculatePrice() {
    console.log("Calculating run price...");
    CaptainsContract.CalculateRun(1, ToTRX(0.01), true).send({shouldPollResponse: true, callValue: 0}).catch(function(err) { console.log(err); }).then( console.log("CALCULATE PRICE EXECUTED") );
}

function Demo() {
    console.log("Demo run...");
    SeamansContract.Demo().send({shouldPollResponse: true, callValue: ToTRX(1)}).catch(function(err) { console.log(err); }).then( console.log("DEMO EXECUTED") );
}

async function GetHistoricalEvents() {

    tronWeb.getEventResult(CaptainsAddressAtSHASTA, {
        eventName:'NextJobToExecuteEvent',
        size: 20,
        page: 2
      }).then(evnts => {
          console.log(evnts.length + " events");
          for(i = 0; i < evnts.length; i++)
          {
              var evnt = evnts[i];
              console.log(evnt.block + ", " + evnt.timestamp + ", " ); //+ evnt.result.JavaScriptCode + ", " + evnt.result.UniqueJobIdentifier);
          }
      })
}

async function Go() {
    CaptainsContract = await tronWeb.contract().at(CaptainsAddressAtSHASTA);
    console.log("connected to captains contract... @ " + CaptainsContract.address);

    const balanceBefore = await tronWeb.trx.getBalance(CaptainsAddressAtSHASTA);
    console.log("balance BEFORE = " + balanceBefore);
    console.log("sending some money...");
    tronWeb.trx.sendTrx(CaptainsAddressAtSHASTA, ToTRX(10));
    tronWeb.trx.sendTrx(HelloSeaman_v1AtSHASTA, ToTRX(10));

    console.log("attaching to events...");
    CaptainsContract.NextJobToExecuteEvent().watch(NextJobToExecuteEvent);
    CaptainsContract.LogEvent().watch(LogEvent);
    CaptainsContract.PriceInformationEvent().watch(PriceInformationEvent);
    CaptainsContract.NextShipBell().watch(NextShipBell);

    SeamansContract = await tronWeb.contract().at(HelloSeaman_v1AtSHASTA);
    console.log("connected to seamans contract... @ " + SeamansContract.address);

    console.log("attaching to events...");
    SeamansContract.LogEvent().watch(LogEvent);
    SeamansContract.LogEvent().watch(DemoRunsEvent);

    console.log("invoking seaman...");
    
    SetCaptainsAddress();
    // CalculatePrice();
    // CalculateCallback();
    
    // Demo();
}


Go();




