// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RockPaperScissors{
    address public owner;
    modifier onlyOwner{
        require(msg.sender == owner);
        _; 
    }
    event GameEnd(address player, uint256 amount, uint8 option, uint8 result); 
    constructor() {
        owner = msg.sender;
    }
    function playGame(uint8 _option) public payable{   //с фронта 0-rock 1-scissors 2-papper
        require(msg.value*2 <= address(this).balance, "no have money for you");
        uint choise;
        if (block.timestamp%2==0){
            choise=0; //rock
        }else if (block.timestamp%3==0){
            choise=1; //scissors
        }else{
            choise=2; //papper
        }

        if ((choise == 0 && _option == 2) ||(choise == 1 && _option == 0) ||(choise == 2 && _option == 1)){
            payable(msg.sender).transfer(msg.value*2);
            emit GameEnd(msg.sender, msg.value, _option, 0 ); //победа
        } else if ((choise == 0 && _option == 1) ||(choise == 1 && _option == 2) || (choise == 2 && _option == 0)){
            emit GameEnd(msg.sender, msg.value, _option, 1 );// проигрыш
        }else{
            emit GameEnd(msg.sender, msg.value, _option, 2 );
            payable(msg.sender).transfer(msg.value); //ничья
        }
    }
    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
    receive() payable external{}
}