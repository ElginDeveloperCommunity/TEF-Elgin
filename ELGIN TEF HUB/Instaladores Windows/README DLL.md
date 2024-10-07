<!-- 
Este arquivo contem as notas de liberação para o software Elgin TEFHUB :: E1_TEF
Para novas atualizações adicione o bloco abaixo com os detalhes da liberação:

///INICIO

## {DATA} - v{VERSÃO}

### Melhorias
- {Descrição da melhoria para area de negócios.}
  - {Descrição da melhoria para area tecnica.}

### Correções
- {Descrição da correção para area de negócios.}
  - {Descrição da correção para area tecnica.}

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.08.00    |
| E1_UPDATER  | 01.02.00    |
| E1_UPLOADER | 01.00.08    |
| Provider 2  | 2.3.0       |
| Provider 3  | C042000-D00 |
| Provider 5  | 4.3.9       |

----------------------------------------------

///FIM
-->
# Release Notes - Lib E1_TEF
----------------------------------------------
<!-- Adiciona novas entradas abaixo deste comentário -->

## 26/09/2024 - v02.22.01

### Melhorias
- Envio de dados presentes no arquivo de configuração da biblioteca para os servidores Elgin.
  - Os dados sobre o PDV configurados na biblioteca, através do método *ConfigurarDadosPDV* ou editando diretamente o arquivo, agora também são enviados aos servidores de parametrização e histórico.
- Inclusão do "Identificador do Terminal" no comprovante das transações.
  - A última linha dos comprovantes gerados agora possuem a informação do "Identificador do Terminal" (no formato "PDV: ID"), correspondente ao parâmetro "identificadorPontoCaptura" do método *ConfigurarDadosPDV* e à chave de mesmo nome do arquivo de configuração da biblioteca.

### Correções
- Comprovante incompleto que era retornado em casos de transação negada.
  - A biblioteca somente retornará os comprovantes das transações caso estas sejam recebidas de seus provedores, tipicamente em caso de transação aprovada.

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.08.00    |
| E1_UPDATER  | 01.02.00    |
| E1_UPLOADER | 01.00.08    |
| Provider 2  | 2.3.0       |
| Provider 3  | C042000-D00 |
| Provider 5  | 4.3.9       |

----------------------------------------------

## 23/09/2024 - v02.22.00

### Melhorias
- Melhorias adicionais na inicialização das vendas no provedor #3.
  - Remoção da dependência "pinpad.dll" / "pinpad.so" e mudanças no tratamento do pinpad, acarretando um melhor tempo no início das operações.

### Correções
- Crash ao migrar do provedor #3 para outro provedor.
  - A biblioteca "pinpad.dll" / "pinpad.so", responsável pelo bug que causava esse crash, foi removida.

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.08.00    |
| E1_UPDATER  | 01.02.00    |
| E1_UPLOADER | 01.00.08    |
| Provider 2  | 2.3.0       |
| Provider 3  | C042000-D00 |
| Provider 5  | 4.3.9       |

----------------------------------------------

## 17/09/2024 - v02.21.02

### Melhorias
- Tempo de inicialização das vendas no provedor #3.
  - A configuração do provedor #3 agora é realizada apenas na inicialização da 1a transação, melhorando o desempenho das próximas operações.

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.07.00    |
| E1_UPDATER  | 01.02.00    |
| E1_UPLOADER | 01.00.08    |
| Provider 2  | 2.3.0       |
| Provider 3  | C041901-D00 |
| Provider 5  | 4.3.9       |

----------------------------------------------

## 06/09/2024 - v02.21.01

### Melhorias

### Correções
- Data da 1a parcela sendo solicitada mais de uma vez no CDC pelo provedor #3.
  - Nessa versão foi corrigida a situação onde a "data da 1a parcela" era solicitada mais de uma vez quando uma venda débito parcelado (CDC) era realizada atráves do provedor #3.

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.07.00    |
| E1_UPDATER  | 01.02.00    |
| E1_UPLOADER | 01.00.08    |
| Provider 2  | 2.3.0       |
| Provider 3  | C041901-D00 |
| Provider 5  | 4.3.9       |

----------------------------------------------

## 04/09/2024 - v02.21.00

### Melhorias
- Implementação da funcionalidade "Relatório".
  - Nessa versão foi implementado o "Relatório", comum a todos os provedores, onde o usuário pode consultar todas as transações realizadas numa determinada data.

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.07.00    |
| E1_UPDATER  | 01.02.00    |
| E1_UPLOADER | 01.00.08    |
| Provider 2  | 2.3.0       |
| Provider 3  | C041901-D00 |
| Provider 5  | 4.3.9       |

----------------------------------------------

## 23/08/2024 - v99.20.01

### Melhorias
- Ajustes na integração com provedor #5:
  - Melhoria no layout dos comprovantes;
  - Remoção da mensagem sobre transações pendentes que aparecia no início das vendas;
  - Texto default para mostrar no pinpad caso nenhum tenha sido informado pelo usuário.

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.07.00    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.07    |
| Provider 2  | 2.3.0       |
| Provider 3  | C041901-D00 |
| Provider 5  | 4.3.9       |

----------------------------------------------

## 20/08/2024 - v99.20.00

### Melhorias
- Integração do provedor #5 e migração do TEF Elgin para o Elgin TEFHUB.
  - Nessa versão o provedor #5 e os recursos presentes no TEF Elgin foram migrados para o Elgin TEFHUB, formando um único pacote padronizado.

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.07.00    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.07    |
| Provider 2  | 2.3.0       |
| Provider 3  | C041901-D00 |
| Provider 5  | 4.3.9       |

