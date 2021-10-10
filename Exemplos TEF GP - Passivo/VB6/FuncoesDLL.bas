Attribute VB_Name = "FuncoesDLL"

Public Declare Function AbreConexaoImpressora Lib "E1_Impressora01.dll" (ByVal tipo As Long, ByVal modelo As String, ByVal conexao As String, ByVal parametro As Long) As Integer
Public Declare Function ImpressaoTexto Lib "E1_Impressora01.dll" (ByVal dados As String, ByVal posicao As Long, ByVal stilo As Long, ByVal tamanho As Long) As Integer
Public Declare Function Corte Lib "E1_Impressora01.dll" (ByVal avanco As Long) As Integer
Public Declare Function AvancaPapel Lib "E1_Impressora01.dll" (ByVal linhas As Long) As Integer
Public Declare Function FechaConexaoImpressora Lib "E1_Impressora01.dll" () As Integer
