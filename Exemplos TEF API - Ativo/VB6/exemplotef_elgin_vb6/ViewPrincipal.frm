VERSION 5.00
Begin VB.Form ViewPrincipal 
   Caption         =   "principal"
   ClientHeight    =   10905
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   13290
   LinkTopic       =   "Form1"
   ScaleHeight     =   10905
   ScaleWidth      =   13290
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame3 
      Caption         =   "LOGs"
      Height          =   10455
      Left            =   5040
      TabIndex        =   30
      Top             =   120
      Width           =   8055
      Begin VB.TextBox Text3 
         Height          =   9615
         Left            =   240
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   31
         Top             =   360
         Width           =   7575
      End
   End
   Begin VB.CommandButton Command19 
      Caption         =   "x"
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
      Left            =   3360
      TabIndex        =   29
      Top             =   2760
      Width           =   1335
   End
   Begin VB.CommandButton Command18 
      Caption         =   "0"
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
      Left            =   1920
      TabIndex        =   28
      Top             =   2760
      Width           =   1335
   End
   Begin VB.CommandButton Command17 
      Caption         =   "<<"
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
      Left            =   480
      TabIndex        =   27
      Top             =   2760
      Width           =   1335
   End
   Begin VB.CommandButton Command16 
      Caption         =   "9"
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
      Left            =   3360
      TabIndex        =   26
      Top             =   2160
      Width           =   1335
   End
   Begin VB.CommandButton Command15 
      Caption         =   "8"
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
      Left            =   1920
      TabIndex        =   25
      Top             =   2160
      Width           =   1335
   End
   Begin VB.CommandButton Command14 
      Caption         =   "7"
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
      Left            =   480
      TabIndex        =   24
      Top             =   2160
      Width           =   1335
   End
   Begin VB.CommandButton Command12 
      Caption         =   "6"
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
      Left            =   3360
      TabIndex        =   23
      Top             =   1560
      Width           =   1335
   End
   Begin VB.CommandButton Command11 
      Caption         =   "5"
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
      Left            =   1920
      TabIndex        =   22
      Top             =   1560
      Width           =   1335
   End
   Begin VB.CommandButton Command10 
      Caption         =   "4"
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
      Left            =   480
      TabIndex        =   21
      Top             =   1560
      Width           =   1335
   End
   Begin VB.CommandButton Command9 
      Caption         =   "3"
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
      Left            =   3360
      TabIndex        =   20
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton Command8 
      Caption         =   "2"
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
      Left            =   1920
      TabIndex        =   19
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton Command3 
      Caption         =   "1"
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
      Left            =   480
      TabIndex        =   18
      Top             =   960
      Width           =   1335
   End
   Begin VB.Frame Frame1 
      Caption         =   "Operações"
      Height          =   3375
      Left            =   240
      TabIndex        =   10
      Top             =   3600
      Width           =   4695
      Begin VB.CommandButton Command7 
         Caption         =   "Configuração"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   2400
         TabIndex        =   17
         Top             =   2400
         Width           =   2175
      End
      Begin VB.CommandButton Command6 
         Caption         =   "Reimpressão"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   2400
         TabIndex        =   16
         Top             =   1680
         Width           =   2175
      End
      Begin VB.CommandButton Command5 
         Caption         =   "Cancelamento"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   120
         TabIndex        =   15
         Top             =   1680
         Width           =   2175
      End
      Begin VB.CommandButton Command4 
         Caption         =   "Cancelamento ADM"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   120
         TabIndex        =   14
         Top             =   2400
         Width           =   2175
      End
      Begin VB.CommandButton Command1 
         Caption         =   "CRÉDITO"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   2400
         TabIndex        =   13
         Top             =   960
         Width           =   2175
      End
      Begin VB.CommandButton Command13 
         Caption         =   "DÉBITO"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   120
         TabIndex        =   12
         Top             =   960
         Width           =   2175
      End
      Begin VB.CommandButton Command2 
         Caption         =   "Iniciar Pagamento"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   120
         TabIndex        =   11
         Top             =   240
         Width           =   4455
      End
   End
   Begin VB.TextBox Text1 
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
      Left            =   1200
      TabIndex        =   8
      Top             =   240
      Width           =   3615
   End
   Begin VB.Frame Frame2 
      Caption         =   "Processamento"
      Height          =   3375
      Left            =   240
      TabIndex        =   0
      Top             =   7200
      Width           =   4695
      Begin VB.ListBox List1 
         Height          =   1035
         Left            =   120
         TabIndex        =   5
         Top             =   1320
         Visible         =   0   'False
         Width           =   4335
      End
      Begin VB.CommandButton btnOK 
         Caption         =   "Ok"
         Height          =   435
         Left            =   120
         TabIndex        =   4
         Top             =   2760
         Visible         =   0   'False
         Width           =   1395
      End
      Begin VB.CommandButton btnCancelar 
         Caption         =   "Cancelar"
         Height          =   435
         Left            =   1560
         TabIndex        =   3
         Top             =   2760
         Visible         =   0   'False
         Width           =   1395
      End
      Begin VB.TextBox Text2 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   420
         Left            =   120
         TabIndex        =   2
         Text            =   "Text2"
         Top             =   960
         Visible         =   0   'False
         Width           =   4335
      End
      Begin VB.CommandButton btnVoltar 
         Caption         =   "Voltar"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   435
         Left            =   3000
         TabIndex        =   1
         Top             =   2760
         Visible         =   0   'False
         Width           =   1395
      End
      Begin VB.Label labelProc1 
         Caption         =   "Processamento"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   7
         Top             =   240
         Visible         =   0   'False
         Width           =   4335
      End
      Begin VB.Label labelProc2 
         Caption         =   "Label2"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   6
         Top             =   600
         Visible         =   0   'False
         Width           =   4335
      End
   End
   Begin VB.Label Label1 
      Caption         =   "R$"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   360
      TabIndex        =   9
      Top             =   240
      Width           =   615
   End
