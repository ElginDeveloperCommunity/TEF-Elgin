VERSION 5.00
Begin VB.Form FrmPagamento 
   Caption         =   "Pagamentos"
   ClientHeight    =   8460
   ClientLeft      =   60
   ClientTop       =   405
   ClientWidth     =   13650
   LinkTopic       =   "Form1"
   ScaleHeight     =   8460
   ScaleWidth      =   13650
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnIniciarADM 
      Caption         =   "Administrativo"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   600
      TabIndex        =   12
      Top             =   2640
      Width           =   2055
   End
   Begin VB.Frame frameLogs 
      Caption         =   "Logs"
      Height          =   8055
      Left            =   5760
      TabIndex        =   10
      Top             =   120
      Width           =   7695
      Begin VB.TextBox txtLogs 
         Height          =   7455
         Left            =   240
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   11
         Top             =   360
         Width           =   7215
      End
   End
   Begin VB.CommandButton btnCancelar 
      Caption         =   "Cancelar"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   1800
      TabIndex        =   9
      Top             =   7320
      Width           =   1575
   End
   Begin VB.Frame frameOperador 
      Caption         =   "Processamento Operador"
      Height          =   4215
      Left            =   240
      TabIndex        =   4
      Top             =   3960
      Width           =   5295
      Begin VB.CommandButton btnOk 
         Caption         =   "OK"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   11.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   3360
         TabIndex        =   8
         Top             =   3360
         Width           =   1575
      End
      Begin VB.ListBox lstOperador 
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   11.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1410
         Left            =   240
         TabIndex        =   7
         Top             =   1440
         Visible         =   0   'False
         Width           =   4695
      End
      Begin VB.TextBox txtOperador 
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   405
         Left            =   240
         TabIndex        =   6
         Top             =   1200
         Width           =   4695
      End
      Begin VB.Image imgQRCode 
         Height          =   2895
         Left            =   960
         Top             =   840
         Width           =   2895
      End
      Begin VB.Label lblOperador 
         Caption         =   "Label Operador"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   435
         Left            =   240
         TabIndex        =   5
         Top             =   480
         Width           =   4815
      End
   End
   Begin VB.CommandButton btnIniciarPIX 
      Caption         =   "Iniciar PIX"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   3000
      TabIndex        =   3
      Top             =   1560
      Width           =   2055
   End
   Begin VB.Frame frameValor 
      Caption         =   "Valor"
      Height          =   3615
      Left            =   240
      TabIndex        =   0
      Top             =   120
      Width           =   5295
      Begin VB.CommandButton btnIniciarTEF 
         Caption         =   "Iniciar TEF"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   11.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   735
         Left            =   360
         TabIndex        =   2
         Top             =   1440
         Width           =   2055
      End
      Begin VB.TextBox lblValor 
         Alignment       =   1  'Right Justify
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0,00"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1046
            SubFormatType   =   1
         EndProperty
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   15.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   360
         MaxLength       =   8
         TabIndex        =   1
         Text            =   "1.27"
         Top             =   480
         Width           =   4455
      End
   End
End
Attribute VB_Name = "FrmPagamento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim retornoUI As String
Dim valorTotal As String
Dim operacaoAtual As Integer
Dim cancelarColeta As String
Dim continuaColeta As Boolean

' ================================================
' ----------====== M�TODOS DE UI ========---------
' ================================================

