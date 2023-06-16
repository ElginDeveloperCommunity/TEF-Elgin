VERSION 5.00
Begin VB.Form FrmColetaPinPad 
   Caption         =   "Coleta"
   ClientHeight    =   7845
   ClientLeft      =   60
   ClientTop       =   405
   ClientWidth     =   12780
   LinkTopic       =   "Form1"
   ScaleHeight     =   7845
   ScaleWidth      =   12780
   StartUpPosition =   3  'Windows Default
   Begin VB.OptionButton rbDireta 
      Caption         =   "Confirmação Direta"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   720
      TabIndex        =   6
      Top             =   4080
      Width           =   3255
   End
   Begin VB.Frame frameLogs 
      Caption         =   "Logs"
      Height          =   7335
      Left            =   5760
      TabIndex        =   1
      Top             =   240
      Width           =   6735
      Begin VB.TextBox txtLogs 
         Height          =   6735
         Left            =   240
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   2
         Top             =   360
         Width           =   6255
      End
   End
   Begin VB.Frame frameColeta 
      Caption         =   "Coleta"
      Height          =   7335
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   5175
      Begin VB.CommandButton btnColeta 
         Caption         =   "Realizar Coleta PinPad"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   855
         Left            =   480
         TabIndex        =   7
         Top             =   4920
         Width           =   4215
      End
      Begin VB.OptionButton rbIndireta 
         Caption         =   "Confirmação Indireta"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   480
         TabIndex        =   5
         Top             =   3240
         Value           =   -1  'True
         Width           =   3255
      End
      Begin VB.ListBox lstOpcoes 
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1980
         Left            =   2160
         TabIndex        =   4
         Top             =   600
         Width           =   2655
      End
      Begin VB.Label lblTipo 
         Caption         =   "Tipo Coleta"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Left            =   360
         TabIndex        =   3
         Top             =   600
         Width           =   1575
      End
   End