----------------------------------------------

## 30/07/2024 - v99.16.01

### Melhorias

### Correções
- Bug que solicitava coleta de dados já informados.
  - Quando um payload com dados pré-informados da transação era enviado para lib do ETH sem pré-informar o tipo de operação (parâmetro "(int)codigoOperacao"), os dados informados no payload eram perdidos após a escolha da operação no menu e tais dados eram solicitados novamente.
  - Esse bug foi corrigido nesta versão e os dados pré-informados no payload não serão perdidos após a escolha da operação desejada nos menus.

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.06.01    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.06    |
| Provider 2  | 2.3.0       |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 26/07/2024 - v99.16.00

### Melhorias
- Envio do modo de integração ao servidor de histórico.
  - Adição da chave 'integrationBy' no payload que a lib do ETH gera com os dados da transação enviada ao servidor de histórico.
- Melhorias no menu de pagamentos.
  - Sempre que o usuário acionar a função RealizarPagamentoTEF sem especificar o código da operação desejada será gerado um menu onde é possível escolher entre "Cartões" ou "Carteiras digitais", conforme a disponibilidade dessas operações no GPC e no motor em uso.
  - A tabela a seguir apresenta os possíveis valores que podem ser enviados no parâmetro "(int)codigoOperacao" da função RealizarPagamentoTEF:

| Valor | Significado |
| :---: | :---------- |
| 1     | Crédito |
| 2     | Débito |
| 3     | Voucher |
| 4     | Frota |
| 5     | Private label |
| 21    | Pix |
| 0     | Menu de cartões [1...5] |
| 20    | Menu de carteiras digitais [21] |
| -1    | Menu de pagamentos [0,20] |
| ...   | Qualquer outro valor equivale a -1 |

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.06.01    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.06    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 22/07/2024 - v99.15.00

### Melhorias
- Operação de ativação via menu administrativo.
  - Agora é possível ativar um terminal através do menu administrativo.
- Geração do comprovante de ativação.
  - Após uma ativação bem-sucedida é gerado um comprovante com os dados do terminal ativado no local de instalação da solução.
- Suporte a ativação com numero de terminal.
  - Durante a ativação do terminal é possível informar, opcionalmente, o identificador de um terminal específico para ativação.
- Informação do host na ativação.
  - A lib do ETH captura o hostname do terminal a ser habilitado e envia no payload de confirmação ao GPC.
- Menu administrativo dinâmico.
  - As opções disponíveis no menu administrativo são apresentadas conforme o status do terminal (habilitado ou desabilitado).
- Padronização do local de load da lib do pinpad.
  - As dependências da lib do ETH são buscadas, por padrão, no diretório de instalação da solução.

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.06.01    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.06    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 18/07/2024 - v99.14.00

### Melhorias
- Habilita logs da para a DLL.
  - Passa a ser criado a variavel de ambiente no momento da instalação para que a dll gere logs automaticamente.
- Melhoria na geração do arquivo de licença.
  - A partir desta versão a dll passa a gerar os arquivos de licença no diretório de instalação do TEFHUB. Isso deve afetar apenas as novas instalações.
- Aumenta o timeout para operações do PIX.
  - Aumenta o tempo limite para geração de QRCode, Desfazimento e Cancelamento para 180 Seg (3 min). Esse valor é parametrizavel via servidor de parametros.

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.06.00    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.06    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 11/07/2024 - v99.13.00

### Melhorias
- Adiciona codigo de identificação elgin no comprovante.
  - Adiciona o ElginREF no comprovante das transações. Este será utilizado para operações diversas idependentemente do motor.
- Melhorias no log.
  - Adiciona ambiente de operação no logs.
- Operação de cancelamento comum.
  - Remove a necessidade de informar o tipo da transação no momento do cancelamento.
- Retrocompatibilidade do PIX
  - Passa a suportar as funções RealizarPixTEF, ConfirmarOperacaoTEF e RealizarAdmTEF (para cancelamento) nas operações de PIX do TEFHUB.

### Correções
- Correção no menu administrativo.
  - Corrige erro ao gerar o menu administrativo em terminais que possuem
  somente PIX ativo.

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.04.01    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.04    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 27/06/2024 - v99.12.01

### Melhorias
- Coleta para vias de impressão.
  - Coleta da informação "vias de reimpressão" na operação "adm reimprimir"

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.04.00    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.04    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 14/06/2024 - v99.12.00

### Melhorias
- Adiciona suporte a operação Pré-datado.
  - Suporta transações do tipo pré-datado na venda débito.

- Adiciona suporte a operação débito parcelado.
  - Suporta transações do tipo débito parcelado.

### Correções
- Correções na confirmação de transação.
  - Corrige falha no fluxo de confirmação de transações realizadas pelo Tef Web.

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.04.00    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.04    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 12/06/2024 - v99.11.01

### Melhorias
- Adiciona identificador do terminal
  - Retorno da chave "identificadorPontoCaptura" nas transações bem-sucedidas da biblioteca.

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.04.00    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.04    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 07/06/2024 - v99.11.00

### Melhorias
- Apresenta QRCode pix no pinpad.
  - Passa a apresentar o QRCode do PIX nos PINPAD padrão ABECS 2.12.

- Melhorias na função de reimpressão.

### Correções
- Correção no comprovante.
  - Correção na formatação dos comprovantes.

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_ETX      | 03.04.00    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.03    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------