' handle durante fase de coleta emq ue informa��es s�o pedidas ao usu�rio
Private Sub OkEvent()
    Dim retList As String
    Dim retTxt As String
    
    ' vari�vel global usada no fluxo de transa��o para pegar retorno do usu�rio
    retornoUI = ""
    
    ' se usu�rio n�o escolher nenhuma op��o, pedir para que seja escolhida
    If lstOperador.Visible Then
        If lstOperador.ListIndex = -1 Then
            MsgBox "Escolha uma op��o"
            Exit Sub
        End If
    End If
    
    ' se usu�rio n�o escrever o valor pedido, pedir para que seja escrito
    If txtOperador.Visible Then
        If txtOperador.Text = "" Then
            MsgBox "Escreva o valor pedido"
            Exit Sub
        End If
    End If
    
    ' pega valor escolhido pelo usu�rio
    retList = CStr(lstOperador.ListIndex)
    retTxt = txtOperador.Text
    
    ' reseta UI
    txtOperador.Text = ""
    lblOperador.Visible = False
    txtOperador.Visible = False
    btnOk.Visible = False
    btnCancelar.Visible = False
    
    ' define variavel global como retorno do usu�rio
    If lstOperador.Visible Then
        retornoUI = retList
    Else
        retornoUI = retTxt
    End If
    lstOperador.Visible = False
    
    ' retoma a execu��o do fluxo de coleta
    continuaColeta = True
End Sub

' handle do bot�o ok
Private Sub btnOk_Click()
    OkEvent
End Sub

' handle da tecla enter em txt durante coleta
Private Sub txtOperador_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        OkEvent
    End If
End Sub

' ao criar form resetar UI
' e resetar vari�vel que controla o fluxo de coleta
Private Sub Form_Load()
    continuarColeta = False
    lblOperador.Visible = False
    txtOperador.Visible = False
    lstOperador.Visible = False
    btnCancelar.Visible = False
    btnOk.Visible = False
    imgQRCode.Visible = False
End Sub

' bot�o cancelar
Private Sub btnCancelar_Click()
    ' define a vari�vel global retornoUI = 0
    retornoUI = "0"
    
    ' reseta UI
    txtOperador.Text = ""
    lblOperador.Visible = False
    txtOperador.Visible = False
    btnOk.Visible = False
    btnCancelar.Visible = False
    lstOperador.Visible = False

    ' define variavel global cancelarColeta = 9 para que quando o fluxo da
    ' transa��o for retomado, a transa��o seja cancelada (na fun��o coleta)
    cancelarColeta = "9"
    continuaColeta = True
End Sub

' bot�o que inicia o fluxo de uma transa��o PIX
Private Sub btnIniciarPIX_Click()

    ' altera o estado da vari�vel global operacaoAtual para que na fun��o coleta
    ' a fun��o de opera��o PIX seja chamada
    operacaoAtual = Defines.OPERACAO_PIX
    
    ' antes de come�ar a trnasa��o, feedback visual para o usu�rio saber que
    ' a transa��o de opera��o PIX seja chamda
    lblOperador.Visible = True
    lblOperador.Caption = "AGUARDE..."
    
    btnIniciarTEF.Enabled = False
    btnIniciarADM.Enabled = False
    btnIniciarPIX.Enabled = False
    
    ' reseta o label do valor da transa��o
    valorTotal = lblValor.Text
    lblValor.Text = ""
    
    ' iniciafluxo respons�vel por iniciar a transa��o
    ElginTEF
    
    btnIniciarTEF.Enabled = True
    btnIniciarADM.Enabled = True
    btnIniciarPIX.Enabled = True
End Sub

' bot�o que inicia o fluxo de uma transa��o PIX
Private Sub btnIniciarTEF_Click()

    ' altera o estado da vari�vel global operacaoAtual para que na fun��o coleta
    ' a fun��o de opera��o PIX seja chamada
    operacaoAtual = Defines.OPERACAO_TEF
    
    ' antes de come�ar a trnasa��o, feedback visual para o usu�rio saber que
    ' a transa��o de opera��o PIX seja chamda
    lblOperador.Visible = True
    lblOperador.Caption = "AGUARDE..."
    
    btnIniciarTEF.Enabled = False
    btnIniciarADM.Enabled = False
    btnIniciarPIX.Enabled = False
    
    ' reseta o label do valor da transa��o
    valorTotal = lblValor.Text
    lblValor.Text = ""
    
    ' iniciafluxo respons�vel por iniciar a transa��o
    ElginTEF
    
    btnIniciarTEF.Enabled = True
    btnIniciarADM.Enabled = True
    btnIniciarPIX.Enabled = True