End
Attribute VB_Name = "ViewPrincipal"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim operacao As Integer
Dim resultJson As Object
Dim ret As String
Dim seguirFluxo, iniciarOperacao As Boolean

'TRATA EVENTO DO BOTÃO OK QUANDO CLICADO
Private Sub btnOK_Click()
'ESPERA-SE QUE NESSE PONTO O OBJ JSON(GLOBAL) JA TENHA SOFRIDO O PARSE
If (Text2.Visible) = True Then
    If Text2.Text = "" Then
        MsgBox "Preencha o campo", vbOKOnly, vbCritical
    Else
        'Alterar tipo fluxo e info captura
        resultJson.Remove ("TipoFluxo")
        resultJson.Remove ("InfoCaptura")
        resultJson.Add "TipoFluxo", TIPO_FLUXO_PROSSEGUIR_CAPTURA
        resultJson.Add "InfoCaptura", Text2.Text
        TEFElginLOOP
        
    End If
ElseIf (List1.Visible) = True Then
    If List1.ListIndex = -1 Then
        MsgBox "Selecione um item da lista!", vbOKOnly, vbCritical
    Else
        resultJson.Remove ("TipoFluxo")
        resultJson.Remove ("InfoCaptura")
        resultJson.Add "TipoFluxo", TIPO_FLUXO_PROSSEGUIR_CAPTURA
        resultJson.Add "InfoCaptura", List1.ListIndex + 1
        TEFElginLOOP
        
    End If
Else
    resultJson.Item("TipoFluxo") = TIPO_FLUXO_PROSSEGUIR_CAPTURA
    TEFElginLOOP
End If
End Sub

Private Sub btnVoltar_Click()
    'RETOMAR CAPTURA ANTERIOR
    resultJson.Remove ("TipoFluxo")
    resultJson.Add "TipoFluxo", TIPO_FLUXO_RETORNAR_CAPTURA
    TEFElginLOOP
    
End Sub

Private Sub btnCancelar_Click()
    'CANCELAR OPERAÇÃO
    resultJson.Remove ("TipoFluxo")
    resultJson.Add "TipoFluxo", TIPO_FLUXO_CANCELAR_CAPTURA
    TEFElginLOOP
    
End Sub

Private Sub Command1_Click()
    Set resultJson = JSON.parse(CriaJSON(Text1.Text))
    operacao = PAGAMENTO_CREDITO
    iniciarOperacao = True
    TEFElginLOOP
End Sub

Private Sub Command13_Click()
    Set resultJson = JSON.parse(CriaJSON(Text1.Text))
    operacao = PAGAMENTO_DEBITO
    iniciarOperacao = True
    TEFElginLOOP
    
End Sub

Private Sub Command2_Click()
    Set resultJson = JSON.parse(CriaJSON(Text1.Text))
    iniciarOperacao = True
    operacao = 0
    TEFElginLOOP
End Sub

Private Sub Command4_Click()
    If Text1.Text = "" Then
        MsgBox "Digite o valor da transação!"
        Text1.SetFocus
        Exit Sub
    End If

    Set resultJson = JSON.parse(CriaJSON(Text1.Text))
    iniciarOperacao = True
    operacao = OPERACAO_CANCELAMENTO_ADM
    TEFElginLOOP
