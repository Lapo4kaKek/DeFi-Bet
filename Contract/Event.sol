// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Bet.sol";

contract Event {
    string title;
    bool isActive;
    Bet[] yesBets;
    Bet[] noBets;
}
