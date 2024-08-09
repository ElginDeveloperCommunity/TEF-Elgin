<!-- 
Este arquivo contem as notas de liberação para o software Elgin TEFHUB :: GP
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
| E1_ETX      | 03.06.00    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.06    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

///FIM
-->
# Release Notes - GP TEFHUB
----------------------------------------------
<!-- Adiciona novas entradas abaixo deste comentário -->
## 05/08/2024 - v99.17.02

### Melhorias
- Melhorias no instalador.
  - Nessa versão o instalador passa a verificar se a quantidade de memória RAM disponível no sistema atende os requisitos.

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_TEF      | 99.16.01    |
| E1_ETX      | 03.06.01    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.06    |
| Provider 2  | 2.3.0       |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 30/07/2024 - v99.17.01

### Melhorias
- Atualização da lib do ETH para versão 99.16.01.
  - Nessa versão da lib o bug que solicitava coleta de dados já informados foi corrigido.

### Correções
- Bug que não exibia o QRCode do PIX na tela do GP.
  - Nessa versão foi corrigido o bug que não exibia o QRCode do PIX na tela do GP quando o PIX era acionado via menu de pagamentos.

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_TEF      | 99.16.01    |
| E1_ETX      | 03.06.01    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.06    |
| Provider 2  | 2.3.0       |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 27/07/2024 - v99.17.00

### Melhorias
- Atualização do instalador GP
  - Atualiza instalador do Provider2 para versão 2.3.0
  - Altera diretório de instalação do Provider 2 para {app}/Provider2
  - Remove arquivos desnecessários.

### Correções
- Correção no fluxo de instalação.
  - Corrige problema gerados no momento da instalação do componente GP3. Erros 11, 31 e 32.

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_TEF      | 99.16.00    |
| E1_ETX      | 03.06.01    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.06    |
| Provider 2  | 2.3.0       |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 26/07/2024 - v99.16.00

### Melhorias
- Atualização da lib do ETH para versão 99.16.00, com melhorias na geração do menu de pagamentos.
  - Para acessar o menu de pagamentos "completo" - que inclui as opções de "Cartões" e "Carteiras digitais" -, basta *não enviar* no arquivo IntPos.001 as chaves 011-000 / 731-000.

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_TEF      | 99.16.00    |
| E1_ETX      | 03.06.01    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.06    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 22/07/2024 - v99.15.00

### Melhorias
- Atualização de dependências do GP
  - Libs E1_TEF e E1_ETX atualizadas

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_TEF      | 99.15.00    |
| E1_ETX      | 03.06.01    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.06    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 18/07/2024 - v99.14.00

### Melhorias
- Novos códigos de bandeiras.
  - Adiciona novos códigos de bandeira no retorno da TAG 010-003
- Padronização código da adquirente.
  - Padradroniza o código de adquirente para compor o o valor da TAG 010-001 para os novos provedores.

### Correções
- Remove arquivos desnecessários.
  - Remove arquivos de homologação da instação em modo produção.

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_TEF      | 99.14.00    |
| E1_ETX      | 03.06.00    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.06    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 11/07/2024 - v99.13.00

### Melhorias
- Adiciona identificação do EC ativo.
  - Adiciona no titulo da janela o a razão social e CNPJ ativo.

- Melhoria na tela do PIX.
  - Na tela do QR Code do Pix, informa ao operador que é necessário aguardar a confirmação do pagamento.

### Correções
- Correção no Fluxo de cancelamento.
  - Remove "Tela extra" no fluxo de cancelamento das transações.

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_TEF      | 99.13.00    |
| E1_ETX      | 03.04.01    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.05    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 27/06/2024 - v99.12.01

### Melhorias

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_TEF      | 99.12.01    |
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

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_TEF      | 99.12.00    |
| E1_ETX      | 03.04.00    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.04    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 12/06/2024 - v99.11.01

### Melhorias

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_TEF      | 99.11.01    |
| E1_ETX      | 03.04.00    |
| E1_UPDATER  | 01.00.04    |
| E1_UPLOADER | 01.00.04    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------

## 07/06/2024 - v99.11.00

### Melhorias
- Logotipo TEFHUB.
  - Novo logotipo do TEHHUB da tela principal.

### Correções

### Componentes

| Componente  | Versão      |
|-------------|-------------|
| E1_TEF      | 99.11.00    |
| E1_ETX      | 03.04.00    |
| E1_UPDATER  | 01.00.03    |
| E1_UPLOADER | 01.00.03    |
| Provider 2  | 1.4.11      |
| Provider 3  | C041901-D00 |

----------------------------------------------