End
Attribute VB_Name = "FrmColetaPinPad"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub btnColeta_Click()
    Dim tipoColeta As Integer
    Dim confirmar As Boolean
    Dim confirmarStr As String
    Dim lstIndex As Integer
    Dim retorno As String
    Dim resultadoCapturaPinPad As String
    
    ' As funções de coleta dos valores com o pinpad não dependem do fluxo de
  ' transação da api (descrito na documentação), mas precisam que a conexão
  ' com o pinpad esteja aberta. A conexão com o pinpad fica aberta entre os
  ' passos 1 e 4 descritos na documentação, ou seja, entre o uso das funções
  ' IniciarOperacaoTEF e FinalizarOPeracaoTEF.

  ' inicia conexão do tef
    txtLogs.Text = ""
    writeLogs ("INICIANDO OPERAÇÃO")
    
    ' seleciona o index da lstbox
    lstIndex = lstOpcoes.ListIndex
    If lstIndex = -1 Then
        MsgBox "Selecione o tipo de operação!"
        lstOpcoes.SetFocus
        Exit Sub
    End If
    
    ' inicia operação tef
    retorno = StrPtrToString(IniciarOperacaoTEF("{}"))
    writeLogs (retorno)
    
    ' adiciona 1 para corresponder aos valores na documentação
    ' 1 - RG
    ' 2 - CPF
    ' 3 - CNPJ
    ' 4 - Telefone
    tipoColeta = lstIndex + 1
    confirmar = rbDireta.Value
    
    ' apenas para mostrar nos logs qual option button foi selecionado
    If confirmar Then
        confirmarStr = "True"
    Else
        confirmarStr = "False"
    End If
    
    ' logs das opções escolhidas
    writeLogs (Defines.DIV_LOGS)
    writeLogs ("OPÇÕES ESCOLHIDAS")
    writeLogs ("tipoColeta: " & CStr(tipoColeta))
    writeLogs ("confirmar: " & confirmarStr)
    DoEvents
    
    ' realiza coleta
    retorno = StrPtrToString(RealizarColetaPinPad(tipoColeta, confirmar))
    
    ' checkar se a operação foi bem sucedida ou não
    If GetRetorno(retorno) = "1" Then
        ' pega o valor digitado pelo usuário no pinpad
        resultadoCapturaPinPad = GetStringValue(Jsonify(retorno), "tef", "resultadoCapturaPinPad")
        writeLogs ("RESULTADO CAPTURA: " & resultadoCapturaPinPad)
        DoEvents
    Else
        Finalizar (GetStringValue(Jsonify(retorno), "tef", "mensagemResultado"))
        Exit Sub
    End If
    
    ' logs do retorno da dll
    writeLogs (Defines.DIV_LOGS)
    writeLogs ("RETORNO DLL: RealizarColetaPinPad")
    writeLogs (retorno)
    DoEvents
    
    ' se a variável <confirmar> for true, a confirmação será feita automaticamente
    ' caso o desenvolvedor queira fazer algo com o valor antes da confirmação,
    ' ele pode usar a função ConfirmarCapturaPinPad como exemplificado a seguir:
    If confirmar Then
        Finalizar ("FIM DA OPERAÇÃO")
        Exit Sub
    End If
    
    writeLogs (Defines.DIV_LOGS)
    writeLogs ("INICIANDO CONFIRMAÇÃO")
    DoEvents
    
    ' faz algo com o valor coletado
    ' nesse exemplo são adicionadas as máscaras dos valores
    Select Case tipoColeta
        Case 1
            resultadoCapturaPinPad = FormatRG(resultadoCapturaPinPad)
        Case 2
            resultadoCapturaPinPad = FormatCPF(resultadoCapturaPinPad)
        Case 3
            resultadoCapturaPinPad = FormatCNPJ(resultadoCapturaPinPad)
        Case 4
            resultadoCapturaPinPad = FormatPhone(resultadoCapturaPinPad)
    End Select

    
    retorno = StrPtrToString(ConfirmarCapturaPinPad(tipoColeta, resultadoCapturaPinPad))
    
    ' checkar se a operação foi bem sucedida ou não
    If GetRetorno(retorno) = "1" Then
        ' pega o valor digitado pelo usuário no pinpad
        resultadoCapturaPinPad = GetStringValue(Jsonify(retorno), "tef", "resultadoCapturaPinPad")
        writeLogs ("RESULTADO CONFIRMAÇÃO: " & resultadoCapturaPinPad)
        ' logs do retorno da dll
        writeLogs ("RETORNO DLL: ConfirmarCapturaPinPad")
        writeLogs (retorno)
        DoEvents
    Else
        Finalizar (GetStringValue(Jsonify(retorno), "tef", "mensagemResultado"))
        Exit Sub
    End If
    
    ' finalizar operação
    Finalizar ("FIM DA OPERAÇÃO")
End Sub

Private Sub Form_Load()
    lstOpcoes.AddItem "RG"
    lstOpcoes.AddItem "CPF"
    lstOpcoes.AddItem "CNPJ"
    lstOpcoes.AddItem "Telefone"
    lstOpcoes.ListIndex = 0
End Sub

Private Sub rbDireta_Click()
    rbIndireta.Value = False
End Sub

Private Sub rbIndireta_Click()
    rbDireta.Value = False
End Sub

' funções utilitárias
Private Sub Finalizar(ByVal razao As String)
    Dim retorno As String
    writeLogs (Defines.DIV_LOGS)
    writeLogs ("FINALIZANDO OPERAÇÃO - REASON: " & razao)
    
    ' finalizando operação
    retorno = StrPtrToString(FinalizarOperacaoTEF(1))
    If GetRetorno(retorno) = 1 Then
        writeLogs (Defines.DIV_LOGS)
        writeLogs ("FINALIZADA OPERAÇÃO COM SUCESSO!")
    Else
        writeLogs (Defines.DIV_LOGS)
        writeLogs ("FINALIZADA OPERAÇÃO COM ERRO!")
        writeLogs (retorno)
    End If
    DoEvents
End Sub

Private Sub writeLogs(ByVal msg As String)
    txtLogs.Text = txtLogs.Text & vbCrLf & msg & vbCrLf
End Sub
