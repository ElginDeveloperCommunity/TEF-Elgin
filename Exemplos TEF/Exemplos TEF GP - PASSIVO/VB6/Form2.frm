VERSION 5.00
Begin VB.Form Form2 
   Caption         =   "Conectar Impressora"
   ClientHeight    =   3285
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   5430
   LinkTopic       =   "Form2"
   ScaleHeight     =   3285
   ScaleWidth      =   5430
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnConectar 
      Caption         =   "Conectar"
      Height          =   735
      Left            =   1800
      TabIndex        =   8
      Top             =   2040
      Width           =   1575
   End
   Begin VB.TextBox txtConexao 
      Height          =   495
      Left            =   1440
      TabIndex        =   7
      Text            =   "USB"
      Top             =   1080
      Width           =   975
   End
   Begin VB.TextBox txtModelo 
      Height          =   495
      Left            =   3960
      TabIndex        =   6
      Text            =   "i9"
      Top             =   360
      Width           =   975
   End
   Begin VB.TextBox txtParam 
      Height          =   495
      Left            =   3960
      TabIndex        =   5
      Text            =   "0"
      Top             =   1080
      Width           =   975
   End
   Begin VB.TextBox txtTipo 
      Height          =   495
      Left            =   1440
      TabIndex        =   4
      Text            =   "1"
      Top             =   360
      Width           =   975
   End
   Begin VB.Label Label4 
      Caption         =   "Modelo"
      Height          =   375
      Left            =   2880
      TabIndex        =   3
      Top             =   360
      Width           =   1215
   End
   Begin VB.Label Label3 
      Caption         =   "Conexao"
      Height          =   375
      Left            =   240
      TabIndex        =   2
      Top             =   1080
      Width           =   1215
   End
   Begin VB.Label Label2 
      Caption         =   "Parâmetros"
      Height          =   375
      Left            =   2880
      TabIndex        =   1
      Top             =   1080
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "Tipo"
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Top             =   360
      Width           =   1215
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' Form para passar os dados da impressora a ser usada
Public Sub btnConectar_Click()
    Form1.tipo = CLng(txtTipo.Text)
    Form1.modelo = txtModelo.Text
    Form1.conexao = txtConexao.Text
    Form1.parametro = CLng(txtParam.Text)
    If Form1.TestaConexao <> "" Then
        MsgBox "Sua impressora estï¿½ conectada"
    Else
        MsgBox "Houve algum problema na hora da conexão, verifique os parametros" + vbCrLf + vbCrLf + CStr(tipo) + vbCrLf + modelo + vbCrLf + conexao + vbCrLf + CStr(parametros)
    End If
End Sub


