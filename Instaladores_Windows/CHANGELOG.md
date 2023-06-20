# 1.18.00

## Melhorias
* Integração com E1_Connect para processamento de transações TEF em aplicações WEB
* Adionada Opção no insatalador para instalação do E1_Connect

# 1.17.00

## Melhorias
* Implementação da TAG 737-000 para produto destaxa. Tag ref a vias a imprimir
* Implementação da TAG 010-001 com código da rede que processou a transação
* Implementação da TAG 010-003 com código da bandeira que processou a transação
* Cria a TAG 009-000 quando a destaxa não retorna. A criação valida valores de retorno e mensagem para tentar definir um valor de sucesso, caso contrario será inserido um valor -9999 (ERRO_DESCONHECIDO)
* Não sobrescreve o arquivo de configuração config-tef.json na instalação
* Atualiza as propriedades faltantes no arquivo de configuração config-tef.json
* Possibilidade de desabilitar a instalação de atualização do GP via config-tef.json com a propriedade bloquear_atualizacao = false/true
* Possibilidade de ajustar o tamanho da tela via arquivo config-tef.json.
* Log passa a ser automático com tamanho max de 100MB. Ao atingir esse limite será criado um arquivo de backup e um novo arquivo de log.

## Correções
* Corrige problema ao abrir janela do GP no topo da pilha de janelas e não permite que a janela seja sobreposta.
* Atualiza lib tef com correção para tratamento de transação pendente

# 1.16.00

## Melhorias
* Implementação da TAG 011

* Implementação da tela SOBRE com informações
    * Versão da aplicação
    * Versão do S.O
    * HostName
    * MAC 
    * IP

* Apresentação da mensagem para novas versões disponíveis para atualização

* Configuração para iniciar automaticamente a instalação
    * Arquivo config_tef.json
    * Propriedade: iniciar_atualizacao_aut (0 = desabilitado [default] / 1 = habilitado)
* Instalador gerado com versão dinamica do GP


# 01.15.01

## Melhorias
* Implementação da TAG 011 para protocolo DESTAXA

## Correções
* Ajuste na consulta de transação pendente para que a mesma seja executada em intervalos de 15 transações

		
# 01.15.00
## Melhorias
* Implementar E1_Updater para atualização de GP
* adicionada classe para carga de E1_Updater
* adicionada classe de VO para retornos de E1_Updater
* adicionada estrutura de controller para E1_Updater
* adicionadas funcionalidades para controller de E1_Updater
* adicionados componentes graficos para ações de E1_Updater
* adicionada logica para acionamento de atualização
* adicionados componentes gráficos e mensagens personalizadas para atualização
* adicionado tratamento para execução de Thread principal para o processo de atualização
* adicionada biblioteca de atualização E1_Updater
* adicionado tratamento para realizar cópia de E1_Updater para o path de instalação no pipeline


# 01.14.00

## Melhorias
* Inclusão das ASPAS no inicio e fim de cada linha do comprovante.
* Implementação da configuração por arquivo para a tag 028-001 e as aspas no comprovante

# 01.13.00

## Melhorias
* Refatoracao E1_Tef; mapeamento/traducao tag automacao_coleta_transacao_resposta
* Refatoracao da controller e 'mascaramento' da digitacao de usuario e senha nas operacoes adm
* Remocao mascara de digitacao do usuario
* Refatoracao GP; finalizando Doc
* Documentacao finalizada
* Mapeamento tag 025-000
* Criação do instalador do TEFPassivo

## Correções
* Melhoria no TEF para corrigir bug de 'venda sequencial'

# 01.11.00

## Correções
* Correção do erro na confirmação gerado pelo envio de sequencial invalido
* Correção do erro na confirmação gerado pelo envio de sequencial invalido + Refatoração do fonte(parcial)
* Refatoração do codigo fonte para os processos tradução do arquivo de saída e para configuração da janela no front
* Refatoração dos logs e implementação da função de limpar porta TCP antes da escrita de dados, Evitando assim que na leitura seja coletado algum lixo.
* Melhorias no uso do PIX4

# 01.12.00

## Melhorias
* Implementação da coleta de dados via GP usando as TAGs:
    000-000 = CLT
	376-000 = 0 // Para indicar tipo da coleta a ser realizada(1=RG, 2=CPF, 3=CNPJ e 4=FONE)
    arquivo de saída
	376-001 = "dado coletado no pinpad"

* Implementação da tag 729 com valor indicativo de confirmação da transação
		
# 01.10.00

## Melhorias
* Adicionando mais possibilidades de troca de cores no WhiteLabel
* Ajuste no evento do botão fechar para impedir que a aplicação seja fechada quando uma transação está em processamento
		
# 01.09.00		 

## Melhorias
* Integração PIX
* Integração com PÌX4 na operação de PIX via destaxa
* WhiteLabel no TEFPassivo

# 01.08.01

# Melhorias
* Alteração do modelo de tratamento da TAG 001-000, foi retirado a validação para considerar um campo como int e o mesmo valor enviado será devolvido
		 
# 01.08.00		 

## Melhorias
* Melhorias no layout de tela para suportar apresentação de comprovantes e atualização da identidade visual
* Suporte a mascara de data com 4 digitos para ano
* Implementação para suporte a operação de relatório(Administração Extrato Transação)

## Correções
* Correção para validação de input de dados na operação de coleta

# 01.06.00 

## Melhorias
* Implementação TAG MARCA de recorte para o comprovante completo
* Implementação da propriedade tipo do retorno do comprovante para o arquivo de saída intpos.001

# 01.04.06 

## Melhorias
* Traducao das novas tags retornadas pelo E1_Tef
