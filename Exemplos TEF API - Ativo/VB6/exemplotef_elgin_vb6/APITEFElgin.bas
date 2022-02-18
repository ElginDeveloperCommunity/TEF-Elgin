Attribute VB_Name = "APITEFELgin"
Option Explicit
'CONSTANTES PARA TIPO FLUXO
Public Const TIPO_FLUXO_SOLICITACAO_CAPTURA = 0
Public Const TIPO_FLUXO_PROSSEGUIR_CAPTURA = 1
Public Const TIPO_FLUXO_CANCELAR_CAPTURA = 2
Public Const TIPO_FLUXO_RETORNAR_CAPTURA = 3
Public Const TIPO_FLUXO_SEGUIR_FLUXO = 4

'OPERAÇÕES DE PAGAMENTO
Public Const PAGAMENTO_DEBITO = 1
Public Const PAGAMENTO_CREDITO = 2
Public Const OPERACAO_CANCELAMENTO_ADM = 12
Public Const OPERACAO_REIMPRESSAO = 128
Public Const OPERACAO_CONFIGURACAO = 256
Public Const OPERACAO_CANCELAMENTO = 512

'OPÇÕES PARA CONFIRMAÇÃO DA TRANSAÇÃO OU CANCELAMENTO
Public Const CANCELAR_OPERACAO = 0
Public Const CONFIRMAR_OPERACAO = 1

'OPÇÕES PARA FINALIZAÇÃO DA OPERAÇÃO
Public Const FINALIZAR_TRANSACAO = 0  'AutomaÇÃo comercial continuará executando.
Public Const FINALIZAR_AUTOMACAO = 1 'AutomaÇÃo comercial está sendo encerrada
    

'DECLARAÇÃO DAS FUNÇÕES DA API TEF ELGIN'
Public Declare Function ElginTEF_Autenticador Lib "APITEFElgin.dll" () As Long
Public Declare Function ElginTEF_IniciarOperacaoTEF Lib "APITEFElgin.dll" () As Long

Public Declare Function ElginTEF_RealizarPagamentoTEF Lib "APITEFElgin.dll" (ByVal codigoOperacao As Long, ByVal dadosCaptura As Long, ByRef tamDados As Long) As Long
Public Declare Function ElginTEF_RealizarAdmTEF Lib "APITEFElgin.dll" (ByVal codigoOperacao As Long, ByVal dadosCaptura As Long, ByRef tamDados As Long) As Long
Public Declare Function ElginTEF_RealizarConfiguracao Lib "APITEFElgin.dll" (ByVal dadosCaptura As Long, ByRef tamDados As Long) As Long
Public Declare Function ElginTEF_RealizarCancelametoTEF Lib "APITEFElgin.dll" (ByVal dadosCaptura As Long, ByRef tamDados As Long) As Long

Public Declare Function ElginTEF_ConfirmarOperacaoTEF Lib "APITEFElgin.dll" (ByVal confirmacao As Long) As Long
Public Declare Function ElginTEF_FinalizarOperacaoTEF Lib "APITEFElgin.dll" (ByVal finalizacao As Long) As Long

'FUNÇÕES PARA CÓPIA DE MEMORIA
Public Declare Function lstrlenA Lib "kernel32" (ByVal lpString As Long) As Long
Public Declare Function lstrlenW Lib "kernel32" (ByVal lpString As Long) As Long
Public Declare Function SysAllocStringByteLen Lib "oleaut32.dll" (ByVal m_pBase As Long, ByVal l As Long) As String

'VARIAVEL PARA ARMAZENAR RETORNO DAS FUNÇÕES
Dim result As Long
Dim ansi, aux As String

'FUNÇÃO RESPONSAVEL POR INICIALIZAR A OPERAÇÕES QUE PRECISAM DE AUTENTICAÇÃO E INICIALIZAÇÃO DE TEF
Public Function IniciaOperacao() As String
MsgBox "vai iniciar operacao!!"
    result = ElginTEF_Autenticador
 
    If result <> 0 Then
        'ERRO NA AUTENTICAÇÃO DA API TEF ELGIN
        IniciaOperacao = "Erro na autenticação: " & result
        Exit Function
    End If
    
    result = ElginTEF_IniciarOperacaoTEF
    
    If result <> 0 Then
        'ERRO NA AUTENTICAÇÃO DA API TEF ELGIN
        IniciaOperacao = "Erro na inicialização da operacao: " & result
        Exit Function
    End If
    
    IniciaOperacao = "SUCESSO"
End Function

