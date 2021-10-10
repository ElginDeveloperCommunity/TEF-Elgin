VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "TEFPay Passivo"
   ClientHeight    =   8925
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8205
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8925
   ScaleWidth      =   8205
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnConexaoImpressora 
      Caption         =   "Conectar Impressora"
      Height          =   1335
      Left            =   5520
      TabIndex        =   15
      Top             =   3480
      Width           =   2295
   End
   Begin VB.CommandButton reImpressaoButton 
      Caption         =   "Impress�o"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   600
      Left            =   480
      MaskColor       =   &H8000000C&
      TabIndex        =   14
      Top             =   3480
      Width           =   2295
   End
   Begin VB.CommandButton ChooseDir 
      Caption         =   "..."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   7320
      MaskColor       =   &H8000000C&
      TabIndex        =   13
      Top             =   840
      Width           =   495
   End
   Begin VB.TextBox DataEntry 
      Height          =   2895
      Left            =   360
      MultiLine       =   -1  'True
      TabIndex        =   12
      Top             =   5640
      Width           =   7455
   End
   Begin VB.CommandButton btnVenda 
      Caption         =   "Venda"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   600
      Left            =   3000
      MaskColor       =   &H8000000C&
      Style           =   1  'Graphical
      TabIndex        =   11
      Top             =   2760
      Width           =   2295
   End
   Begin VB.CommandButton btnCancelamentoVenda 
      Caption         =   "Cancelamento Venda"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   600
      Left            =   5520
      MaskColor       =   &H8000000C&
      TabIndex        =   10
      Top             =   2760
      Width           =   2295
   End
   Begin VB.CommandButton btnNaoConfirmaVenda 
      Caption         =   "N�o Confirmar Venda"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   600
      Left            =   3000
      MaskColor       =   &H8000000C&
      TabIndex        =   9
      Top             =   4200
      Width           =   2295
   End
   Begin VB.CommandButton btnConfirmarVenda 
      Caption         =   "Confirmar Venda"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   600
      Left            =   3000
      MaskColor       =   &H8000000C&
      TabIndex        =   8
      Top             =   3480
      Width           =   2295
   End
   Begin VB.CommandButton btnADM 
      Caption         =   "ADM"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   600
      Left            =   480
      MaskColor       =   &H8000000C&
      TabIndex        =   7
      Top             =   2760
      Width           =   2295
   End
   Begin VB.TextBox ValorVendaText 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   3840
      TabIndex        =   6
      Text            =   "40"
      Top             =   1440
      Width           =   3255
   End
   Begin VB.TextBox FolderPathText 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   3840
      TabIndex        =   5
      Text            =   "C:\Cliente\Req"
      Top             =   840
      Width           =   3255
   End
   Begin VB.Label Label5 
      Caption         =   "Dados Escritos"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   360
      TabIndex        =   4
      Top             =   5160
      Width           =   2175
   End
   Begin VB.Label Label4 
      Caption         =   "Fun��es"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   360
      TabIndex        =   3
      Top             =   2160
      Width           =   1455
   End
   Begin VB.Label Label3 
      Caption         =   "Valor para venda e cancelamento"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   600
      TabIndex        =   2
      Top             =   1560
      Width           =   3135
   End
   Begin VB.Label Label2 
      Caption         =   "Caminho de escrita para arquivo:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   600
      TabIndex        =   1
      Top             =   960
      Width           =   3135
   End
   Begin VB.Label Label1 
      Caption         =   "Configura��es"
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
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   1815
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
' VB6 
' -*- coding: utf-8 -*- 
' --------------------------------------------------------------------------------------------
' Created By  : Gabriel Alves Franzeri
' Created Date: 09/10/2021 ..etc
' version ='1.0'
' --------------------------------------------------------------------------------------------
' """Clone de utilitário da Elgin para comunicação por troca de arquivos com TEFPassivo"""
' --------------------------------------------------------------------------------------------
' IMPORTANTE
' Executar código na mesma pasta que a lib E1_Impressora01.dll
' --------------------------------------------------------------------------------------------

'Declara��es para a fun��o do bot�o Browse para selecionar uma pasta
Private Const BIF_RETURNONLYFSDIRS = 1
Private Const BIF_DONTGOBELOWDOMAIN = 2
Private Const MAX_PATH = 260

Private Type BrowseInfo
    hwndOwner      As Long
    pIDLRoot       As Long
    pszDisplayName As Long
    lpszTitle      As Long
    ulFlags        As Long
    lpfnCallback   As Long
    lParam         As Long
    iImage         As Long
End Type

