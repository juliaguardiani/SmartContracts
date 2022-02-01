
# Desenvolvimento de Smart Contracts no Ethereum

Usando a IDE [Remix](http://remix.ethereum.org), desenvolva dois contratos inteligentes: um que implemente um sistema de **rifa** descentralizado e outro que implemente um sistema simplificado de **poupança** descentralizado e autônomo. Esses *smart contracts* serão implantados no blockchain de testes do Ethereum conhecido como *Ropsten Test Network*. Para integração com o Remix, lembre-se que é necessário uma carteira (*wallet*) MetaMask instalada em seu navegador. Também é necessário ao menos uma conta na rede Ropsten com saldo positivo. Para obter *ether* nesta rede, utilize um dos Faucets abaixo, conforme já solicitado em aulas anteriores.

[https://faucet.metamask.io](https://faucet.metamask.io/)

[https://faucet.ropsten.be](https://faucet.ropsten.be/)


## Smart Contract `rifa.sol`

Implemente as seguintes funções:

- Função para comprar quantas rifas quiser, baseado no valor (`msg.value`) enviado na transação. O preço deve ser de 0,1 *ether* cada rifa. 

*Ex: Se eu quiser posso comprar 3 rifas de uma vez incluindo 0,3 *ether* na transação.*

- Função para retornar o prêmio atual (em *wei*). O prêmio é 50% do total arrecadado até o momento. O restante fica como saldo do contrato.

*Ex: Se no momento que essa função é chamada já tiverem sido vendidas 100 rifas, a função deve retornar 5000000000000000000, equivalente a 5 ether.*

- Função para retornar o total de rifas compradas pela conta que gerou a transação para esta função.  

*Ex: Se a conta `0x8cb32fEc81882D046b95D9e761fC09931e2E8F7b` comprou 3 rifas, quando esta conta gerar uma transação chamando essa função deve retornar o valor 3.*

- Função para sortear a rifa, com a restrição de que somente o dono do contrato (aquele que fez o *deploy*) pode chamar essa função. Ao chamar essa função deve ser sorteado, aleatoriamente uma das rifas previamente criadas. Essa função não deve transferir o prêmio para o ganhador, mas sim liberar a possibilidade do ganhador sacar o prêmio a partir da chamada da função de sacar prêmio. Para gerar um número aleatório utilize a função abaixo, adaptado para o seu programa:

```javascript
// Gerando números aleatórios entre 1 e 100:
uint random = uint(keccak256(abi.encodePacked(now, msg.sender))) % 100;
```

- Função para sacar todo o prêmio (transferir da conta do contrato para a conta do ganhador), caso o remetente (`msg.sender`) da transação seja o ganhador do rifa, retornando o valor sacado.

*Ex: Se a conta `0x8cb32fEc81882D046b95D9e761fC09931e2E8F7b` é o ganhador, ao chamar essa função haverá uma transferência do prêmio da conta do contrato para conta desse usuário, retornando o valor transferido.*

## Smart Contract `poupanca.sol`

Seu contrato deve permitir que usuários depositem determinado valor de *ether* e especifiquem um tempo, em dias, de no máximo 30 dias e mínimo 1 dia. Esse valor não poderá ser resgatado pelo usuário até a data estipulada, e caso queira sacar antes do tempo determinado, deverá ser paga uma taxa de 10% do valor originalmente depositado (que ficará para o contrato). Caso o tempo estipulado já tenha sido cumprido, o resgate é realizado sem custos adicionais, e somente pode ser realizado de forma integral (todo o valor originalmente depositado).

Note que o objetivo desta poupança não é prover rendimentos para o cliente, e sim funcionar como uma maneira de não permitir que tal valor seja gasto antes do tempo estipulado, sendo assim uma "poupança forçada", sem a necessidade de terceiros.

Implemente as seguintes funções:

- Função para depositar um valor definindo o tempo (em dias) em que o valor ficará bloqueado.

*Ex: Se eu quiser posso depositar 10 ether por 10 dias.*

- Função para consultar o valor depositado pelo remetente da transação.

*Ex: Se eu quiser posso consultar o meu saldo na poupança, retornando 10 ether.*

- Função para consultar o tempo restante para resgatar meu depósito sem multas.

*Ex: Se eu quiser posso consultar o tempo restante do meu depósito, por exemplo, 9 dias.*

- Função para consultar o valor da multa caso queira sacar o valor antes do tempo.

*Ex: Se eu quiser posso consultar minha multa, a função retornará 0,1 ether.*

- Função para resgatar o valor depositado em sua totalidade.

*Ex: Se eu quiser posso sacar meu valor depositado. Caso o tempo já tenha sido cumprido, não é necessário enviar nenhum valor na transação. Caso o tempo ainda não tenha sido cumprido, é necessário incluir como valor da transação o valor da multa.*

- Função para transferir a propriedade de um depósito para outro endereço.

*Ex: Se eu quiser eu posso depositar 10 ether, e depois trocar a propriedade desse depósito para um outro endereço. Desta forma, este outro endereço será o novo dono do depósito e poderá sacar o valor.*

