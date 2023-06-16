Attribute VB_Name = "Utils"

' ================================================================== '
' ========== METODOS UTILITÁRIOS PARA O EXEMPLO VB6 ================ '
' ================================================================== '

Public Function incrementarSequencial(ByVal sequencial As String) As String
    Dim seq As String
    If IsNumeric(sequencial) Then
        seq = CInt(sequencial)
    Else
      seq = ""
    End If
    incrementarSequencial = seq
End Function

Public Function Jsonify(ByVal jsonString As String) As JsonBag
    Dim JB As JsonBag
    Set JB = New JsonBag
    JB.JSON = jsonString
    Set Jsonify = JB
End Function

Public Function Stringify(ByVal JSON As JsonBag) As String
    Stringify = JSON.JSON
End Function

Public Function GetStringValue(ByVal JSON As JsonBag, ByVal outerKey As String, Optional ByVal innerKey As String = "") As String
    Dim ret As String
    Dim innerjson As JsonBag
    
    If JSON.Exists(outerKey) Then
        If innerKey = "" Then
            ret = JSON.Item(outerKey)
        ElseIf TypeOf JSON.Item(outerKey) Is JsonBag Then
            Set innerjson = JSON.Item(outerKey)
            If innerjson.Exists(innerKey) Then
                ret = JSON.Item(outerKey).Item(innerKey)
            Else
                ret = ""
            End If
        Else
            ret = ""
        End If
    Else
        ret = ""
    End If
    GetStringValue = ret
End Function

Public Function GetRetorno(ByVal resp As String) As String
    GetRetorno = GetStringValue(Jsonify(resp), "tef", "retorno")
End Function

Public Function GetSequencial(ByVal resp As String) As String
    GetSequencial = GetStringValue(Jsonify(resp), "tef", "sequencial")
End Function

Public Function GetComprovante(ByVal resp As String, ByVal via As String) As String
    Dim ret As String
    If via = "loja" Then
        ret = GetStringValue(Jsonify(resp), "tef", "comprovanteDiferenciadoLoja")
    ElseIf via = "cliente" Then
        ret = GetStringValue(Jsonify(resp), "tef", "comprovanteDiferenciadoPortador")
    Else
        ret = ""
    End If
    GetComprovante = ret
End Function

Public Function MostrarBotoes(ByVal mensagem As String) As Boolean
    Dim msgArray As Variant
    msgArray = Array("aguarde", "finalizada", "passagem", "cancelada", "erro ao coletar dados", "iniciando confirmação", "transacao aprovada", "nao ha transacoes")
    
    Dim i As Integer
    Dim msgToLower As String
    msgToLower = LCase(mensagem)
    
    Dim showButtons As Boolean
    showButtons = True
    
    For i = LBound(msgArray) To UBound(msgArray)
        If InStr(msgToLower, LCase(msgArray(i))) <> 0 Then
            showButtons = False
            Exit For
        End If
    Next i
    
    MostrarBotoes = showButtons
End Function


'Função para conversão de ponteiro para String
Public Function StrPtrToString(ByVal ponteiro As Long) As String
    Dim Saida As String
    Saida = SysAllocStringByteLen(ponteiro, lstrlenA(ponteiro))
    StrPtrToString = Saida
End Function

Public Function HexToByteArray(ByVal hexString As String) As Byte()
    ' Remove any leading "0x" from the hex string
    hexString = Replace(hexString, "0x", "")
    
    ' Calculate the number of bytes in the byte array
    Dim numBytes As Long
    numBytes = Len(hexString) \ 2
    
    ' Create a byte array of the appropriate size
    ReDim byteArray(0 To numBytes - 1) As Byte
    
    ' Convert each pair of hex characters to a byte
    Dim i As Long
    For i = 0 To numBytes - 1
        byteArray(i) = Val("&H" & Mid(hexString, i * 2 + 1, 2))
    Next i
    
    ' Return the resulting byte array
    HexToByteArray = byteArray
End Function

Public Sub SaveByteArrayAsBitmapFile(ByRef byteArray() As Byte, ByVal filePath As String)
    ' Create a binary file and write the byte array to it
    Dim fileNumber As Integer
    fileNumber = FreeFile
    
    Open filePath For Binary Access Write As fileNumber
    Put fileNumber, , byteArray
    Close fileNumber
End Sub

Function FormatCPF(cpf As String) As String
    FormatCPF = Mid(cpf, 1, 3) & "." & _
                Mid(cpf, 4, 3) & "." & _
                Mid(cpf, 7, 3) & "." & _
                Mid(cpf, 10, 2)
End Function

Function FormatRG(rg As String) As String
    FormatRG = Mid(rg, 1, 2) & "." & _
               Mid(rg, 3, 3) & "." & _
               Mid(rg, 6, 3) & "-" & _
               Mid(rg, 9, 1)
End Function

Function FormatCNPJ(cnpj As String) As String
    FormatCNPJ = Mid(cnpj, 1, 2) & "." & _
                 Mid(cnpj, 3, 3) & "." & _
                 Mid(cnpj, 6, 3) & "/" & _
                 Mid(cnpj, 9, 4) & "-" & _
                 Mid(cnpj, 13, 2)
End Function

Function FormatPhone(phone As String) As String
    FormatPhone = "(" & Mid(phone, 1, 2) & ") " & _
                  Mid(phone, 3, 5) & "-" & _
                  Mid(phone, 8, 4)
End Function