End Sub

Private Sub Command5_Click()
    Dim valTrans, valTaxa, auxVal As String
    
    valTrans = InputBox("Digite o valor da transacao!", "Valor da Transação")
    valTaxa = InputBox("Digite o valor da taxa!", "Valor de taxa!")
    
    '==========================
    'exemplo do valor passado para o json
    'ValorCancelamento:50000,TaxaCancelamento:000
    '==========================
    
    auxVal = "ValorCancelamento:" & valTrans & ",TaxaCancelamento:" & valTaxa
    Set resultJson = JSON.parse(CriaJSON(auxVal))
    iniciarOperacao = True
    operacao = OPERACAO_CANCELAMENTO
    TEFElginLOOP
End Sub

Private Sub Command6_Click()
    Set resultJson = JSON.parse(CriaJSON(Text1.Text))
    iniciarOperacao = True
    operacao = OPERACAO_REIMPRESSAO
    TEFElginLOOP
End Sub

Private Sub Command7_Click()
    Set resultJson = JSON.parse(CriaJSON(Text1.Text))
    operacao = OPERACAO_CONFIGURACAO
    TEFElginLOOP
    
End Sub

Public Function TEFElginLOOP()

'PARA INICIAR A OPERACAO
    If iniciarOperacao = True And operacao <> OPERACAO_CONFIGURACAO Then
       ret = IniciaOperacao()
        If ret <> "SUCESSO" Then
            MsgBox ret
            Exit Function
        End If
        iniciarOperacao = False
    End If

'PARA REALIZAR LOOP DE COLETA DE DADOS
    Do
        Text3.Text = Text3.Text & vbCrLf & "JSON ENVIADO PARA API--------------" & vbCrLf
        Text3.Text = Text3.Text & JSON.toString(resultJson) & vbCrLf & vbCrLf
        Text3.SelStart = Len(Text3.Text)
        
        ret = FluxoColeta(JSON.toString(resultJson), operacao)
        TEFElginProcessaRetorno (ret)
    Loop While resultJson.Item("SequenciaCaptura") <> "99" And seguirFluxo = True
     
'PARA FINALIZAR
    If resultJson.Item("SequenciaCaptura") = "99" And operacao <> OPERACAO_CONFIGURACAO Then
        ret = FinalizaOperacao(CONFIRMAR_OPERACAO)
    
        If ret <> "SUCESSO" Then
            MsgBox ret
            Exit Function
        End If
        
        MsgBox "Operação realizada com sucesso!"
        Exit Function
    End If
     
End Function
'FUNÇÃO RESPONSAVEL POR ATUALIZAR A TELA COM OS COMPONENTES RETORNADOS DA API
Public Function TEFElginProcessaRetorno(val As String)
Dim objAux, auxList As Object
Dim componente, tipoVisor, comprovante As String
Dim i, t, h As Integer

On Error GoTo trataErro
Set resultJson = JSON.parse(val)


Text3.Text = Text3.Text & vbCrLf & "JSON RECEBIDO DA API--------------" & vbCrLf
Text3.Text = Text3.Text & val & vbCrLf & vbCrLf
Text3.SelStart = Len(Text3.Text)

'DESABILITA OS COMPONENTES DE TELA
Text2.Visible = False
labelProc1.Visible = False
labelProc2.Visible = False
List1.Visible = False
btnOK.Visible = False
btnCancelar.Visible = False
btnVoltar.Visible = False

seguirFluxo = False

