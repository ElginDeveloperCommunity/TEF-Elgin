VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form frmDadosTransacao 
   Caption         =   "Form1"
   ClientHeight    =   10455
   ClientLeft      =   555
   ClientTop       =   945
   ClientWidth     =   5070
   LinkTopic       =   "Form1"
   ScaleHeight     =   10455
   ScaleWidth      =   5070
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton Command1 
      Caption         =   "OK"
      Height          =   375
      Left            =   3480
      TabIndex        =   1
      Top             =   9840
      Width           =   1455
   End
   Begin MSFlexGridLib.MSFlexGrid MSFlexGrid1 
      Height          =   9375
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   4695
      _ExtentX        =   8281
      _ExtentY        =   16536
      _Version        =   393216
      FixedCols       =   0
   End
End
Attribute VB_Name = "frmDadosTransacao"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    Unload frmDadosTransacao
End Sub