End Sub

' bot�o que inicia o fluxo de uma opera��o ADM
Private Sub btnIniciarADM_Click()

    ' altera o estado da vari�vel global operacaoAtual para que na fun��o coleta
    ' a fun��o de opera��o PIX seja chamada
    operacaoAtual = Defines.OPERACAO_ADM
    
    ' antes de come�ar a trnasa��o, feedback visual para o usu�rio saber que
    ' a transa��o de opera��o PIX seja chamda
    lblOperador.Visible = True
    lblOperador.Caption = "AGUARDE..."
    
    btnIniciarTEF.Enabled = False
    btnIniciarADM.Enabled = False
    btnIniciarPIX.Enabled = False
    
    ' iniciafluxo respons�vel por iniciar a transa��o
    ElginTEF
    
    btnIniciarTEF.Enabled = True
    btnIniciarADM.Enabled = True
    btnIniciarPIX.Enabled = True
End Sub

' fun��o usada na fase de coleta para mostrar elementos e escritas enviadas
' pela API em formato de String � Automa��o Comercial
Private Sub printTela(ByVal msg As String)
    ' reseta UI
    lstOperador.Visible = False
    txtOperador.Visible = False
    lblOperador.Visible = False
    btnOk.Visible = False
    btnCancelar.Visible = False
    imgQRCode.Visible = False
    
    ' QRCODE PIX
    ' caso esteja na fase de coleta de uma transa��o PIX, na String msg estar�
    ' presente o texto 'QRCODE', caso isso seja identificado, adentra o
    ' seguinte fluxo para mostrar o QRCode do pix na tela
    If InStr(msg, "QRCODE;") Then

        ' fun��o que gera a imagem do qrcode do pix
        ShowQRCode msg
        
        ' tornar elements vis�veis ao usu�rio
        imgQRCode.Visible = True
        ' btnOk.Visible = True
        ' btnCancelar.Visible = True
        
    ' caso n�o seja a coleta do pagamento do PIX, mas uma coleta de qualquer
    ' outra funcionalidade, pressoguir no seguinte fluxo
    Else
        ' definir o conte�do do lblOperador e torn�-lo vis�vel ao usu�rio
        lblOperador.Caption = msg
        lblOperador.Visible = True
        
        ' n�o mostra na tela nem os bot�es nem o txt ou durante processamento
        If Utils.MostrarBotoes(msg) Then
            txtOperador.Visible = True
            txtOperador.SetFocus
            btnOk.Visible = True
            btnCancelar.Visible = True
        End If
    End If
    DoEvents
End Sub

' Fun��o usada na fase de coleta para mostrar elementos e escritas enviadas
' pela API em formato de ListBox � Automa��o Comercial
Private Sub printTelaArray(elements() As String)
    Dim i As Long
    
    ' reseta UI
    lstOperador.Clear
    
    lstOperador.Visible = False
    txtOperador.Visible = False
    lblOperador.Visible = False
    btnOk.Visible = False
    btnCancelar.Visible = False
    imgQRCode.Visible = False
    
    lblOperador.Visible = True
    btnCancelar.Visible = True
    btnOk.Visible = True
    


    ' adiciona ao listOperador os elementos presentes no par�metro da fun��o
    For i = LBound(elements) To UBound(elements)
        lstOperador.AddItem (elements(i))
    Next i
    
    ' torna o lstOperador vis�vel ao usu�rio
    lstOperador.Visible = True
End Sub

' escreve logs em tela
Private Sub writeLogs(ByVal logs As String)
    txtLogs.Text = txtLogs & Defines.DIV_LOGS & logs
End Sub

