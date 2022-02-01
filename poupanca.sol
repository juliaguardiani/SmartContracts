// Nome: Júlia Guardiani
// Nome: Luiz Felipe
// Conta do contrato: <https://ropsten.etherscan.io/address/0xffabb96816b3eab6d7c8d5514347e62a1b6d4caf>
pragma solidity ^ 0.4.25;

contract poupanca{
    struct Poupanca{
        uint256 valor; 
        uint desbloqueio;
        address owner;
    }  
    address owner;
    mapping (address => Poupanca) private poupanca_owner; 
    Poupanca[] private poupancas;
    constructor() public {
        //cria uma relacao com o dono.
        owner =  msg.sender;
    }
    event PoupancaNova(address owner,uint256 _valor,uint desbloqueio);
    event Deposit(address owner, uint value);
    event MostratPoupanca(uint valor);
    event MostrarMulta(uint multa);
    event TempoPerdido(uint valor);
    event RetiradaSucesso(address owner,uint valor);
    modifier onlyOwner {
        require(msg.sender == owner);
        _; // <--- note the '_', which represents the modified function's body
    }
    //payble para retirar dinheiro as moedas direto da conta
    function Depositar(uint _daysAfter) public payable {
        require(owner == msg.sender);
    
        require(_daysAfter>0, "Dias negativos");
        uint _desbloqueio = block.timestamp + _daysAfter * 1 days;
        poupanca_owner[msg.sender] = Poupanca(msg.value,_desbloqueio,owner);
        emit Deposit(msg.sender, msg.value);
        poupancas.push(poupanca_owner[msg.sender]); // dando um push na lista de dicionarios de poupanca
    }
    function ViewSaldo() public view returns (uint){
        return poupanca_owner[msg.sender].valor;
    }
    function ViewTempoBloq() public view returns (uint){
        if ((poupanca_owner[msg.sender].desbloqueio - block.timestamp)/(24*3600) > 0){
            return uint((poupanca_owner[msg.sender].desbloqueio - block.timestamp)/(24*3600));
        }
        else{
            return 0;
        }
    }
    function ViewMulta() public view returns (uint){
        //se os dias ja zeraram
        if ((poupanca_owner[msg.sender].desbloqueio - block.timestamp) > 0){
            return uint(poupanca_owner[msg.sender].valor/10);
        }
        else{
            return 0;
        }
    }
    function Saque() public {
        require(owner == msg.sender);
        uint _multa = ViewMulta();
        uint _valor = poupanca_owner[msg.sender].valor - _multa;
        poupanca_owner[msg.sender].valor = 0;
        owner.transfer(_valor);
        emit RetiradaSucesso(owner,_valor);
    }
    function Trasferencia(address recebedor) public{
        require(owner == msg.sender);
        uint _multa = ViewMulta();
        uint _valor = poupanca_owner[msg.sender].valor - _multa;
        poupanca_owner[msg.sender].valor = 0;
        recebedor.transfer(_valor);
        emit RetiradaSucesso(recebedor,_valor);
    }
}
