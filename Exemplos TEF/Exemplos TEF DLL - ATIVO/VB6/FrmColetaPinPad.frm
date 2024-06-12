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
      Caption         =   "Confirma��o Direta"
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
         Caption         =   "Confirma��o Indireta"
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
    
    ' As fun��es de coleta dos valores com o pinpad n�o dependem do fluxo de
  ' transa��o da api (descrito na documenta��o), mas precisam que a conex�o
  ' com o pinpad esteja aberta. A conex�o com o pinpad fica aberta entre os
  ' passos 1 e 4 descritos na documenta��o, ou seja, entre o uso das fun��es
  ' IniciarOperacaoTEF e FinalizarOPeracaoTEF.

  ' inicia conex�o do tef
    txtLogs.Text = ""
    writeLogs ("INICIANDO OPERA��O")
    
    ' seleciona o index da lstbox
    lstIndex = lstOpcoes.ListIndex
    If lstIndex = -1 Then
        MsgBox "Selecione o tipo de opera��o!"
        lstOpcoes.SetFocus
        Exit Sub
    End If
    
    ' inicia opera��o tef
    retorno = StrPtrToString(IniciarOperacaoTEF("{}"))
    writeLogs (retorno)
    
    ' adiciona 1 para corresponder aos valores na documenta��o
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
    
    ' logs das op��es escolhidas
    writeLogs (Defines.DIV_LOGS)
    writeLogs ("OP��ES ESCOLHIDAS")
    writeLogs ("tipoColeta: " & CStr(tipoColeta))
    writeLogs ("confirmar: " & confirmarStr)
    DoEvents
    
    ' realiza coleta
    retorno = StrPtrToString(RealizarColetaPinPad(tipoColeta, confirmar))
    
    ' checkar se a opera��o foi bem sucedida ou n�o
    If GetRetorno(retorno) = "1" Then
        ' pega o valor digitado pelo usu�rio no pinpad
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
    
    ' se a vari�vel <confirmar> for true, a confirma��o ser� feita automaticamente
    ' caso o desenvolvedor queira fazer algo com o valor antes da confirma��o,
    ' ele pode usar a fun��o ConfirmarCapturaPinPad como exemplificado a seguir:
    If confirmar Then
        Finalizar ("FIM DA OPERA��O")
        Exit Sub
    End If
    
    writeLogs (Defines.DIV_LOGS)
    writeLogs ("INICIANDO CONFIRMA��O")
    DoEvents
    
    ' faz algo com o valor coletado
    ' nesse exemplo s�o adicionadas as m�scaras dos valores
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
    
    ' checkar se a opera��o foi bem sucedida ou n�o
    If GetRetorno(retorno) = "1" Then
        ' pega o valor digitado pelo usu�rio no pinpad
        resultadoCapturaPinPad = GetStringValue(Jsonify(retorno), "tef", "resultadoCapturaPinPad")
        writeLogs ("RESULTADO CONFIRMA��O: " & resultadoCapturaPinPad)
        ' logs do retorno da dll
        writeLogs ("RETORNO DLL: ConfirmarCapturaPinPad")
        writeLogs (retorno)
        DoEvents
    Else
        Finalizar (GetStringValue(Jsonify(retorno), "tef", "mensagemResultado"))
        Exit Sub
    End If
    
    ' finalizar opera��o
    Finalizar ("FIM DA OPERA��O")
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

' fun��es utilit�rias
Private Sub Finalizar(ByVal razao As String)
    Dim retorno As String
    writeLogs (Defines.DIV_LOGS)
    writeLogs ("FINALIZANDO OPERA��O - REASON: " & razao)
    
    ' finalizando opera��o
    retorno = StrPtrToString(FinalizarOperacaoTEF(1))
    If GetRetorno(retorno) = 1 Then
        writeLogs (Defines.DIV_LOGS)
        writeLogs ("FINALIZADA OPERA��O COM SUCESSO!")
    Else
        writeLogs (Defines.DIV_LOGS)
        writeLogs ("FINALIZADA OPERA��O COM ERRO!")
        writeLogs (retorno)
    End If
    DoEvents
End Sub

Private Sub writeLogs(ByVal msg As String)
    txtLogs.Text = txtLogs.Text & vbCrLf & msg & vbCrLf
End Sub
