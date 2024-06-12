# Elgin Tef Web

Acesse a documentação aqui: https://elgindevelopercommunity.github.io/group__g14.html

No arquivo [app.js](/app.js) podem ser vistas todas as chamadas API possíveis a ser feitas no TEF Web.
Para testar no Android, instale a última versão do [IDH](https://github.com/ElginDeveloperCommunity/TEF-Elgin/tree/master/Instaladores_Android/Homologa%C3%A7%C3%A3o/IDH), e abra esse [link](https://elgindevelopercommunity.github.io/elgin-tef-web/).

## Desenvolvimento
Para desenvolvimento no Android é indicado seguir os seguintes passos:
1. Conectar o equipamento Android com o PC de desenvolvimento via wifi.
    * conectar o cabo debug no PC e no shell de preferência conferir que o ADB reconheceu o device: `adb devices`
    * `adb tcpip 5555` para executar o servidor tcp do adb
    * verificar no a página de wifi do seu device qual IP seu device pegou na rede
    * `adb connect <ip do seu device>`
    * agora já pode desconectar o cabo debug, e agora poderá conectar o pinpad e carregador.
2. Abrir o aplicativo do google chrome no seu device e abrir o link da página para desenvolvimento.
3. No PC, abrir o google chrome e acessar a url `chrome://inspect/#devices`, aguarde alguns segundos e o seu device android irá aparecer nas opções de **Remote Target**, onde poderá acessar remotamente o console do seu chrome do seu android clicando em **inspect**