'PROCESSA OS COMPONENTES DA TELA
For i = 0 To (resultJson.Item("ComponentesTela").Count - 1)
    
    Set objAux = resultJson.Item("ComponentesTela").Item(i + 1)
    componente = resultJson.Item("ComponentesTela").Item(i + 1).Item("NomeComponenteTela")
    
    tipoVisor = resultJson.Item("ComponentesTela").Item(i + 1).Item("TipoVisor")
    tipoVisor = StrConv(tipoVisor, vbUpperCase)
    
    Select Case StrConv(componente, vbUpperCase)
        Case "LABEL"
            If tipoVisor = "OPERADOR" Then
               If objAux.Item("CodigoComponenteTela") < 2 Then
                   labelProc1.Caption = objAux.Item("ConteudoComponenteTela")
                   labelProc1.Visible = True
               Else
                   labelProc2.Caption = objAux.Item("ConteudoComponenteTela")
                   labelProc2.Visible = True
               End If
            End If
        Case "BUTTON"
            If objAux.Item("TipoFluxo") = 1 Then
                btnOK.Caption = objAux.Item("ConteudoComponenteTela")
                btnOK.Visible = True
                
            ElseIf objAux.Item("TipoFluxo") = 2 Then
                btnCancelar.Caption = objAux.Item("ConteudoComponenteTela")
                btnCancelar.Visible = True
            Else
                btnVoltar.Caption = objAux.Item("ConteudoComponenteTela")
                btnVoltar.Visible = True
            End If
                 
        Case "TEXTBOX"
            Text2.Text = objAux.Item("ConteudoComponenteTela")
            Text2.Visible = True
            Text2.SetFocus
                 
        Case "LISTBOX"
            'remove todos os itens da list
            List1.Clear
            
            Set auxList = JSON.parse(objAux.Item("ConteudoComponenteTela"))
            
            For h = 0 To (auxList.Item("ArrayListBox").Count - 1)
                List1.AddItem (auxList.Item("ArrayListBox").Item(h + 1).Item("ConteudoItem"))
            Next
            List1.Visible = True
            List1.SetFocus
                 
        Case "COMPROVANTELOJA"
            'APRESENTA O COMPROVANTE DA LOJA NA TELA
            comprovante = Replace(objAux.Item("ConteudoComponenteTela"), "\n", vbCrLf)

            frmComprovante.Text1.Text = comprovante
            frmComprovante.Caption = "Comprovante loja"
            frmComprovante.Show vbModal

                
        Case "COMPROVANTECLIENTE"
            'APRESENTA O COMPROVANTE DO CLIENTE NA TELA
            comprovante = Replace(objAux.Item("ConteudoComponenteTela"), "\n", vbCrLf)

            frmComprovante.Text1.Text = comprovante
            frmComprovante.Caption = "Comprovante cliente"
            frmComprovante.Show vbModal
                 
        Case "DADOSTRANSACAO"
            'APRESENTA OS DADOS DA TRANSAÇÃO EM UMA TABELA
            Dim arrayDados() As String
            
            'popula o array com os dados retornados da transação
            arrayDados = Split(objAux.Item("ConteudoComponenteTela"), ",")
            
            'configura o nome para as colunas da tabela de apresentação
            frmDadosTransacao.MSFlexGrid1.TextMatrix(0, 0) = "Chave"
            frmDadosTransacao.MSFlexGrid1.TextMatrix(0, 1) = "Valor"
            
            'configura o tamanho das colunas
            frmDadosTransacao.MSFlexGrid1.ColWidth(0) = 2150
            frmDadosTransacao.MSFlexGrid1.ColWidth(1) = 2150
            
            For t = 0 To UBound(arrayDados)
                frmDadosTransacao.MSFlexGrid1.rows = frmDadosTransacao.MSFlexGrid1.rows + 1
                frmDadosTransacao.MSFlexGrid1.TextMatrix(t + 1, 0) = Split(arrayDados(t), ":")(0)
                frmDadosTransacao.MSFlexGrid1.TextMatrix(t + 1, 1) = Split(arrayDados(t), ":")(1)
            Next
            
            frmDadosTransacao.Caption = "Dados da transação"
            frmDadosTransacao.Show vbModal
            
        Case "SEGUIRFLUXO"
            seguirFluxo = True
            
    End Select

Next
ViewPrincipal.Refresh 'ATUALIZA A TELA
resultJson.Item("ComponentesTela") = Null

Exit Function

trataErro:
MsgBox Err.Description
MsgBox Err.HelpContext
MsgBox Err.HelpFile
MsgBox Err.Number
End Function

'FUNÇÕES PARA PREENCHER NO TEXT1 O VALOR CLICADO EM TELA
Private Sub Command3_Click()
    Text1.Text = Text1.Text & "1"
End Sub

Private Sub Command8_Click()
    Text1.Text = Text1.Text & "2"
End Sub

Private Sub Command9_Click()
    Text1.Text = Text1.Text & "3"
End Sub

Private Sub Command10_Click()
    Text1.Text = Text1.Text & "4"
End Sub

Private Sub Command11_Click()
    Text1.Text = Text1.Text & "5"
End Sub

Private Sub Command12_Click()
    Text1.Text = Text1.Text & "6"
End Sub

Private Sub Command14_Click()
    Text1.Text = Text1.Text & "7"
End Sub

Private Sub Command15_Click()
    Text1.Text = Text1.Text & "8"
End Sub

Private Sub Command16_Click()
    Text1.Text = Text1.Text & "9"
End Sub

Private Sub Command18_Click()
    Text1.Text = Text1.Text & "0"
End Sub


Private Sub Command19_Click()
    Text1.Text = ""
End Sub
