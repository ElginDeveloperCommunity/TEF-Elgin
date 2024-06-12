# Exemplo Python API TEF Elgin | Linux & Windows

## Documentação
Para compreender o funcionamento da API usar como referência a [documentação](https://elgindevelopercommunity.github.io/group__t2.html).

## Exemplo Python para utilizar a API do Tef Elgin.

Para o exemplo foi usada a seguinte bibliotecas:
- Windows: [E1_Tef01.dll](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Biblioteca), depende da instalação dos programas neste [link.](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Instaladores)
- Linux: [libE1_Tef.so.01.01.00](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Exemplos%20TEF%20API%20-%20Ativo/Python/libE1_Tef.so.01.01.00), depende da instalação dos programas neste [link.](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Instaladores)

O exemplo foi escrito com python 3.10 x64, se quiser testar com a versão x86, basta trocar biblioteca para a versão x86.

## Requisitos para Teste ##
Antes de poder testar o exemplo, instalar todos os componentes necessários descritos na [documentação de instalação](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Instaladores/Manual%20instala%C3%A7%C3%A3o%20TEF%20Elgin_Homologa%C3%A7%C3%A3o.pdf).
- **Tkinter** - para interface gráfica
- **Python 3.10** - versão do python com suporte a biblioteca interna `asyncio` que permite multithreading entre a interface do usuário e a lógica do tef.

### Teste
Para testar o exemplo:
- com interface gráfica, baixar os seguintes arquivos: 
	- [exemplo-elgintef.py](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Exemplos%20TEF%20API%20-%20Ativo/Python/exemplo-elgintef.py) (programa com lógica do tef e interface com tkinter)
	- [elgintef.py](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Exemplos%20TEF%20API%20-%20Ativo/Python/elgintef.py) (esse arquivo chama as funções da lib).
	- (linux) [libE1_Tef.so.01.01.00](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Exemplos%20TEF%20API%20-%20Ativo/Python/libE1_Tef.so.01.01.00) ou (win) [E1_Tef01.dll](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Exemplos%20TEF%20API%20-%20Ativo/Python/E1_Tef01.dll) 
	- [edc-ico.ico](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Exemplos%20TEF%20API%20-%20Ativo/Python/edc-ico.ico)
- no terminal, baixar os seguintes arquivos: 
	- [exemplo-elgintef-terminal.py](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Exemplos%20TEF%20API%20-%20Ativo/Python/exemplo-elgintef-terminal.py) (programa com lógica do tef e interface com tkinter)
	- [elgintef.py](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Exemplos%20TEF%20API%20-%20Ativo/Python/elgintef.py) (esse arquivo chama as funções da lib).
	- (linux) [libE1_Tef.so.01.01.00](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Exemplos%20TEF%20API%20-%20Ativo/Python/libE1_Tef.so.01.01.00) ou (win) [E1_Tef01.dll](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Exemplos%20TEF%20API%20-%20Ativo/Python/E1_Tef01.dll) 

## Imagens do Programa ##

<img src="https://user-images.githubusercontent.com/78883867/188001050-2cda4ea7-9dc1-4dc2-8c4d-0f9c8c61a491.jpg" alt="telaPrincipal" style="width:300px;"/>
<img src="https://user-images.githubusercontent.com/78883867/188001049-7b75b24f-2a70-4b6b-ad0c-486a7cf34e99.jpg" title="tela representa um dos passos do processo de pagamento" alt="telaPagamento" style="width:800px;"/>