' Fun��es PIX
' fun��o que recebe como argumento a string de retorno da dll no formato
' "QRCODE;[string Hexadecimal];[informa��es adicionais] uma String Hexadecimal
' representando um qrcode (no caso de transa��es PIX) e o mostra na UI
Public Sub ShowQRCode(qrCodeData As String)
    ' split the input string into its components
    Dim components() As String
    components = Split(qrCodeData, ";")
    
    ' extract the hex string from the component
    Dim hexString As String
    hexString = components(1)
    
    ' convert hex to byte array
    Dim imageBytes() As Byte
    imageBytes = HexToByteArray(hexString)
    
    ' save the byte array as a temporary file
    Dim tempFilePath As String
    tempFilePath = App.Path & "\temp_qrcode_image.bmp"
    SaveByteArrayAsBitmapFile imageBytes, tempFilePath
    
    ' load the image file into the image control
    Dim token As Long
    token = InitGDIPlus
    imgQRCode.Picture = LoadPictureGDIPlus(tempFilePath, imgQRCode.Width / 15, imgQRCode.Height / 15, vbWhite)
    FreeGDIPlus token
    
    Kill tempFilePath
End Sub


' ================================================
' =============== L�GICA DO TEF ==================
' ================================================

Private Sub ElginTEF()
    Dim start As String
    Dim retorno As String
    Dim sequencial As String
    Dim resp As String
    Dim comprovanteLoja As String
    Dim comprovanteCliente As String
    Dim cnf As String
    Dim endFinalizar As String
    
    ' (1) INICIAR CONEX�O COM CLIENT
    start = Iniciar
    
    ' faz o parse do retorno da fun��o iniciar
    retorno = GetRetorno(start)
    ' dependendo do resultado da fun��o iniciar definido na vari�vel "retorno" o
    ' fluxo poder� terminar ou continuar
    If retorno <> "1" Then
        Finalizar
        Exit Sub
    End If
    
    ' (2) REALIZAR OPERA��O

    ' define vari�vel "sequencial" a partir do retorno da fun��o "iniciar"
    ' e incrementa seu valor para ser enviado na pr�xima chamada � API
    sequencial = incrementarSequencial(GetSequencial(start))
    
    ' poss�veis chamadas a serem feitas
    ' resp = Vender(0, ...) -- Pgto --> Perguntar tipo do cart�o
    ' resp = Vender(1, ...) -- Pgto --> Cart�o de cr�dito
    ' resp = Vender(2, ...) -- Pgto --> Cart�o de d�bito
    ' resp = Vender(3, ...) -- Pgto --> Voucher (d�bito)
    ' resp = Vender(4, ...) -- Pgto --> Frota (d�bito)
    ' resp = Vender(5, ...) -- Pgto --> Private label (credito)
    ' resp = Vender(5, ...) -- Pgto --> Perguntar tipo do cart�o
        
    ' dependendo do estado da vari�vel "operacaoAtual" seguir com o fluxo da
    ' opera��o escolhida pelo usu�rio
    If operacaoAtual = Defines.OPERACAO_TEF Then
        resp = Vender(0, sequencial, Defines.OPERACAO_TEF)
    ElseIf operacaoAtual = Defines.OPERACAO_ADM Then
        resp = Adm(0, sequencial)
    Else
        resp = Vender(0, sequencial, Defines.OPERACAO_PIX)
    End If
    
    ' extrair a chave "retorno" do retorno da fun��o vender
    retorno = GetRetorno(resp)
    
    ' se a chave retorno n�o estiver presente, ou seja, for igual a "",
    ' continuar para o fluxo de coleta
    If retorno = "" Then
        resp = Coletar(operacaoAtual, Jsonify(resp))
        ' extrair a chave "retorno" do retorno da fun��o coleta
        retorno = GetRetorno(resp)
    End If
    
    ' (3) VERIFICAR RESULTADO / CONFIRMAR
    ' se a chave retorno n�o estiver presente no retorno da fun��o "coleta",
    ' finalizar opera��o com erro
    If retorno = "" Then
        writeLogs ("ERRO AO COLETAR DADOS")
        printTela ("ERROR AO COLETAR DADOS")

    ElseIf retorno = "0" Then
        ' extrair comprovantes das respectivas chaves no retorno da
        ' fun��o "coletar"
        comprovanteLoja = GetComprovante(resp, "loja")
        comprovanteCliente = GetComprovante(resp, "cliente")
        writeLogs (comprovanteLoja)
        writeLogs (comprovanteCliente)
        writeLogs ("TRANSA��O OK< INICIANDO CONFIRMA��O...")
        printTela ("TRANSA��O OK< INICIANDO CONFIRMA��O...")
        
        ' extrair valor da chave "sequencial" retornado pela fun��o "coleta"
        sequencial = GetSequencial(resp)
        
        ' confirma a opera��o por meio do sequencial utilizado
        cnf = confirmar(sequencial)
        
        ' extrair chave "retorno" do retorno da fun��o confirmar
        retorno = GetRetorno(cnf)
        
        ' se a chave retorno for vazia ou diferente de "1" finalizar
        If retorno <> "1" Then
            Finalizar
        End If
    ElseIf retorno = "1" Then
        writeLogs ("TRANSA��O OK")
        printTela ("TRANSA��O OK")
    Else
        writeLogs ("ERRO NA TRANSA��O")
        printTela ("ERRO NA TRANSA��O")
    End If
    
    ' (4) FINALIZA CONEX�O
    endFinalizar = Finalizar
    retorno = GetRetorno(endFinalizar)
    If retorno <> "1" Then
        Finalizar
        Exit Sub
    End If
