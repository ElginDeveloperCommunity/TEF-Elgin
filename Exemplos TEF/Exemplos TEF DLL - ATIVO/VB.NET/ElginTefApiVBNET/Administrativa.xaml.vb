Imports Newtonsoft.Json
Imports System.Text.RegularExpressions
Imports System.Runtime.InteropServices
Imports System.Threading
Imports System.Windows.Threading

Public Class Administrativa

    Public clickEvent As AutoResetEvent = New AutoResetEvent(False)

    Const ADM_USUARIO As String = ""
    Const ADM_SENHA As String = ""
        Const OPERACAO_TEF As Integer = 0
        Const OPERACAO_ADM As Integer = 1
        Const OPERACAO_PIX As Integer = 2
        Public Shared Property RetornoUI As String = ""
    Public Shared Property cancelarColeta As String = String.Empty
    Public Shared Property coletaMascara As String = String.Empty

    Private Async Sub BtnIniciarOperacao_Click(sender As Object, e As RoutedEventArgs)
        lblOperador1.Visibility = Visibility.Visible
        lblOperador1.Content = "AGUARDE..."
        Await Task.Run(Sub()
                           TesteApiElginTEF()
                       End Sub)
    End Sub

    Private Sub btnOk_Click(sender As Object, e As RoutedEventArgs)
        RetornoUI = ""
        Dim retCmb As String = cmbLista.SelectedIndex.ToString()
        Dim retTxt As String = txtOperador.Text
        txtOperador.Text = ""
        lblOperador1.Visibility = Visibility.Hidden
        txtOperador.Visibility = Visibility.Hidden
        btnOk.Visibility = Visibility.Hidden
        btnCancelar.Visibility = Visibility.Hidden
        txtOperador.Visibility = Visibility.Hidden

        If cmbLista.Visibility = Visibility.Visible Then
            RetornoUI = retCmb
        Else
            RetornoUI = retTxt
        End If

        cmbLista.Visibility = Visibility.Hidden
        clickEvent.[Set]()
    End Sub

    Private Sub btnCancelar_Click(sender As Object, e As RoutedEventArgs)
        RetornoUI = "0"
        cancelarColeta = "9"
        clickEvent.[Set]()
    End Sub

    Public Sub printUi(msg As String)
        Dispatcher.Invoke(Sub()
                              lblOperador1.Visibility = Visibility.Hidden
                              txtOperador.Visibility = Visibility.Hidden
                              btnOk.Visibility = Visibility.Hidden
                              btnCancelar.Visibility = Visibility.Hidden
                              txtOperador.Visibility = Visibility.Hidden
                              lblOperador1.Content = msg
                              lblOperador1.Visibility = Visibility.Visible
                              Dim msgArray As String() = {"aguarde", "finalizada", "passagem", "cancelada", "iniciando confirmação"}

                              If Not msgArray.Any(AddressOf msg.ToLower().Contains) Then
                                  txtOperador.Visibility = Visibility.Visible
                                  txtOperador.Focus()
                                  btnOk.Visibility = Visibility.Visible
                                  btnCancelar.Visibility = Visibility.Visible
                              End If
                          End Sub)
    End Sub

    Public Sub printUi(elements As String())
        Dispatcher.Invoke(Sub()
                              cmbLista.Items.Clear()
                              lblOperador1.Visibility = Visibility.Hidden
                              txtOperador.Visibility = Visibility.Hidden
                              btnOk.Visibility = Visibility.Hidden
                              btnCancelar.Visibility = Visibility.Hidden
                              txtOperador.Visibility = Visibility.Hidden
                              lblOperador1.Visibility = Visibility.Visible
                              btnCancelar.Visibility = Visibility.Visible
                              btnOk.Visibility = Visibility.Visible

                              For Each item As String In elements
                                  cmbLista.Items.Add(item)
                              Next

                              cmbLista.Items.Add("Selecione uma opção")
                              cmbLista.SelectedItem = "Selecione uma opção"
                              cmbLista.Visibility = Visibility.Visible
                          End Sub)
    End Sub

    Public Sub WriteLogs(header As Boolean, logs As String, footer As Boolean)
        Const div As String = vbLf & "==============================================" & vbLf
        Dim _output As String = ""
        If header Then _output += div
        _output += logs
        If footer Then _output += div
        Dispatcher.Invoke(Sub()
                              LogsEntry.Text += _output & vbLf
                              LogsEntry.ScrollToEnd()
                          End Sub)
    End Sub

    Public Sub TesteApiElginTEF()
        Try
            ControleApi.SetClientTCP("127.0.0.1", 60906)
            ControleApi.ConfigurarDadosPDV("Meu PDV", "v1.0.000", "Elgin", "01", "T0004")
            Dim start As String = iniciar()
            Dim retorno As String = getRetorno(start)

            If retorno = String.Empty OrElse retorno <> "1" Then
                finalizar()
            End If

            Dim sequencial As String = getSequencial(start)
            sequencial = incrementarSequencial(sequencial)
            Dim resp As String = String.Empty

            If ControleApi.ModoOperacao.Contains("vender") Then
                resp = vender(0, sequencial)
            Else
                resp = adm(0, sequencial)
            End If

            retorno = getRetorno(resp)

            If retorno = String.Empty Then

                If ControleApi.ModoOperacao.Contains("vender") Then
                    resp = coletar(0, jsonify(resp))
                Else
                    resp = coletar(1, jsonify(resp))
                End If

                retorno = getRetorno(resp)
            End If

            If retorno = String.Empty Then
                WriteLogs(True, "ERRO AO COLETAR DADOS", True)
                Print("ERRO AO COLETAR DADOS")
            ElseIf retorno = "0" Then
                Dim comprovanteLoja As String = getComprovante(resp, "loja")
                Dim comprovanteCliente As String = getComprovante(resp, "cliente")
                WriteLogs(True, comprovanteLoja, True)
                WriteLogs(True, comprovanteCliente, True)
                WriteLogs(True, "TRANSAÇÃO OK, INICIANDO CONFIRMAÇÃO...", True)
                Print("TRANSAÇÃO OK, INICIANDO CONFIRMAÇÃO...")
                sequencial = getSequencial(resp)
                Dim cnf As String = confirmar(sequencial)
                retorno = getRetorno(cnf)

                If retorno = String.Empty OrElse retorno <> "1" Then
                    finalizar()
                End If
            ElseIf retorno = "1" Then
                WriteLogs(True, "TRANSAÇÃO OK", True)
                Print("TRANSAÇÃO OK")
            Else
                WriteLogs(True, "ERRO NA TRANSAÇÃO", True)
                Print("ERRO NA TRANSAÇÃO")
            End If

            Dim [end] As String = finalizar()
            retorno = getRetorno([end])

            If retorno = String.Empty OrElse retorno <> "1" Then
                finalizar()
            End If

        Catch __unusedDllNotFoundException1__ As DllNotFoundException
            MessageBox.Show("Dll não encontrada")
        End Try
    End Sub

    Public Function iniciar() As String
        Dim payload As IDictionary(Of String, Object) = New Dictionary(Of String, Object)()
        Dim _intptr As IntPtr = ControleApi.IniciarOperacaoTEF(stringify(payload))
        Dim start As String = Marshal.PtrToStringAnsi(_intptr)
        WriteLogs(True, __Function() & "  " & start, True)
        Return start
    End Function

    Public Function vender(cartao As Integer, sequencial As String) As String
        WriteLogs(True, __Function() & " SEQUENCIAL UTILIZADO NA VENDA: " & sequencial, True)
        Dim payload As IDictionary(Of String, Object) = New Dictionary(Of String, Object)()
        payload.Add("sequencial", sequencial)
        Dim _intptr As IntPtr = ControleApi.RealizarPagamentoTEF(cartao, stringify(payload), True)
        Dim pgto As String = Marshal.PtrToStringAnsi(_intptr)
        WriteLogs(True, __Function() & "  " & pgto, True)
        Return pgto
    End Function

    Public Function adm(opcao As Integer, sequencial As String) As String
        WriteLogs(True, __Function() & " SEQUENCIAL UTILIZADO NA VENDA: " & sequencial, True)
        Dim payload As IDictionary(Of String, Object) = New Dictionary(Of String, Object)()
        payload.Add("sequencial", sequencial)
        Dim _intptr As IntPtr = ControleApi.RealizarAdmTEF(opcao, stringify(payload), True)
        Dim admRet As String = Marshal.PtrToStringAnsi(_intptr)
        WriteLogs(True, __Function() & "  " & admRet, True)
        Return admRet
    End Function

    Public Function coletar(operacao As Integer, root As IDictionary(Of String, Object)) As String
        Dim coletaRetorno, coletaSequencial, coletaMensagem, coletaTipo, coletaOpcao, coletaInformacao As String
        coletaRetorno = getStringValue(root, "tef", "automacao_coleta_retorno")
        coletaSequencial = getStringValue(root, "tef", "automacao_coleta_sequencial")
        coletaMensagem = getStringValue(root, "tef", "mensagemResultado")
        coletaTipo = getStringValue(root, "tef", "automacao_coleta_tipo")
        coletaOpcao = getStringValue(root, "tef", "automacao_coleta_opcao")
        coletaMascara = getStringValue(root, "tef", "automacao_coleta_mascara")
        WriteLogs(True, __Function() & " " & coletaMensagem.ToUpper(), True)
        Print(coletaMensagem.ToUpper())
        If coletaRetorno <> "0" Then Return stringify(root)
        Dim payload As IDictionary(Of String, Object) = New Dictionary(Of String, Object)()
        payload.Add("automacao_coleta_retorno", coletaRetorno)
        payload.Add("automacao_coleta_sequencial", coletaSequencial)

        If coletaTipo <> String.Empty AndAlso coletaOpcao = String.Empty Then
            WriteLogs(True, "INFORME O VALOR SOLICITADO: ", True)
            coletaInformacao = Read()

            If cancelarColeta <> String.Empty Then
                payload.Remove("automacao_coleta_retorno")
                payload.Add("automacao_coleta_retorno", cancelarColeta)
                cancelarColeta = String.Empty
            End If

            payload.Add("automacao_coleta_informacao", coletaInformacao)
        ElseIf coletaTipo <> String.Empty AndAlso coletaOpcao <> String.Empty Then
            Dim opcoes As String() = coletaOpcao.Split(Char.Parse(";"))
            Dim elements As String() = New String(opcoes.Length - 1) {}

            For i As Integer = 0 To opcoes.Length - 1
                elements(i) += "[" & i & "] " & opcoes(i).ToUpper() & vbLf
            Next

            For i As Integer = 0 To opcoes.Length - 1
                WriteLogs(False, "[" & i & "] " & opcoes(i).ToUpper() & vbLf, False)
            Next

            Print(elements)
            WriteLogs(True, vbLf & "DIGITE A OPÇÂO DESEJADA: ", True)
            coletaInformacao = opcoes(Integer.Parse(Read()))

            If cancelarColeta <> String.Empty Then
                payload.Remove("automacao_coleta_retorno")
                payload.Add("automacao_coleta_retorno", cancelarColeta)
                cancelarColeta = String.Empty
            End If

            payload.Add("automacao_coleta_informacao", coletaInformacao)
        End If

        Dim resp As String

        If operacao = 1 Then
            Dim _intptr As IntPtr = ControleApi.RealizarAdmTEF(0, stringify(payload), False)
            resp = Marshal.PtrToStringAnsi(_intptr)
            WriteLogs(True, resp, True)
        Else
            Dim _intptr As IntPtr = ControleApi.RealizarPagamentoTEF(0, stringify(payload), False)
            resp = Marshal.PtrToStringAnsi(_intptr)
        End If

        Dim retorno As String = getRetorno(resp)

        If retorno <> String.Empty Then
            Return resp
        End If

        Return coletar(operacao, jsonify(resp))
    End Function

    Public Function confirmar(sequencial As String) As String
        WriteLogs(True, __Function() & "SEQUENCIAL DA OPERAÇÃO A SER CONFIRMADA: " & sequencial, True)
        Print("AGUARDE, CONFIRMANDO OPERAÇÃO...")
        Dim _intptr As IntPtr = ControleApi.ConfirmarOperacaoTEF(Integer.Parse(sequencial), 1)
        Dim cnf As String = Marshal.PtrToStringAnsi(_intptr)
        WriteLogs(True, __Function() & cnf, True)
        Return cnf
    End Function

    Public Function finalizar() As String
        Dim _intptr As IntPtr = ControleApi.FinalizarOperacaoTEF(1)
        Dim [end] As String = Marshal.PtrToStringAnsi(_intptr)
        WriteLogs(True, __Function() & [end], True)
        Print("OPERAÇÃO FINALIZADA!")
        Return [end]
    End Function

    Public Function incrementarSequencial(sequencial As String) As String
        Dim ok As Boolean
        Dim value As Double = Nothing
        ok = Double.TryParse(sequencial, value) AndAlso Not Double.IsNaN(value) AndAlso Not Double.IsInfinity(value)
        If Not ok Then Return String.Empty
        value += 1
        Return value.ToString()
    End Function

    Public Function getRetorno(resp As String) As String
        Dim _jsonDic As IDictionary(Of String, Object) = jsonify(resp)
        Return getStringValue(_jsonDic, "tef", "retorno")
    End Function

    Public Function getSequencial(resp As String) As String
        Dim _jsonDic As IDictionary(Of String, Object) = jsonify(resp)
        Return getStringValue(_jsonDic, "tef", "sequencial")
    End Function

    Public Function getComprovante(resp As String, via As String) As String
        If via = "loja" Then
            Dim _jsonDic As IDictionary(Of String, Object) = jsonify(resp)
            Return getStringValue(_jsonDic, "tef", "comprovanteDiferenciadoLoja")
        ElseIf via = "cliente" Then
            Dim _jsonDic As IDictionary(Of String, Object) = jsonify(resp)
            Return getStringValue(_jsonDic, "tef", "comprovanteDiferenciadoPortador")
        Else
            Return String.Empty
        End If
    End Function

    Public Function jsonify(jsonString As String) As IDictionary(Of String, Object)
        If jsonString IsNot Nothing Then
            Dim _Dic As IDictionary(Of String, Object) = JsonConvert.DeserializeObject(Of Dictionary(Of String, Object))(jsonString)
            Return _Dic
        Else
            Dim _Dic As IDictionary(Of String, Object) = New Dictionary(Of String, Object)()
            Return _Dic
        End If
    End Function

    Public Function stringify(_jsonDic As IDictionary(Of String, Object)) As String
        Return JsonConvert.SerializeObject(_jsonDic, Formatting.Indented)
    End Function

    Public Function getStringValue(dicJson As IDictionary(Of String, Object), keyOut As String, keyIn As String) As String
        Dim value As Object = Nothing, valueIn As Object = Nothing

        If dicJson IsNot Nothing AndAlso dicJson.TryGetValue(keyOut, value) Then
            Dim _Dic As IDictionary(Of String, Object) = value.ToObject(Of Dictionary(Of String, Object))()

            If _Dic IsNot Nothing AndAlso _Dic.TryGetValue(keyIn, valueIn) Then
                Console.WriteLine(valueIn.[GetType]())
                Return valueIn.ToString()
            Else
                Return String.Empty
            End If
        Else
            Return String.Empty
        End If
    End Function

    Public Function getStringValue(dicJson As IDictionary(Of String, Object), key As String) As String
        Dim value As Object = Nothing

        If dicJson IsNot Nothing AndAlso dicJson.TryGetValue(key, value) Then
            Return value.ToString()
        Else
            Return String.Empty
        End If
    End Function

    Public Sub Print(msg As String)
        printUi(msg)
    End Sub

    Public Sub Print(elements As String())
        printUi(elements)
    End Sub

    Public Function Read() As String
        clickEvent.WaitOne()
        clickEvent.Reset()
        Return RetornoUI
    End Function

    Public Shared Function __Function() As String
        Dim stackTrace As StackTrace = New StackTrace()
        Return stackTrace.GetFrame(1).GetMethod().Name
    End Function

    Private Sub txtOperador_PreviewTextInput(sender As Object, e As System.Windows.Input.TextCompositionEventArgs)
        If coletaMascara = ".##" Then
            Dim textBox = TryCast(sender, TextBox)

            If Char.IsDigit(e.Text(0)) Then
                textBox.Text = FormatValue(textBox.Text, e.Text)
                textBox.CaretIndex = textBox.Text.Length
                e.Handled = True
            End If
        End If

        If coletaMascara = "dd/MM/yy" Then
            Dim textBox = TryCast(sender, TextBox)

            If Char.IsDigit(e.Text(0)) Then
                textBox.Text = FormatDate(textBox.Text, e.Text)
                textBox.CaretIndex = textBox.Text.Length
                e.Handled = True
            End If
        End If
    End Sub

    Public Shared Function FormatValue(text As String, key As String) As String
        text = Regex.Replace(text, "[^\d]", "")
        Return (Double.Parse(text & key) / 100.0).ToString("N2").Replace(",", ".")
    End Function

    Public Shared Function FormatDate(text As String, key As String) As String
        text = Regex.Replace(text, "[^\d]", "")
        text += key

        If text.Length = 6 Then
            Return text.Insert(2, "/").Insert(5, "/")
        ElseIf text.Length > 6 Then
            Return text.Remove(text.Length - 1).Insert(2, "/").Insert(5, "/")
        End If

        Return text
    End Function
End Class
