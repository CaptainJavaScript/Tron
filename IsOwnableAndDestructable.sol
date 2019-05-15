pragma solidity ^0.4.25;

contract IsOwnableAndDestructable {
    address Owner;
    constructor () internal {
        Owner = msg.sender;
    }

    function Destruct() public onlyOwner {
        selfdestruct(Owner);
    }

    function Payout(uint Amount) public onlyOwner {
        address(Owner).transfer(Amount);
    }

    modifier onlyOwner {
        require(
            msg.sender == Owner,
            "row, row, row your boat seaman. Your captain's cabin is closed..."
        );
        _;
    }

    event LogEvent(string message);
    bool CommitFlag = false;

    function Ping() external {
        emit LogEvent("Pong!");
        CommitFlag = false;
    }

    function () payable external {
        emit LogEvent(
            concat(
                "received some money... current balance = ", 
                uintToString(address(this).balance), 
                " / receive money = ",
                uintToString(msg.value)
            )
        );
        CommitFlag = true;
    } 



    // HELPERS
    
    function concat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function concat(string _a, string _b) internal pure returns (string){
        return concat(_a, _b, "", "", "");
    }

    function concat(string _a, string _b, string _c, string _d) internal pure returns (string){
        return concat(_a, _b, _c, _d, "");
    }

    function concat(string _a, string _b, string _c) internal pure returns (string){
        return concat(_a, _b, _c, "", "");
    }

    function uintToString(uint v) internal pure returns (string str) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = byte(48 + remainder);
        }
        bytes memory s = new bytes(i);
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - 1 - j];
        }
        str = string(s);
    }

    function StringToUint(string s) internal pure returns (uint result) {
        bytes memory b = bytes(s);
        uint i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint(b[i]);
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
    }

}
