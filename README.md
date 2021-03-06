
# TEF-Elgin
O Tef Pay Elgin é uma solução que fornece para Automação Comercial integração para que seja possivel a captura de transações financeiras através de diversos concentradores de Tef disponíveis no mercado.

A Solução de TEF Elgin conta também com um módulo `E1_TEFPay_Passivo` que foi desenvolvida para facilitar as transações Eletrônicas usando o Modo de troca de arquivos com mensageria padrão `CHAVE = VALOR`

# Downloads
- [VPN](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Instaladores)
- [Instalador API](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Instaladores)
- [Módulo passivo para operação de troca de arquivos](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Instaladores)
- [Manuais](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Documenta%C3%A7%C3%A3o)


# Por onde começar?
## 1 - JAVA(JRE)
Será necessario primeiramente verificar a instalação do Java SE Runtime Enviroment (JRE), por ser uma dependência da VPN que vamos ver logo a frente é necessário sua instalação p-ara funcionamento do mesmo.
A Versão recomendada para instalação é a JRE 8u271 e pode ser encontrada no link abaixo:
https://www.oracle.com/java/technologies/javase-jre8-downloads.html 
## 2 - VPN 
A VPN é responsável por possibilitar a comunicação do PDV com servidor Elgin responsável por autorizar as transações.
Para realizar sua instalação siga os passos abaixo:
 > IMPORTANTE – É necessário ter conexão com a internet no momento da instalação da VPN* 
 
1. Realize a instalação do executável configLSS-4.0.exe[VPN] e insira o número PKI: 94962505, este código é responsável por identificar a sua instalação no servidor Elgin.

2. Após a instalação, será necessário fazer a configuração do LSS.
Abra a aplicação de configuração chamada de LSSConfig. A senha para iniciar a aplicação é: elgin123.

3. Após abrir, será necessário configurar as portas de comunicação. Para ambiente produtivo use as portas[2046] e [44002] para ambiente de homologação use as  portas [44002] e [44003]. Ambas precisam ser movidas de bandeiras disponiveis para bandeiras ativas usando o botão >>.

4. Feita a configuração das portas, configure os dados da empresa onde esta sendo realizada a instalação da VPN:

Feito a configuração, salve os dados e envie o código serial para Elgin realizar a ativação da VPN. O código a ser enviado se encontra no título da aplicação de configuração iniciado com LSS.

Abra um chamado em https://elginbematech.com.br/chamado/ 
Solicitando a ativação da VPN passando o número serial encontrado no passo anterior.

## 3 - API TEF Elgin 
Realize a instalação do executável APITEFElgin.v-1.2.4 1204212248.exe, ele é responsável por carregar as bibliotecas necessárias para realizar as transações, configuras as variaveis de ambiente e carregar arquivos com configurações do ambiente, como as portas e dados da empresa a ser utilizado no ponto de venda.
O local de instalação padrão da API é C:\APITEFElgin\BIN e a biblioteca a ser usada pela automação chama-se APITEFElgin.dll.
Após a instalação será necessário configurar os dados do PDV no configurador instalado em: C:\APITEFElgin\BIN\Configurador
A primeira sessão será referente a configuaração da VPN, preencha com o IP onde foi feita a instalação e a porta configurada para realizar as transações, podendo ser 2046 para produção e 44003 para homologação.
A segunda sessão é para configuração dos dados da empresa, esses dados serão enviados pela elgin. Aconselha-se que na abertura do chamado para ativação da VPN o parceiro já solicite o código da empresa, número da filial e número do pdv a ser usado na loja.
A terceira sessão configura a autenticação da api. Até o momento esse dados ja vem como default e não devem ser alterados.
Feita a configuração de todos os dados salve e feche o configurador. 
Caso precise alterar os dados abra o configurador que esta instalado na pasta C:\APITEFElgin\BIN\Configurador\ApiTefElginConfig.App.exe 

## 4 - Porta de comunicação  PinPad
Para uso da solução será necessário configurar uma porta fixa para o pinpad.
Para correta comunicação com a API é necessário que o aparelho esteja configurado na porta COM5.

No exemplo foi usado o pínpad da marca ingenico modelo ipp320 mais isso se aplica a outras marcas também.

# Módulo Passivo
O módulo passivo foi desenvolvido para facilitar a integração de parceiros que ja possuem implementações no padrão troca de arquivos.
A troca de arquivos utiliza-se de dois diretorios. Um deles necessário para automação enviar os arquivos de requisição para api. A automação grava um arquivo nesse diretório para ser lido pela API, o qual esta continuamente tentando ler arquivo nesse local. O outro diretório serve para a API Elgin enviar arquivos para a automação. A Api TEF Elgin grava o arquivo de saida nesse diretorio para ser lido pela automação.
Os diretorios são criados na execução da aplicação se caso não existirem, os caminhos usados como padrão são: 

