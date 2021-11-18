// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import './erc20.sol';
import './SafeMath.sol';
import './Context.sol';

/// @title Lunyr crowdsale contract
contract HHToken is ERC20 {
    using SafeMath for uint;
    using SafeERC20 for IERC20;

//    string public constant name = 'black sea digital fund'; //todo name
//    string public constant symbol = 'BCDF'; //todo symbol
//    uint8 public constant decimals = 6; // usdt保持一直一致
    uint256 public _tokenCreationMax ;
    constructor() public
    ERC20(
        string(abi.encodePacked("black sea digital fund")),
        string(abi.encodePacked("BSDF"))
    )
    {
        _setupDecimals(6);
        _tokenCreationMax = 500000000 * 100000; //TODO INIT

    }

   // IERC20 public usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    address public usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

//    mapping(address => uint256) private _balances;
//
//    mapping(address => mapping(address => uint256)) private _allowances;
//
//    uint256 private _totalSupply;




    // 收U 发币
    function buy(uint256 amount) external {
        IERC20(usdt).safeTransferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
        require(totalSupply() < _tokenCreationMax, "Token Create Max");
        // todo event ?
    }
}