'FUNÇÃO QUE REALIZA A CHAMADA DA API PARA AS FUNÇÕES QUE FUNCIONAM EM FLUXO CONTINUADO
Public Function FluxoColeta(param As String, operacao As Integer) As String
    Dim dados As Object
    Dim val() As Byte
        
    val = StrConv(param, vbFromUnicode)
    ReDim Preserve val(UBound(val) + 4096)
    
    Set dados = JSON.parse(param)
    
    If dados.Item("SequenciaCaptura") = "99" Then
        'QUANDO A COLETA É FINALIZADA A SEQUENCIA CAPTURA RETORNA 99 E O FLUXO DEVE SER ENCERRADO
        FluxoColeta = ""
    End If
    
    'PROCESSA OPERACAO DE PAGAMENTO
    If operacao = PAGAMENTO_CREDITO Or operacao = PAGAMENTO_DEBITO Or operacao = 0 Then
        
        result = ElginTEF_RealizarPagamentoTEF(operacao, VarPtr(val(0)), Len(param))
        
        aux = StrPtrToString(VarPtr(val(0)))

        FluxoColeta = aux
        Exit Function
    ElseIf operacao = OPERACAO_CONFIGURACAO Then 'PROCESSA OPERACAO DE CONFIGURAÇÃO DO AMBIENTE
                
        result = ElginTEF_RealizarConfiguracao(VarPtr(val(0)), Len(param))
        
        aux = StrPtrToString(VarPtr(val(0)))

        FluxoColeta = aux
        
        'FluxoColeta = "{ 'SequenciaCaptura': 1, 'TipoFluxo': 0, 'InfoCaptura': null, 'ComponentesTela': [ { 'TipoVisor': 'operador', 'CodigoComponenteTela': 1, 'NomeComponenteTela': 'label', 'ConteudoComponenteTela': 'LISTA DE OPERAÇÕES', 'FormatoDeCaptura': 0 }, { 'CodigoComponenteTela': 2, 'NomeComponenteTela': 'listbox', 'ConteudoComponenteTela': '{\r\n  \'ArrayListBox\': [\r\n    {\r\n      \'IdItem\': 1,\r\n      \'ConteudoItem\': \'Pagamento débito\'\r\n    },\r\n    {\r\n      \'IdItem\': 2,\r\n      \'ConteudoItem\': \'Pagamento crédito\'\r\n    }\r\n  ]\r\n}', 'FormatoDeCaptura': 0 }, { 'TipoFluxo': 1, 'CodigoComponenteTela': 3, 'NomeComponenteTela': 'button', 'ConteudoComponenteTela': 'Prosseguir', 'FormatoDeCaptura': 0 }, { 'TipoFluxo': 2, 'CodigoComponenteTela': 4, 'NomeComponenteTela': 'button', 'ConteudoComponenteTela': 'Cancelar', 'FormatoDeCaptura': 0 } ], 'AbortarFluxoCaptura': false, 'FormatoInfoCaptura': 4 }"
        Exit Function
    ElseIf operacao = OPERACAO_CANCELAMENTO_ADM Or operacao = OPERACAO_REIMPRESSAO Then 'PROCESSA OPERACAO ADMINISTRATIVA
        
        result = ElginTEF_RealizarAdmTEF(operacao, VarPtr(val(0)), Len(param))
        
        aux = StrPtrToString(VarPtr(val(0)))

        FluxoColeta = aux
        Exit Function
        
    ElseIf operacao = OPERACAO_CANCELAMENTO Then
        
        result = ElginTEF_RealizarCancelametoTEF(VarPtr(val(0)), Len(param))
        
        aux = StrPtrToString(VarPtr(val(0)))

        FluxoColeta = aux
        Exit Function
    Else 'OPERACAO INDEFINIDA
        FluxoColeta = "OPERAÇÃO INDEFINIDA"
        Exit Function
    End If

End Function

'FUNÇÃO RESPONSÁVEL POR FINALIZAR A OPERAÇÃO DE TEF, CONFIRMANDO OU NÃO A OPERAÇÃO
Public Function FinalizaOperacao(confirmacao As Long) As String
    
    'VALIDA PARAMENTRO PASSADO A FUNÇÃO PARA REALIZAR A CONFIRMACAO
    If confirmacao <> CONFIRMAR_OPERACAO And confirmacao <> CANCELAR_OPERACAO Then
        FinalizaOperacao = "Paramentro invalido"
        Exit Function
    End If
    
    result = ElginTEF_ConfirmarOperacaoTEF(confirmacao)
    
    If result <> 0 Then
        FinalizaOperacao = "Erro na confirmação: " & result
        Exit Function
    End If
    
    result = ElginTEF_FinalizarOperacaoTEF(FINALIZAR_TRANSACAO)
    
    If result <> 0 Then
        FinalizaOperacao = "Erro na confirmação: " & result
        Exit Function
    End If

    FinalizaOperacao = "SUCESSO"
    Exit Function
End Function

Public Function CriaJSON(valor As String) As String
    Dim dic As Dictionary
    
    Set dic = New Dictionary
    dic.Add "SequenciaCaptura", 0
    dic.Add "TipoFluxo", TIPO_FLUXO_SOLICITACAO_CAPTURA
    dic.Add "InfoCaptura", valor
    dic.Add "ComponentesTelas", Null
    dic.Add "AbortarFluxoCaptura", False
    dic.Add "FormatoInfoCaptura", 0
   
    CriaJSON = JSON.toString(dic)

    Set dic = Nothing
End Function

Public Function ObtemUltimoRetorno() As Long
    ObtemUltimoRetorno = result
End Function


'Função para conversão de ponteiro para String
Public Function StrPtrToString(ByVal ponteiro As Long) As String

    Dim Saida As String

    Saida = SysAllocStringByteLen(ponteiro, lstrlenA(ponteiro))

    StrPtrToString = Saida

End Function