`C:\Cliente\Req` - para arquivo de requisição de transações.

`C:\Cliente\Resp` - para arquivos de Status e de resposta para automação.

Há dois tipos de arquivos para troca de dados entre automação e APITEF. Um deles serve para enviar dados e o outro para enviar uma resposta confirmando o recebimento dos dados.
O arquivo de dados recebe o nome “INTPOS.001”. Já o arquivo de confirmação de recebimento de dados recebe o nome “INTPOS.STS”.

Abaixo segue um diagrama do fluxo de iterações entre PDV e E1_TEFPay_Passivo e logo adiante um exemplo dos arquivos de requisição e resposta:

![Diagrama de sequencia para fluxo de comunicação entre PDV e Módulo de troca de arquivos](https://user-images.githubusercontent.com/78883867/117910368-2fc08100-b2b2-11eb-8b97-952024370e13.png)

Exemplo de Transação Venda Débito/Crédito 

Arquivo IntPos.001 gerado pela Automação na Etapa 1 de uma operação CRT.
C:\Cliente\Req\IntPos.001

Dados escritos:

    000-000 = CRT
    001-000 = 1
    002-000 = 123456
    003-000 = 4500
    004-000 = 0
    999-999 = 0

Arquivo IntPos.Sts gerado pelo Módulo E1_TEFPAY_Passivo na Etapa 2 de uma operação CRT.
C:\Cliente\Resp\IntPos.Sts

Dados retornados pela API:

    000-000 = CRT
    001-000 = 1
    999-999 = 0

Arquivo IntPos.001 gerado pelo Módulo E1_TEFPAY_Passivo na Etapa 4 de uma operação CRT. (Após a captura da transação na etapa 3)
C:\Cliente\Resp\IntPos.001

Dados retornados pela API:

    000-000 = CRT
    001-000 = 1
    002-000 = 123456
    003-000 = 4500
    010-000 = ELECTRON
    010-001 = 103
    010-003 = 21
    010-004 = 417402
    010-005 = 7578
    011-000 = 03603511027
    012-000 = 001315
    013-000 = 001315
    018-000 = 01
    022-000 = 0326
    023-000 = 192414
    028-000 = 37
    029-001 = ELGIN PAY TESTE BANRISUL
    029-002 = 92.702.067/0001-96   
    029-003 = R CAPITAO MONTANHA, 177
    029-004 = CENTRO PORTO ALEGRE RS
    029-005 = 
    029-006 = 
    029-007 = 
    029-008 = 
    029-009 =                  REDE                 
    029-010 = 
    029-011 = REDESHOP  -      OKI                  
    029-012 = 
    029-013 = 
    029-014 = COMPROV: 123456789 VALOR: 45,00
    029-015 = 
    029-016 = ESTAB:013932594 SCOPE TESTE SIMULADO  
    029-017 = DD.MM.AA-HH:MM:SS TERM:PV123456/pppnnn
    029-018 = CARTAO: ************7578
    029-019 = AUTORIZACAO: 123456                   
    029-020 = ARQC:36DEFEF9D3490BC5
    029-021 = 
    029-022 = **************************************
    029-023 =          D E M O N S T R A C A O      
    029-024 =  Transacao sem validade para reembolso
    029-025 =     Autorizacao gerada por simulador  
    029-026 = **************************************
    029-027 = 
    029-028 =     TRANSACAO AUTORIZADA MEDIANTE     
    029-029 =         USO DE SENHA PESSOAL.         
    029-030 =                                       
    029-031 = 0
    029-032 = CONTROLE 03603511027  OKI BRASIL SCOPE
    029-033 = 
    029-034 = 
    029-035 = 
    029-036 = 
    029-037 = 
    030-000 = Transação Finalizada com Sucesso
    043-000 = SIMULADOR
    047-000 = 00
    050-000 = 000
    150-000 = 000000000000002
    210-004 = 4174020000007578=25080000000000000000
    210-052 = 001
    210-052 = 001
    300-001 = 0825
    600-000 = 01425787000104
    701-016 = 0326
    999-999 = 0

Arquivo IntPos.001 gerado pela Automação na Etapa 6 de uma operação CRT. (Após a automação ter realizado a impressão e armazenado os dados da transação)
C:\Cliente\Req\IntPos.001

Dados Escritos pela automação para confirmação de uma venda:

    000-000 = CNF
    001-000 = 1
    027-000 = 123456
    999-999 = 0
    
Arquivo IntPos.Sts gerado pelo Módulo E1_TEFPAY_Passivo na Etapa 7 de uma operação CRT.
C:\Cliente\Resp\IntPos.Sts

Dados Retornados pela API:

    000-000 = CNF
    001-000 = 1
    999-999 = 0