End Sub

' ================================================
' ====== M�TODOS PARA CONTROLE DA TRANSA��O ======
' ================================================

Private Function Iniciar() As String
    Dim resultado As String
    Dim payload As JsonBag
    Set payload = New JsonBag
    
    ' poss�veis valores a serem adicionados ao payload, por�m n�o necess�rios
    ' se for escolhido usar os valores default definidos nas fun��es
    ' SetClientTCP e ConfigurarDadosPDV

    ' payload.Item("aplicacao") = "Meu PDV"
    ' payload.Item("aplicacao_tela") = "Meu PDV"
    ' payload.Item("versao") = "v1.0.0"
    ' payload.Item("estabelecimento") = "Elgin"
    ' payload.Item("loja") = "01"
    ' payload.Item("terminal") = "T004"
    ' payload.Item("nomeAC") = "Meu PDV"
    ' payload.Item("textoPinpad") = "Meu PDV"
    ' payload.Item("versaoAC") = "v1.0.0"
    ' payload.Item("nomeEstabelecimento") = "Elgin"
    ' payload.Item("identificadorPontoCaptura") = "T004"
    
    ' conforme a documenta��o:
    ' https://elgindevelopercommunity.github.io/group__tf.html#ga1bf9edea41af3c30936caf5ce7f8c988
    resultado = StrPtrToString(IniciarOperacaoTEF(Stringify(payload)))
    
    ' mostrar na UI o retorno da fun��o
    writeLogs ("INICIAR: " & Jsonify(resultado).JSON)
    
    ' libera a mem�ria ocupada pela inst�ncia de JsonBag
    Set payload = Nothing
    
    ' retorna a string retornada pela fun��o IniciarOperacaoTEF
    Iniciar = resultado
End Function

