// Nome: Luiz Felipe
// Nome: Julia Guardiani
// Conta do contrato: 0x340FD1D5EDDaaD8e105F9Ab438D282B7626F1621
// link https://ropsten.etherscan.io/tx/0x3282ad58ac51d0d5f2c78a695d414732ea5c3d4ba6ae5416dc0bd25f98695c07


// Seu contrato começa aqui!
pragma solidity ^0.8.7;
import "2_Owner.sol";
contract factoryRifa is Owner{
    uint32 [] private rifas;
    uint32 private rifas_counter;
    uint256 private cash;
    address payable private winner_address;
    mapping(address => uint32 []) private rifa_balance;
    address payable [] private  _users;

    constructor () isOwner() { 
    }
    function _createRifa() private isOwner {
        rifas_counter++;
        rifas.push(rifas_counter);
    }
    function createRifas(uint amount) external isOwner
    {
        require(winner_address == address(0), "O vencedor ja foi sorteado");        
        for (uint i = 0; i < amount; i++)
        {
            _createRifa();
        }
    }
    function _getRifaFromDatabase() private returns (uint32) {
        require(rifas.length > 0, "Nenhuma rifa foi gerada");
        uint32 rifa = rifas[rifas.length - 1];
        rifas.pop();
        return rifa;
    }
    function buyRifa() public payable returns (uint)
    {
        require(winner_address == address(0), "O vencedor ja foi sorteado");
        uint amount = msg.value;
        amount = amount / (0.1 ether );
        uint bought_counter = 0;
        // this user never bought any other rifa
        // so we need to register it
        if(rifa_balance[msg.sender].length == 0 ) 
        {
            address payable sender = payable(msg.sender);
            _users.push(sender);
        }
        for (uint i = 0; i < amount; i++)
        {
            uint32 rifa = _getRifaFromDatabase();
            rifa_balance[msg.sender].push(rifa);
            bought_counter++;
        }
        cash += msg.value;
        return bought_counter;
    }
    function getAwardValue() public view returns (uint)
    {   
        return cash/2;
    }
    function drawWinner() external isOwner returns (address)
    {
        require(winner_address == address(0), "O vencedor ja foi sorteado");
        uint user_id = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % _users.length;
        winner_address = _users[user_id];
        return _users[user_id];
    }
    function clearData() private {
        delete winner_address;
        delete rifas;
        for (uint i = 0; i < _users.length; i++)
        {
            delete rifa_balance[address(_users[i])];
        }
        delete _users;

        rifas_counter = 0;
        cash = 0;
    }
    function withdrawAward() external payable returns (uint) {
        require(msg.sender == winner_address, "O vencedor nao eh voce");
        uint256 award = getAwardValue();
        payable(msg.sender).transfer(getAwardValue());
        clearData();
        return award;
    }
}   
