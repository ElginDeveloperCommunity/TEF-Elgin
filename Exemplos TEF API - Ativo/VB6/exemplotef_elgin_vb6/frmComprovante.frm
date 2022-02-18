VERSION 5.00
Begin VB.Form frmComprovante 
   Caption         =   "Form2"
   ClientHeight    =   6960
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4575
   LinkTopic       =   "Form2"
   ScaleHeight     =   6960
   ScaleWidth      =   4575
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton Command1 
      Caption         =   "OK"
      Height          =   375
      Left            =   2760
      TabIndex        =   1
      Top             =   6480
      Width           =   1575
   End
   Begin VB.TextBox Text1 
      Height          =   6015
      Left            =   240
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   360
      Width           =   4095
   End
End
Attribute VB_Name = "frmComprovante"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Unload frmComprovante
End Sub