Private Function Vender(ByVal cartao As Integer, ByVal sequencial As String, ByVal operacao As Integer) As String
    Dim resultado As String ' string para armazenar os retornos da DLL
    Dim payload As JsonBag ' objecto JSON para armazenar os dados da transa��o

    Set payload = New JsonBag
    
    ' registra um log com o sequencial utilizado na venda
    writeLogs ("VENDER: " & "SEQUENCIAL USADO NA VENDA" & sequencial)
    
    ' adiciona o sequencial ao objeto payload
    payload.Item("sequencial") = sequencial
    
    ' verificar valorTotal
    If valorTotal <> "" Then
        payload.Item("valorTotal") = valorTotal
    End If
    
    If operacao = Defines.OPERACAO_TEF Then
        resultado = StrPtrToString(RealizarPagamentoTEF(CLng(cartao), Stringify(payload), True))
    Else
        resultado = StrPtrToString(RealizarPixTEF(Stringify(payload), True))
    End If
    
    ' logs
    writeLogs ("VENDER: " & Jsonify(resultado).JSON)
    
    Set payload = Nothing
    
    ' retorna resultado dll
    Vender = resultado
End Function

Private Function Adm(ByVal opcao As Integer, ByVal sequencial As String) As String
    Dim resultado As String
    Dim payload As JsonBag
    Set payload = New JsonBag
    
    ' logs
    writeLogs ("ADM: " & "SEQUENCIAL USADO NA VENDA" & sequencial)
    
    payload.Item("sequencial") = sequencial
    
    ' payload.Item("admUsuario") = ADM_USUARIO
    ' payload.Item("admSena") = ADM_SENHA
    resultado = StrPtrToString(RealizarAdmTEF(CLng(opcao), Stringify(payload), True))
    
    ' logs
    writeLogs ("ADM: " & Jsonify(resultado).JSON)
    
    Set payload = Nothing
    
    Adm = resultado
End Function

