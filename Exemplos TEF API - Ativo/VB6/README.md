# Exemplo VB6 TEF API #

Foi utilizada a biblioteca:
- **APITEFElgin.dll**, depende da instalação dos programas neste [link.](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Instaladores)

<hr>

## Requisitos para Teste ##
1. Antes de poder testar o exemplo, deve-se fazer a instalação de todos os componentes necessários descritos na [documentação de instalação](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Documenta%C3%A7%C3%A3o/MANUAL%20DE%20INSTALA%C3%87%C3%83O%20TEF%20ELGIN.pdf).<br>
Para compreender o funcionamento da API usar como referência esse [documento](https://github.com/ElginDeveloperCommunity/TEF-Elgin/blob/master/Documenta%C3%A7%C3%A3o/API%20TEF%20ELGIN-1.02.pdf).
<br>
2. Instalar o arquivo a seguir seguindo as instruções. (Win 10)
    + Baixar [esse arquivo] .zip e descompactar.
    + Abrir um cmd ou powershell na pasta descompactada (isso pode ser feito com o atalho <code><Ctrl+l + cmd + enter></code>)
    + Executar o seguinte comando para copiar o arquivo na pasta necessário <code>copy msflxgrd.ocx C:\Windows\SysWoW64</code>
    +Executar o seguinte comando para registrar a biblioteca <code>C:\Windows\SysWoW64\regsvr32 msflxgrd.ocx</code>

### Teste ###
Para testar o exemplo, baixe essa [pasta](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Exemplos%20TEF%20API%20-%20Ativo/C%23/TEFAPI/TEFAPI/bin/x86/Debug) e execute o arquivo .exe.

