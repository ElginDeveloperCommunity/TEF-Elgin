# 1.18.00

## Melhorias
-> Integração com E1_Connect para processamento de transações TEF em aplicações WEB

# 1.17.00

## Melhorias
-> Implementação da TAG 737-000 para produto destaxa. Tag ref a vias a imprimir
-> Implementação da TAG 010-001 com código da rede que processou a transação
-> Implementação da TAG 010-003 com código da bandeira que processou a transação
-> Cria a TAG 009-000 quando a destaxa não retorna. A criação valida valores de retorno e mensagem para tentar definir um valor de sucesso, caso contrario será inserido um valor -9999 (ERRO_DESCONHECIDO)
-> Não sobrescreve o arquivo de configuração config-tef.json na instalação
-> Atualiza as propriedades faltantes no arquivo de configuração config-tef.json
-> Possibilidade de desabilitar a instalação de atualização do GP via config-tef.json com a propriedade bloquear_atualizacao = false/true
-> Possibilidade de ajustar o tamanho da tela via arquivo config-tef.json.
-> Log passa a ser automático com tamanho max de 100MB. Ao atingir esse limite será criado um arquivo de backup e um novo arquivo de log.

## Correções
-> Corrige problema ao abrir janela do GP no topo da pilha de janelas e não permite que a janela seja sobreposta.
-> Atualiza lib tef com correção para tratamento de transação pendente

# 1.16.00

## Melhorias
-> Implementação da TAG 011

-> Implementação da tela SOBRE com informações
---> Versão da aplicação
---> Versão do S.O
---> HostName
---> MAC 
---> IP

-> Apresentação da mensagem para novas versões disponíveis para atualização

-> Configuração para iniciar automaticamente a instalação
---> Arquivo config_tef.json
---> Propriedade: iniciar_atualizacao_aut (0 = desabilitado [default] / 1 = habilitado)
-> Instalador gerado com versão dinamica do GP
