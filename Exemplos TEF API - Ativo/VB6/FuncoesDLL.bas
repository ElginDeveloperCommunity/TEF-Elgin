Attribute VB_Name = "FuncoesDLL"

Public Declare Function GetProdutoTef Lib "E1_Tef01.dll" () As Integer
Public Declare Function GetClientTCP Lib "E1_Tef01.dll" () As String
Public Declare Function SetClientTCP Lib "E1_Tef01.dll" (ByVal ip As String, ByVal porta As Long) As Long
Public Declare Function ConfigurarDadosPDV Lib "E1_Tef01.dll" (ByVal textoPinpad As String, ByVal versaoAC As String, ByVal nomeEstabelecimento As String, ByVal loja As String, ByVal identificadorPontoCaptura As String) As Long
Public Declare Function IniciarOperacaoTEF Lib "E1_Tef01.dll" (ByVal dadosCaptura As String) As Long
Public Declare Function RecuperarOperacaoTEF Lib "E1_Tef01.dll" (ByVal dadosCaptura As String) As Long
Public Declare Function RealizarPagamentoTEF Lib "E1_Tef01.dll" (ByVal codigoOperacao As Long, ByVal dadosCaptura As String, ByVal novaTransacao As Boolean) As Long
Public Declare Function RealizarPixTEF Lib "E1_Tef01.dll" (ByVal dadosCaptura As String, ByVal novaTransacao As Boolean) As Long
Public Declare Function RealizarAdmTEF Lib "E1_Tef01.dll" (ByVal codigoOperacao As Long, ByVal dadosCaptura As String, ByVal novaTransacao As Boolean) As Long
Public Declare Function ConfirmarOperacaoTEF Lib "E1_Tef01.dll" (ByVal id As Long, ByVal acao As Long) As Long
Public Declare Function FinalizarOperacaoTEF Lib "E1_Tef01.dll" (ByVal id As Long) As Long
Public Declare Function RealizarColetaPinPad Lib "E1_Tef01.dll" (ByVal tipoColeta As Long, ByVal confirmar As Boolean) As Long
Public Declare Function ConfirmarCapturaPinPad Lib "E1_Tef01.dll" (ByVal tipoCaptura As Long, ByVal dadosCaptura As String) As Long


'FUNÇÕES PARA CÓPIA DE MEMORIA
Public Declare Function lstrlenA Lib "kernel32" (ByVal lpString As Long) As Long
Public Declare Function lstrlenW Lib "kernel32" (ByVal lpString As Long) As Long
Public Declare Function SysAllocStringByteLen Lib "oleaut32.dll" (ByVal m_pBase As Long, ByVal l As Long) As String

'Public Declare Function LoadPicture Lib "GDI32" Alias "LoadImageA" (ByVal hInst As Long, ByVal lpsz As String, ByVal un1 As Long, ByVal n1 As Long, ByVal n2 As Long, ByVal un2 As Long) As Long
'Public Declare Function DeleteObject Lib "GDI32" (ByVal hObject As Long) As Long