' COLETAR
' segue a l�gica de coleta explicada na documenta��o
' https://elgindevelopercommunity.github.io/group__t21.html
Private Function Coletar(ByVal operacao As Integer, ByVal root As JsonBag) As String
    ' chaves utilizadas na coleta
    Dim coletaRetorno As String ' In/Out; out: 0 = continuar coleta, 9 = cancelar coleta
    Dim coletaSequencial As String ' In/Out
    Dim coletaMensagem As String ' In/[Out]
    Dim coletaTipo As String ' In
    Dim coletaOpcao As String ' In
    Dim coletaMascara As String
    Dim coletaInformacao As String ' Out
    Dim payload As JsonBag
    Dim resp As String
    Dim retorno As String
    Dim opcoes() As String
    Dim elements() As String
    Dim i As Integer
    
    ' extrair dados da resposta / coleta
    coletaRetorno = GetStringValue(root, "tef", "automacao_coleta_retorno")
    coletaSequencial = GetStringValue(root, "tef", "automacao_coleta_sequencial")
    coletaMensagem = GetStringValue(root, "tef", "mensagemResultado")
    coletaTipo = GetStringValue(root, "tef", "automacao_coleta_tipo")
    coletaOpcao = GetStringValue(root, "tef", "automacao_coleta_opcao")
    coletaMascara = GetStringValue(root, "tef", "automacao_coleta_mascara")
    writeLogs ("COLETAR: " & UCase(coletaMensagem))
    printTela (UCase(coletaMensagem))
    
    ' em caso de erro, encerra coleta
    If coletaRetorno <> "0" Then
        Coletar = Stringify(root)
        Exit Function
    End If
    
    ' em caso de sucesso, monta o novo payload e continua a coleta
    Set payload = New JsonBag
    payload.Item("automacao_coleta_retorno") = coletaRetorno
    payload.Item("automacao_coleta_sequencial") = coletaSequencial
    
    ' COLETA DADOS DO USU�RIO
    ' se a chave coletaTipo n�o for vazia e a chave coletaOpcao for vazia
    ' quer dizer que a API est� pedindo por um valor que o usu�rio
    ' precisa digitar
    If coletaTipo <> "" Then
        If coletaOpcao = "" Then
            writeLogs ("INFORME O VALOR SOLICITADO: ")
            coletaInformacao = ReadInput

            ' adicionano payload valor digitado pelo usu�rio
            payload.Item("automacao_coleta_informacao") = coletaInformacao

        ' se a chave coletaTipo n�o for vazia e a chave coletaOpcao tamb�m n�o for
        ' vazia quer dizer que a API est� pedindo por um valor que o usu�rio
        ' precisa escolher dentre algumas op��es
        ElseIf coletaOpcao <> "" Then
            opcoes = Split(coletaOpcao, ";")
            ReDim elements(UBound(opcoes))
            
            For i = 0 To UBound(opcoes)
                elements(i) = "[" & i & "] " & UCase(opcoes(i)) & vbCrLf
                writeLogs ("[" & i & "] " & UCase(opcoes(i)) & vbCrLf)
            Next i
            
            ' mostra na UI a lista de op��es para que o usu�rio selecione
            printTelaArray elements
            writeLogs (vbCrLf & "SELECIONE A OP��O DESEJADA: ")
            
            Dim read As String
            read = ReadInput
            ' espera o input do usu�rio para contrinuar o fluxo. Fun��o readInput
            ' ir� retornar o index do array da op��o escolhida
            coletaInformacao = opcoes(CInt(read))

            ' adicionano payload valor digitado pelo usu�rio
            payload.Item("automacao_coleta_informacao") = coletaInformacao
        End If
        
        ' verifica vari�vel global "cancelarColeta"
        ' se houve cancelamento do usu�rio, adiciona a chave com cancelamento
        ' para avisar a DLL
        If cancelarColeta <> "" Then
            payload.Item("automacao_coleta_retorno") = cancelarColeta
            cancelarColeta = ""
        End If
    End If
    
    ' informa dados coletados
    If operacao = Defines.OPERACAO_ADM Then
        resp = StrPtrToString(RealizarAdmTEF(0, Stringify(payload), False))
    ElseIf operacao = Defines.OPERACAO_TEF Then
        resp = StrPtrToString(RealizarPagamentoTEF(0, Stringify(payload), False))
    Else
        resp = StrPtrToString(RealizarPixTEF(Stringify(payload), False))
    End If
    
    ' libera mem�ria ocupada pela instancia jsonbag
    Set payload = Nothing
    
    writeLogs (Jsonify(resp).JSON)
    
    ' verificar fim da coleta
    retorno = GetRetorno(resp)
    If retorno <> "" Then
        Coletar = resp
        Exit Function
    End If
    
    ' passa para pr�xima fase da coleta chamando novamente a fun��o at�
    ' que a coleta seja finalizada
    Coletar = Coletar(operacao, Jsonify(resp))
End Function

' fun��o que confirma transa��o realizada
Private Function confirmar(ByVal sequencial As String) As String
    Dim resultado As String
    
    writeLogs ("CONFIRMAR: " & "SEQUENCIAL DA OPERA��O A SER CONFIRMADA: ")
    printTela ("AGUARDE, CONFIRMANDO OPERA��O...")
    
    resultado = StrPtrToString(ConfirmarOperacaoTEF(CLng(sequencial), 1))
    writeLogs ("CONFIRMAR: " & Jsonify(resultado).JSON)
    confirmar = resultado
End Function

Private Function Finalizar() As String
    Dim resultado As String
    
    resultado = StrPtrToString(FinalizarOperacaoTEF(1))
    writeLogs ("FINALIZAR: " & Jsonify(resultado).JSON)
    valorTotal = ""
    printTela ("OPERA��O FINALIZADA")
    Finalizar = resultado
End Function

' fun��o chamada quando necess�rio pegar algum retorno do usu�rio
' "pausa" a execu��o do programa at� o usu�rio informar o dado pedido
' na UI
Private Function ReadInput() As String
    Do While Not continuaColeta
        DoEvents
    Loop
    continuaColeta = False
    ReadInput = retornoUI
End Function