Private Declare Function SHBrowseForFolder Lib "shell32" (lpbi As BrowseInfo) As Long

Private Declare Function SHGetPathFromIDList Lib "shell32" (ByVal pidList As Long, ByVal lpBuffer As String) As Long

Private Declare Function lstrcat Lib "kernel32" Alias "lstrcatA" (ByVal lpString1 As String, ByVal lpString2 As String) As Long

'Declara��es de vari�veis para a impressora
Public tipo As Long
Public modelo As String
Public conexao As String
Public parametro As Long

' retorna o caminho para o arquivo temporário e para o definitivo a ser lido pelo GP
Public Function ConstantPath(mark As String) As String
    Dim FileTmp As String
    Dim File001 As String
    FileTmp = "\INTPOS.tmp"
    File001 = "\INTPOS.001"
    If mark = "tmp" Then
        ConstantPath = FileTmp
    Else
        ConstantPath = File001
    End If
End Function

' Função para escolher o diretório
Public Function OpenDirectoryTV(Optional odtvTitle As String) As String
    Dim lpIDList As Long
    Dim sBuffer As String
    Dim szTitle As String
    Dim tBrowseInfo As BrowseInfo
    szTitle = odtvTitle
    With tBrowseInfo
          .hwndOwner = Form1.hWnd
          .lpszTitle = lstrcat(szTitle, "")
          .ulFlags = BIF_RETURNONLYFSDIRS
    End With
    lpIDList = SHBrowseForFolder(tBrowseInfo)
    If (lpIDList) Then
        sBuffer = Space(MAX_PATH)
        SHGetPathFromIDList lpIDList, sBuffer
        sBuffer = Left(sBuffer, InStr(sBuffer, vbNullChar) - 1)
        OpenDirectoryTV = sBuffer
    End If
End Function

Private Sub CreateFile()
    Dim FilePath As String
    FilePath = FolderPathText.Text + ConstantPath("tmp")
    Open FilePath For Random As #1
    Close #1
End Sub

Private Sub DeleteFile()
    Dim FilePath As String
    FilePath = FolderPathText.Text + ConstantPath("001")
    On Error Resume Next
    Kill FilePath
End Sub

Private Sub RenameFile()
    Dim OldName, NewName As String
    OldName = FolderPathText.Text + ConstantPath("tmp")
    NewName = FolderPathText.Text + ConstantPath("001")
    Name OldName As NewName 'Move and rename file
End Sub

Private Sub ReadFile()
    Dim currentLine As String
    Dim FileName As String
    Dim iFile As Integer
    FileName = FolderPathText.Text + ConstantPath("tmp")
    iFile = FreeFile()
    Open FileName For Input As #iFile
        ' DataEntry.Text = StrConv(InputB(LOF(iFile), iFile), vbUnicode)
        Do While Not EOF(iFile)
            Input #iFile, currentLine
            DataEntry.Text = DataEntry.Text + currentLine + vbCrLf
        Loop
    Close #iFile
End Sub

Private Sub AppendFile(ByVal key As String, ByVal value As String)
    Dim iFile As Integer
    iFile = FreeFile
    Open FolderPathText.Text + ConstantPath("tmp") For Append As #iFile
        Print #iFile, key & " = " & value
    Close #iFile
End Sub

' Função que testa a conexão da impressora 
Public Function TestaConexao() As String
    Dim int_conexao As Integer
    int_conexao = AbreConexaoImpressora(tipo, modelo, conexao, parametro)
    FechaConexaoImpressora
    If int_conexao = 0 Then
        TestaConexao = "Impressora Conectada"
    Else
        MsgBox CStr(int_conexao)
        TestaConexao = ""
    End If
End Function

Private Sub Imprime(ByVal dados As String)
    If AbreConexaoImpressora(tipo, modelo, conexao, parametro) = 0 Then
        ImpressaoTexto dados, 0, 1, 0
        AvancaPapel 1
        Corte 1
        FechaConexaoImpressora
    Else
        MsgBox "h� algum problema com a conex�o com a impressora"
    End If
End Sub

