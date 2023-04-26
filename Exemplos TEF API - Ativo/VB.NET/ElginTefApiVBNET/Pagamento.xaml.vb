Imports System.IO
Imports System.Runtime.InteropServices
Imports System.Text.RegularExpressions
Imports System.Threading

Public Class Pagamento

    Public clickEvent As AutoResetEvent = New AutoResetEvent(False)

    Private Const ADM_USUARIO As String = ""
    Private Const ADM_SENHA As String = ""
    Private Const OPERACAO_TEF As Integer = 0
    Private Const OPERACAO_ADM As Integer = 1
    Private Const OPERACAO_PIX As Integer = 2
    Public Shared Property RetornoUI As String = ""
    Public Shared Property valorTotal As String = String.Empty
    Public Shared Property cancelarColeta As String = String.Empty
    Public Shared Property Operacao As Integer = OPERACAO_TEF


    ' evento dos botões do teclado numérico, escrevendo seus números no label do valor da venda
    Private Sub Button_Click(sender As Object, e As RoutedEventArgs)
        Dim b As Button = CType(sender, Button)

        If LblValor.Text <> "0" Then
            Dim cleanString As String = Regex.Replace(valorTotal + b.Content.ToString(), "[^\d]", "")
            Dim trimmed As String = cleanString.TrimStart("0"c)

            If trimmed.Length > 2 Then
                Dim withDecimal As String = trimmed.Insert(trimmed.Length - 2, ".")
                valorTotal = withDecimal
            Else
                valorTotal = If(trimmed.Length > 1, "0." & trimmed, "0.0" & trimmed)
            End If

            LblValor.Text = valorTotal
        Else
            LblValor.Text = b.Content.ToString()
        End If
    End Sub

    ' apaga último número escrito no label de venda
    Private Sub BtnBS_Click(sender As Object, e As RoutedEventArgs)
        valorTotal = valorTotal.Remove(LblValor.Text.Length - 1)
        Dim cleanString As String = Regex.Replace(valorTotal, "[^\d]", "")
        Dim trimmed As String = cleanString.TrimStart("0"c)

        If trimmed.Length > 2 Then
            Dim withDecimal As String = trimmed.Insert(trimmed.Length - 2, ".")
            valorTotal = withDecimal
        Else
            valorTotal = If(trimmed.Length > 1, "0." & trimmed, "0.0" & trimmed)
        End If

        LblValor.Text = valorTotal
    End Sub

    ' apaga valor da venda
    Private Sub BtnClear_Click(sender As Object, e As RoutedEventArgs)
        valorTotal = ""
        LblValor.Text = "0.00"
    End Sub

    ' evento botão de débito, inicializa processo e entra no loop principal

    Private Async Sub BtnIniciarOperacaoTEF_Click(sender As Object, e As RoutedEventArgs)
        Operacao = OPERACAO_TEF
        lblOperador1.Visibility = Visibility.Visible
        lblOperador1.Content = "AGUARDE..."
        valorTotal = LblValor.Text
        LblValor.Text = ""
        btnInciarOperacaoPIX.IsEnabled = False
        btnIniciarOperacaoTEF.IsEnabled = False
        Await Task.Run(Sub()
                           TesteApiElginTEF()
                       End Sub)
        btnInciarOperacaoPIX.IsEnabled = True
        btnIniciarOperacaoTEF.IsEnabled = True
    End Sub

    ' evento botão de débito, inicializa processo e entra no loop principal
    Private Async Sub BtnIniciarOperacaoPIX_Click(sender As Object, e As RoutedEventArgs)
        Operacao = OPERACAO_PIX
        lblOperador1.Visibility = Visibility.Visible
        lblOperador1.Content = "AGUARDE..."
        valorTotal = LblValor.Text
        LblValor.Text = ""
        btnInciarOperacaoPIX.IsEnabled = False
        btnIniciarOperacaoTEF.IsEnabled = False
        Await Task.Run(Sub()
                           TesteApiElginTEF()
                       End Sub)
        btnInciarOperacaoPIX.IsEnabled = True
        btnIniciarOperacaoTEF.IsEnabled = True
    End Sub

    ' evento do botão dinâmico prosseguir
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
        imgQRCode.Visibility = Visibility.Hidden

        If cmbLista.Visibility = Visibility.Visible Then
            RetornoUI = retCmb
        Else
            RetornoUI = retTxt
        End If

        cmbLista.Visibility = Visibility.Hidden
        clickEvent.[Set]()
    End Sub

    ' evento do botão dinâmico "Cancelar" 
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
                              imgQRCode.Visibility = Visibility.Hidden

                              If msg.Contains("QRCODE;") Then
                                  Dim start As Integer = msg.IndexOf(";") + 1
                                  Dim [end] As Integer = msg.LastIndexOf(";")
                                  Dim hexQrCodeString As String = msg.Substring(start, [end] - start)
                                  ShowQRCode(hexQrCodeString)
                                  imgQRCode.Visibility = Visibility.Visible
                                  btnOk.Visibility = Visibility.Visible
                                  btnCancelar.Visibility = Visibility.Visible
                              Else
                                  lblOperador1.Content = msg
                                  lblOperador1.Visibility = Visibility.Visible
                                  ' quando uma dessas mensagens estiver presente não mostrar os botões
                                  Dim msgArray As String() = {"aguarde", "finalizada", "passagem", "cancelada", "iniciando confirmação"}

                                  If Not msgArray.Any(AddressOf msg.ToLower().Contains) Then
                                      txtOperador.Visibility = Visibility.Visible
                                      txtOperador.Focus()
                                      btnOk.Visibility = Visibility.Visible
                                      btnCancelar.Visibility = Visibility.Visible
                                  End If
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
                              imgQRCode.Visibility = Visibility.Hidden
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

    Public Sub ShowQRCode(hexString As String)
        ' convert hex to byte array
        Dim imageBytes As Byte() = HexToByteArray(hexString)

        ' create memoryStream that wraps the byte array
        Using stream As MemoryStream = New MemoryStream(imageBytes)
            Dim qrImage As BitmapImage = New BitmapImage()
            qrImage.BeginInit()
            qrImage.StreamSource = stream
            qrImage.CacheOption = BitmapCacheOption.OnLoad
            qrImage.EndInit()
            imgQRCode.Source = qrImage
        End Using
    End Sub

    Private Function HexToByteArray(hexString As String) As Byte()
        If hexString Is Nothing Then
            Throw New ArgumentNullException("hexString")
        End If

        If hexString.Length Mod 2 <> 0 Then
            Throw New ArgumentException("hexString must have an even length")
        End If

        Dim result As Byte() = New Byte(hexString.Length / 2 - 1) {}

        For i As Integer = 0 To hexString.Length - 1 Step 2
            Dim byteString As String = hexString.Substring(i, 2)
            result(i / 2) = Convert.ToByte(byteString, 16)
        Next

        Return result
    End Function

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

    ' //===================================================================== //
    ' //========================= LÓGICA DO TEF ============================= //
    ' //===================================================================== //

    ' //===================================================================== //
    ' //=============================== TESTES ============================== //
    ' //===================================================================== //

    Public Sub TesteApiElginTEF()
        Try
            ControleApi.SetClientTCP("127.0.0.1", 60906)
            ControleApi.ConfigurarDadosPDV("Meu PDV VB.NET", "v1.0.000", "Elgin", "01", "T0004")

            ' 1) INICIAR CONEXAO COM CLIENT
            Dim start As String = iniciar()

            Dim retorno As String = ControleApi.getRetorno(start)
            If retorno = String.Empty OrElse retorno <> "1" Then
                finalizar()
            End If

            ' 2) REALIZAR OPERAÇÃO
            Dim sequencial As String = ControleApi.getSequencial(start)
            sequencial = ControleApi.incrementarSequencial(sequencial)

            ' string resp = vender(0, sequencial);   // Pgto --> Perguntar tipo do cartao
            'tring resp = vender(1, sequencial);   // Pgto --> Cartao de credito
            'String resp = vender(2, sequencial);   // Pgto --> Cartao de debito
            'String resp = vender(3, sequencial);   // Pgto --> Voucher (debito)
            'String resp = vender(4, sequencial);   // Pgto --> Frota (debito)
            'String resp = vender(5, sequencial);   // Pgto --> Private label (credito)
            'String resp = adm(0, sequencial);      // Adm  --> Perguntar operacao
            'String resp = adm(1, sequencial);      // Adm  --> Cancelamento
            'String resp = adm(2, sequencial);      // Adm  --> Pendencias
            'String resp = adm(3, sequencial);      // Adm  --> Reimpressao

            Dim resp As String = String.Empty

            ' Continuar operacao/iniciar o processo de coleta

            If ControleApi.ModoOperacao.Contains("vender") Then
                ' coletar vendas
                resp = If(Operacao = OPERACAO_TEF, vender(0, sequencial, OPERACAO_TEF), vender(0, sequencial, OPERACAO_PIX))
            Else
                ' coletar adms
                resp = adm(0, sequencial)
            End If

            retorno = ControleApi.getRetorno(resp)

            ' 3) VERIFICAR RESULTADO / CONFIRMAR 
            If retorno = String.Empty Then

                If ControleApi.ModoOperacao.Contains("vender") Then
                    resp = coletar(0, ControleApi.jsonify(resp))
                Else
                    resp = coletar(1, ControleApi.jsonify(resp))
                End If

                retorno = ControleApi.getRetorno(resp)
            End If

            If retorno = String.Empty Then

                WriteLogs(True, "ERRO AO COLETAR DADOS", True)
                Print("ERRO AO COLETAR DADOS")

            ElseIf retorno = "0" Then

                Dim comprovanteLoja As String = ControleApi.getComprovante(resp, "loja")
                Dim comprovanteCliente As String = ControleApi.getComprovante(resp, "cliente")
                WriteLogs(True, comprovanteLoja, True)
                WriteLogs(True, comprovanteCliente, True)

                WriteLogs(True, "TRANSAÇÃO OK, INICIANDO CONFIRMAÇÃO...", True)
                Print("TRANSAÇÃO OK, INICIANDO CONFIRMAÇÃO...")
                sequencial = ControleApi.getSequencial(resp)

                ' confirma a operação através do sequencial utilizado
                Dim cnf As String = confirmar(sequencial)
                retorno = ControleApi.getRetorno(cnf)

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
            retorno = ControleApi.getRetorno([end])

            ' 4) FINALIZAR CONEXÃO
            If retorno = String.Empty OrElse retorno <> "1" Then
                finalizar()
            End If

        Catch __unusedDllNotFoundException1__ As DllNotFoundException
            MessageBox.Show("Dll não encontrada")
        End Try
    End Sub


    ' //===================================================================== //
    ' //============ MÉTODOS PARA O CONTROLE DA TRANSAÇÃO (E1_TEF) ========== //
    ' //===================================================================== //

    Public Function iniciar() As String
        Dim payload As IDictionary(Of String, Object) = New Dictionary(Of String, Object)()

        ' payload.Add("aplicacao",         "Meu PDV");
        'payload.Add("aplicacao_tela", "Meu PDV");
        'payload.Add("versao", "v0.0.001");
        'payload.Add("estabelecimento", "Elgin");
        'payload.Add("loja", "01");
        'payload.Add("terminal", "T0004");

        'payload.Add("nomeAC", "Meu PDV");
        'payload.Add("textoPinpad", "Meu PDV");
        'payload.Add("versaoAC", "v0.0.001");
        'payload.Add("nomeEstabelecimento", "Elgin");
        'payload.Add("loja", "01");
        'payload.Add("identificadorPontoCaptura", "T0004");

        Dim _intptr As IntPtr = ControleApi.IniciarOperacaoTEF(ControleApi.stringify(payload))
        Dim start As String = Marshal.PtrToStringAnsi(_intptr)
        WriteLogs(True, ControleApi.__Function() & "  " & start, True)
        Return start
    End Function

    Public Function vender(cartao As Integer, sequencial As String, operacao As Integer) As String
        WriteLogs(True, ControleApi.__Function() & " SEQUENCIAL UTILIZADO NA VENDA: " & sequencial, True)
        Dim payload As IDictionary(Of String, Object) = New Dictionary(Of String, Object)()
        payload.Add("sequencial", sequencial)

        ' se um valor tiver sido escrito antes da transação, usar esse valor em centavos
        If valorTotal <> String.Empty Then
            valorTotal = Regex.Replace(valorTotal, "[^\d]", "")
            payload.Add("valorTotal", valorTotal)
        End If

        Dim pgto As String

        If operacao = OPERACAO_TEF Then
            Dim _intptr As IntPtr = ControleApi.RealizarPagamentoTEF(cartao, ControleApi.stringify(payload), True)
            pgto = Marshal.PtrToStringAnsi(_intptr)
        Else
            Dim _intptr As IntPtr = ControleApi.RealizarPixTEF(ControleApi.stringify(payload), True)
            pgto = Marshal.PtrToStringAnsi(_intptr)
        End If

        WriteLogs(True, ControleApi.__Function() & "  " & pgto, True)
        Return pgto
    End Function

    Public Function adm(opcao As Integer, sequencial As String) As String
        WriteLogs(True, ControleApi.__Function() & " SEQUENCIAL UTILIZADO NA VENDA: " & sequencial, True)
        Dim payload As IDictionary(Of String, Object) = New Dictionary(Of String, Object)()
        payload.Add("sequencial", sequencial)

        ' payload.Add("transacao_administracao_usuario", ADM_USUARIO);
        ' payload.Add("transacao_administracao_senha", ADM_SENHA);
        ' payload.Add("admUsuario", ADM_USUARIO);
        ' payload.Add("admSenha", ADM_SENHA);

        Dim _intptr As IntPtr = ControleApi.RealizarAdmTEF(opcao, ControleApi.stringify(payload), True)
        Dim admRed As String = Marshal.PtrToStringAnsi(_intptr)
        WriteLogs(True, ControleApi.__Function() & "  " & admRed, True)
        Return admRed
    End Function

    Public Function coletar(operacao As Integer, root As IDictionary(Of String, Object)) As String
        ' chaves utilizadas na coleta
        Dim coletaRetorno, coletaSequencial, coletaMensagem, coletaTipo, coletaOpcao, coletaInformacao As String

        ' extrai os dados da resposta / coleta
        coletaRetorno = ControleApi.getStringValue(root, "tef", "automacao_coleta_retorno")
        coletaSequencial = ControleApi.getStringValue(root, "tef", "automacao_coleta_sequencial")
        coletaMensagem = ControleApi.getStringValue(root, "tef", "mensagemResultado")
        coletaTipo = ControleApi.getStringValue(root, "tef", "automacao_coleta_tipo")
        coletaOpcao = ControleApi.getStringValue(root, "tef", "automacao_coleta_opcao")

        WriteLogs(True, ControleApi.__Function() & " " & coletaMensagem.ToUpper(), True)
        Print(coletaMensagem.ToUpper())

        ' em caso de erro, encerra coleta
        If coletaRetorno <> "0" Then Return ControleApi.stringify(root)
        Dim payload As IDictionary(Of String, Object) = New Dictionary(Of String, Object)()

        ' em caso de sucesso, monta o (novo ) payload e continua a coleta
        payload.Add("automacao_coleta_retorno", coletaRetorno)
        payload.Add("automacao_coleta_sequencial", coletaSequencial)

        ' coleta dado do usuário, caso necessário
        If coletaTipo <> String.Empty AndAlso coletaOpcao = String.Empty Then
            ' valor inserido (texto)
            WriteLogs(True, "INFORME O VALOR SOLICITADO: ", True)
            coletaInformacao = Read()

            If cancelarColeta <> String.Empty Then
                payload.Remove("automacao_coleta_retorno")
                payload.Add("automacao_coleta_retorno", cancelarColeta)
                cancelarColeta = String.Empty
            End If

            payload.Add("automacao_coleta_informacao", coletaInformacao)
        ElseIf coletaTipo <> String.Empty AndAlso coletaOpcao <> String.Empty Then
            ' valor selecionado (lista)
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

        ' informa os dados coletados
        Dim resp As String

        If operacao = 1 Then
            Dim _intptr As IntPtr = ControleApi.RealizarAdmTEF(0, ControleApi.stringify(payload), False)
            resp = Marshal.PtrToStringAnsi(_intptr)
        Else

            If operacao = OPERACAO_PIX Then
                Dim _intptr As IntPtr = ControleApi.RealizarPixTEF(ControleApi.stringify(payload), False)
                resp = Marshal.PtrToStringAnsi(_intptr)
            Else
                Dim _intptr As IntPtr = ControleApi.RealizarPagamentoTEF(0, ControleApi.stringify(payload), False)
                resp = Marshal.PtrToStringAnsi(_intptr)
            End If
        End If

        ' verifica fim da coleta
        Dim retorno As String = ControleApi.getRetorno(resp)

        If retorno <> String.Empty Then
            ' fim da coleta
            Return resp
        End If

        Return coletar(operacao, ControleApi.jsonify(resp))
    End Function

    Public Function confirmar(sequencial As String) As String
        WriteLogs(True, ControleApi.__Function() & "SEQUENCIAL DA OPERAÇÃO A SER CONFIRMADA: " & sequencial, True)
        Print("AGUARDE, CONFIRMANDO OPERAÇÃO...")
        Dim _intptr As IntPtr = ControleApi.ConfirmarOperacaoTEF(Integer.Parse(sequencial), 1)
        Dim cnf As String = Marshal.PtrToStringAnsi(_intptr)
        WriteLogs(True, ControleApi.__Function() & cnf, True)
        Return cnf
    End Function

    Public Function finalizar() As String
        Dim _intptr As IntPtr = ControleApi.FinalizarOperacaoTEF(1) ' api resolve o sequencial
        Dim [end] As String = Marshal.PtrToStringAnsi(_intptr)
        WriteLogs(True, ControleApi.__Function() & [end], True)
        valorTotal = String.Empty
        Print("OPERAÇÃO FINALIZADA!")
        Return [end]
    End Function



    ' //===================================================================== //
    ' //============ METODOS UTILITÁRIOS PARA O EXEMPLO C# ================== //
    ' //===================================================================== //

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

End Class
