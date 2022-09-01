# Exemplo Python API TEF Elgin | Linux & Windows

## Documentação
Para compreender o funcionamento da API usar como referência a [documentação](https://elgindevelopercommunity.github.io/group__t2.html).

## Exemplo Python para utilizar a API do Tef Elgin.

Para o exemplo foi usada a seguinte bibliotecas e requisitos:
- Windows: [E1_Tef01.dll](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Biblioteca), depende da instalação dos programas neste [link.](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Instaladores)
- Linux: [libE1_Tef.so.01.01.00](), depende da instalação dos programas neste [link.](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Instaladores)

## Requisitos para Teste ##
Antes de poder testar o exemplo, instalar todos os componentes necessários descritos na [documentação de instalação](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Instaladores/Manual%20instala%C3%A7%C3%A3o%20TEF%20Elgin_Homologa%C3%A7%C3%A3o.pdf).
- **Tkinter** - para interface gráfica
- **Python 3.10** - versão do python com suporte a biblioteca interna `asyncio` que permite multithreading entre a interface do usuário e a lógica do tef.

### Teste
Para testar o exemplo:
- com interface gráfica, baixar os seguintes arquivos: 
	- [exemplo-elgintef.py]() (programa com lógica do tef e interface com tkinter)
	- [elgintef.py]() (esse arquivo chama as funções da lib).
	- (linux) [libE1_Tef.so.01.01.00]() ou (win) [E1_Tef01.dll]() 
	- [edc-ico.ico]()
- no terminal, baixar os seguintes arquivos: 
	- [exemplo-elgintef-terminal.py]() (programa com lógica do tef e interface com tkinter)
	- [elgintef.py]() (esse arquivo chama as funções da lib).
	- (linux) [libE1_Tef.so.01.01.00]() ou (win) [E1_Tef01.dll]() 

## Imagens do Programa ##

<img src="" alt="telaPrincipal" style="width:300px;"/>
<img src="" title="tela representa um dos passos do processo de pagamento" alt="telaPagamento" style="width:800px;"/>