' Função que faz o tratamento do texto de retorno para extrair o comprovante 
Private Sub BuscaComprovante()
    Dim i As Integer
    Dim pos As Integer
    Dim path As String
    Dim iFile As Integer
    Dim lines As Variant
    Dim textData As String
    path = "C:\Cliente\Resp\INTPOS.001"
    'read file
    iFile = FreeFile
    Open path For Binary As #iFile
        textData = Space$(LOF(iFile))
        Get #iFile, , textData
    Close #iFile
    lines = Split(textData, " = ")
    Dim element As Variant
    Dim cuttingLenght As Integer
    Dim temp As Variant
    Dim res As String
    temp = ""
    i = 0
    'choose lines
    For Each element In lines
        If InStr(element, "029") <> 0 Then
            If InStr(element, "029-001") = 0 Then
                temp = temp + element + ";"
            End If
        End If
        i = i + 1
    Next element
    temp = Split(temp, ";")
    'format lines
    For Each element In temp
        i = i + 1
        cuttingLenght = Len(element) - 7
        If cuttingLenght > 0 Then
            res = res + Left(element, cuttingLenght) + vbCrLf
        Else
            If i <> 1 Then
                res = res + element
            End If
        End If
    Next element
    DataEntry.Text = res
    'manda imprimir
    Imprime res
End Sub

Private Sub btnADM_Click()
    Dim x As Integer
    Dim keys_venda As String
    Dim values_venda As String
    Dim k() As String
    Dim v() As String
    keys_venda = "000-000 001-000 999-999"
    values_venda = "ADM 1 0"
    k() = Split(keys_venda, " ")
    v() = Split(values_venda, " ")
    
    DataEntry.Text = ""
    DeleteFile
    CreateFile
    For x = 0 To UBound(k)
        AppendFile k(x), v(x)
    Next
    ReadFile
    RenameFile
End Sub

Private Sub btnCancelamentoVenda_Click()
    Dim x As Integer
    Dim keys_venda As String
    Dim values_venda As String
    Dim k() As String
    Dim v() As String
    keys_venda = "000-000 001-000 999-999"
    values_venda = "CNC 1 0"
    k() = Split(keys_venda, " ")
    v() = Split(values_venda, " ")
    
    DataEntry.Text = ""
    DeleteFile
    CreateFile
    For x = 0 To UBound(k)
        AppendFile k(x), v(x)
    Next
    ReadFile
    RenameFile
End Sub

Private Sub btnConexaoImpressora_Click()
    Form2.Show
End Sub


Private Sub btnConfirmarVenda_Click()
    Dim x As Integer
    Dim keys_venda As String
    Dim values_venda As String
    Dim k() As String
    Dim v() As String
    keys_venda = "000-000 001-000 027-000 999-999"
    values_venda = "CNF 1 123456 0"
    k() = Split(keys_venda, " ")
    v() = Split(values_venda, " ")
    
    DataEntry.Text = ""
    DeleteFile
    CreateFile
    For x = 0 To UBound(k)
        AppendFile k(x), v(x)
    Next
    ReadFile
    RenameFile
End Sub

Private Sub btnNaoConfirmaVenda_Click()
    Dim x As Integer
    Dim keys_venda As String
    Dim values_venda As String
    Dim k() As String
    Dim v() As String
    keys_venda = "000-000 001-000 027-000 999-999"
    values_venda = "NCN 1 123456 0"
    k() = Split(keys_venda, " ")
    v() = Split(values_venda, " ")
    
    DataEntry.Text = ""
    DeleteFile
    CreateFile
    For x = 0 To UBound(k)
        AppendFile k(x), v(x)
    Next
    ReadFile
    RenameFile
End Sub


Private Sub btnVenda_Click()
    Dim x As Integer
    Dim keys_venda As String
    Dim values_venda As String
    Dim k() As String
    Dim v() As String
    keys_venda = "000-000 001-000 002-000 003-000 004-000 999-999"
    values_venda = "CRT 1 123456 " + ValorVendaText.Text + "00 0 0"
    k() = Split(keys_venda, " ")
    v() = Split(values_venda, " ")
    
    DataEntry.Text = ""
    DeleteFile
    CreateFile
    For x = 0 To UBound(k)
        AppendFile k(x), v(x)
    Next
    ReadFile
    RenameFile
End Sub

Private Sub ChooseDir_Click()
    Dim folder As String
    folder = OpenDirectoryTV("Select Folder")
    If folder <> "" Then
        MsgBox "You selected : " & folder
        FolderPathText.Text = folder
    End If
End Sub


Private Sub reImpressaoButton_Click()
    If TestaConexao <> "" Then
        If ArquivoExiste <> "" Then
            BuscaComprovante
        End If
    Else
        MsgBox "N�o � poss�vel imprimir seu comprovante pois nenhuma impressora est� conectada."
    End If
End Sub

Private Function ArquivoExiste() As String
    If Dir("C:\Cliente\Resp\INTPOS.001") <> "" Then
        ArquivoExiste = "existe"
    Else
        MsgBox "0 arquivo do comprovante C:\Cliente\Resp\INTPOS.001 n�o existe!"
        ArquivoExiste = ""
    End If
End Function
