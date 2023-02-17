unit FormPagamento;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Utils, FuncoesDLL, System.JSON, StrUtils, PngImage;
//
// Aplicativo Exemplo para E1_Tef Api, versão Delphi VCL
// Gabriel Franzeri @ Elgin, 2022
//
type
  TfrmPagamento = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Label2: TLabel;
    lblValor: TLabel;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    btn7: TButton;
    btn8: TButton;
    btn9: TButton;
    btnBS: TButton;
    btn0: TButton;
    btnClear: TButton;
    GroupBox2: TGroupBox;
    btnOK: TButton;
    btnCanc: TButton;
    GroupBox3: TGroupBox;
    memoLogs: TMemo;
    lblOperador: TLabel;
    txtOperador: TEdit;
    listOperador: TListBox;
    btnIniciarOperacaoTEF: TButton;
    btnIniciarOperacaoPIX: TButton;
    imgQrcode: TImage;

    // PROTOTYPES
    // Métodos para o controle da transação (E1_Tef)
    procedure TesteApiElginTEF;
    function iniciar():String;
    function vender(cartao:Integer; sequencial:String; operacao:Integer):String;
    function adm(opcao:Integer; sequencial:String):String;
    function coletar(operacao:Integer; root:TJsonObject):String;
    function confirmar(sequencial:String):String;
    function finalizar():String;

    // Métodos utilitários
    function readInput():String;
    procedure writeLogs(logs:String);
    procedure print(msg:String);
    procedure printArray(elements : TStringList);
    procedure printArrayThread(elements : TStringList);

    // Métodos UI
    procedure btnClearClick(Sender: TObject);
    procedure btnGenericClick(Sender: TObject);
    procedure btnBSClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancClick(Sender: TObject);
    procedure btnIniciarOperacaoTEFClick(Sender: TObject);
    procedure txtOperadorKeyPress(Sender: TObject; var Key: Char);
    procedure btnIniciarOperacaoPIXClick(Sender: TObject);
    procedure displayQRCode(hexString: string);
  private
    { Private declarations }
  public
    { Public declarations }
    myThread : TThread;
    caso:Integer;
    retornoUI:String;
    valorTotal:String;
    cancelarColeta:String;
    operacaoAtual: Integer;
    const OPERACAO_TEF = 0;
    const OPERACAO_ADM = 1;
    const OPERACAO_PIX = 2;
  end;
var
  frmPagamento: TfrmPagamento;
implementation

const
  OPERACAO_VENDER = 0;
  OPERACAO_ADM = 1;

{$R *.dfm}

procedure TfrmPagamento.txtOperadorKeyPress(Sender: TObject; var Key: Char);
var
  retList : String;
  retTxt : String;
begin
if Key = #13 then
begin
  // mesmo código do btnOKClick
  retornoUI := '';
  if (listOperador.ItemIndex = -1) and (listOperador.Visible) then begin
      ShowMessage('Escolha uma opção');
    exit;
  end;
  if (txtOperador.Text = '') and (txtOperador.Visible) then begin
    ShowMessage('Escreva o valor pedido');
    exit;
  end;
  retList := IntToStr(listOperador.ItemIndex);
  retTxt := txtOperador.Text;
  txtOperador.Text := '';
  lblOperador.Visible := false;
  txtOperador.Visible := false;
  btnOK.Visible := false;
  btnCanc.Visible := false;

  if listOperador.Visible then begin
    retornoUI := retList;
  end else begin
    retornoUI := retTxt;
  end;
  listOperador.Visible := false;
  myThread.Resume;
end;
end;

procedure TfrmPagamento.btnOKClick(Sender: TObject);
var
  retList : String;
  retTxt : String;
begin
  retornoUI := '';
  if (listOperador.ItemIndex = -1) and (listOperador.Visible) then begin
      ShowMessage('Escolha uma opção');
    exit;
  end;
  if (txtOperador.Text = '') and (txtOperador.Visible) then begin
    ShowMessage('Escreva o valor pedido');
    exit;
  end;
  retList := IntToStr(listOperador.ItemIndex);
  retTxt := txtOperador.Text;
  txtOperador.Text := '';
  lblOperador.Visible := false;
  txtOperador.Visible := false;
  btnOK.Visible := false;
  btnCanc.Visible := false;
  imgQrcode.Visible := false;

  if listOperador.Visible then begin
    retornoUI := retList;
  end else begin
    retornoUI := retTxt;
  end;
  listOperador.Visible := false;
  myThread.Resume;
end;

procedure TfrmPagamento.btnCancClick(Sender: TObject);
begin
  retornoUI := '0';
  cancelarColeta := '9';
  myThread.Resume;
end;

procedure TfrmPagamento.btnIniciarOperacaoPIXClick(Sender: TObject);
begin

  operacaoAtual := OPERACAO_PIX;

  lblOperador.Visible := true;
  lblOperador.Caption := 'AGUARDE...';

  lblValor.Caption := '';

  //INSTANCIA THREAD RESPONSAVEL POR INICIAR A TRANSAÇÃO
  //NESSE EXEMPLO A TRANSAÇÃO É FEITA EM UMA THREAD PARA NÃO OCORRER CONGELAMENTO
  //DA TELA PRINCIPAL
  myThread := TThread.CreateAnonymousThread(
    procedure
      begin
        try
          TesteApiElginTEF;
        except
        on E : Exception do
        begin
          writeLogs('Exception [nome da classe]: '+ E.ClassName +
                #13#10 + 'Exception [mensagem]: '+E.Message +
                #13#10 + 'PILHA: ' + E.StackTrace);
          end;
        end;
      end
  );
  myThread.start();
end;

procedure TfrmPagamento.btnIniciarOperacaoTEFClick(Sender: TObject);
begin
  operacaoAtual := OPERACAO_TEF;

  lblOperador.Visible := true;
  lblOperador.Caption := 'AGUARDE...';

  lblValor.Caption := '';

  //INSTANCIA THREAD RESPONSAVEL POR INICIAR A TRANSAÇÃO
  //NESSE EXEMPLO A TRANSAÇÃO É FEITA EM UMA THREAD PARA NÃO OCORRER CONGELAMENTO
  //DA TELA PRINCIPAL
  myThread := TThread.CreateAnonymousThread(
    procedure
      begin
        try
          TesteApiElginTEF;
        except
        on E : Exception do
        begin
          writeLogs('Exception [nome da classe]: '+ E.ClassName +
                #13#10 + 'Exception [mensagem]: '+E.Message +
                #13#10 + 'PILHA: ' + E.StackTrace);
          end;
        end;
      end
  );
  myThread.start();
end;

procedure TfrmPagamento.btnBSClick(Sender: TObject);
begin
  if text <> '' then begin
    valorTotal := valorTotal.Substring(0, valorTotal.Length - 1);
    lblValor.Caption := FormatNumber(valorTotal);
  end
end;

procedure TfrmPagamento.btnGenericClick(Sender: TObject);
begin
  if Length(lblValor.Caption) < 6 then
  begin
    if lblValor.Caption <> '0' then begin
      valorTotal := valorTotal + (Sender as TButton).Caption;
      lblValor.Caption := FormatNumber(valorTotal);
    end
    else
      lblValor.Caption := (Sender as TButton).Caption;
  end;
end;

procedure TfrmPagamento.btnClearClick(Sender: TObject);
begin
  valorTotal := '';
  lblValor.Caption := FormatNumber(valorTotal);
end;

procedure TfrmPagamento.print(msg:String);
var
  hexString: String;
begin
  TThread.Synchronize(nil, procedure
  begin
    listOperador.Visible := false;
    txtOperador.Visible := false;
    lblOperador.Visible := false;
    btnOK.Visible := false;
    btnCanc.Visible := false;
    imgQrcode.Visible := false;

    // QRCODE PIX
    if Pos('QRCODE;', msg) <> 0 then begin
      hexString := ExtractTextBetween(msg, ';', ';');

      displayQRCode(hexString);

      imgqrcode.Visible := true;
      btnOk.Visible := true;
      btnCanc.Visible := true;

    end else begin

      lblOperador.Caption := msg;
      lblOperador.Visible := true;

      // não mostra na tela nem os botões nem o TEdit durante processamentos
      if Utils.naoContem(msg) then begin
        txtOperador.Visible := true;
        txtOperador.SetFocus;
        btnOK.Visible := true;
        btnCanc.Visible := true
      end;
    end
  end
  );
end;

procedure TfrmPagamento.printArray(elements : TStringList);
begin
  TThread.Synchronize(nil, procedure
    begin
      printArrayThread(elements);
    end
  );
end;

procedure TfrmPagamento.printArrayThread(elements : TStringList);
var
  element : String;
begin
      listOperador.Clear;

      listOperador.Visible := false;
      txtOperador.Visible := false;
      lblOperador.Visible := false;
      btnOK.Visible := false;
      btnCanc.Visible := false;
      imgQrcode.Visible := false;

      lblOperador.Visible := true;
      btnCanc.Visible := true;
      btnOK.Visible := true;

      for element in elements do
        listOperador.Items.Add(element);
      listOperador.Visible := true;
end;

procedure TfrmPagamento.displayQRCode(hexString: string);
var
  pngImage: TPngImage;
  stream: TMemoryStream;
begin

  imgQrcode.Picture.Assign(nil);

  stream := TMemoryStream.Create;
  try
    stream.size := Length(hexString) div 2;
    if stream.Size > 0 then begin
      HexToBin(PChar(hexString), stream.Memory, stream.Size);
      pngImage := TPngImage.Create;
      try
        pngImage.LoadFromStream(stream);
        imgQrcode.Picture.Assign(pngImage);
      finally
        pngImage.Free;
      end;
    end;
  finally
    stream.Free;
  end;
  end;

procedure TfrmPagamento.writeLogs(logs:String);
var
  divLogs : String;
begin
  TThread.Synchronize(nil, procedure
    begin
      divLogs := #13#10 + '==============================================' + #13#10;
      memoLogs.Lines.Add(divLogs + logs);
    end
  );
end;

// ===================================================================== //
// ============================ LÓGICA DO TEF ========================== //
// ===================================================================== //
// =============================== TESTES ============================== //
// ===================================================================== //
procedure TfrmPagamento.TesteApiElginTEF;
var
  start : String;
  retorno : String;
  sequencial : String;
  resp : String;
  comprovanteLoja : String;
  comprovanteCliente : String;
  cnf : String;
  endFinalizar : String;
begin
  FuncoesDLL.SetClientTCP('127.0.0.1', 60906);
  FuncoesDLL.ConfigurarDadosPDV('ApiTEFElgin Delphi', 'v1.0.000', 'Elgin', '01', 'T0004');
  // 1) INICIAR CONEXÃO COM CLIENT
  start := iniciar();
  retorno := Utils.getRetorno(start);
  if (retorno = '') or (retorno <> '1') then begin
      finalizar();
      exit;
    end;
  // 2) REALIZAR OPERACAO
  sequencial := Utils.getSequencial(start);
  sequencial := Utils.incrementarSequencial(sequencial);
                
  // resp := vender(0, sequencial);   // Pgto --> Perguntar tipo do cartao
  // resp := vender(1, sequencial);   // Pgto --> Cartao de credito
  // resp := vender(2, sequencial);   // Pgto --> Cartao de debito
  // resp := vender(3, sequencial);   // Pgto --> Voucher (debito)
  // resp := vender(4, sequencial);   // Pgto --> Frota (debito)
  // resp := vender(5, sequencial);   // Pgto --> Private label (credito)
  // resp := adm(0, sequencial);      // Adm  --> Perguntar operacao
  // resp := adm(1, sequencial);      // Adm  --> Cancelamento
  // resp := adm(2, sequencial);      // Adm  --> Pendencias
  // resp := adm(3, sequencial);      // Adm  --> Reimpressao

  // POR SER A JANELA DE PAGAMENTO, USAR A FUNÇÃO VENDER
  if operacaoAtual = OPERACAO_TEF then
    resp := vender(0, sequencial, OPERACAO_TEF)
  else
    resp := vender(0, sequencial, OPERACAO_PIX);

  retorno := Utils.getRetorno(resp);
  if retorno = '' then
  // Continuar operacao/iniciar o processo de coleta
    begin
      // 0 para coletar vendas, 1 para coletar adm
      resp := coletar(OPERACAO_VENDER, Utils.jsonify(resp));
      retorno := Utils.getRetorno(resp);
    end;
  // 3) VERIFICAR RESULTADO / CONFIRMAR
  if retorno = '' then
    begin
      writeLogs('ERRO AO COLETAR DADOS');
      print('ERRO AO COLETAR DADOS');
    end
  else if retorno = '0' then
   begin
    comprovanteLoja := Utils.getComprovante(resp, 'loja');
    comprovanteCliente := Utils.getComprovante(resp, 'cliente');
    writeLogs(comprovanteLoja);
    writeLogs(comprovanteCliente);
    writeLogs('TRANSAÇÃO OK, INICIANDO CONFIRMAÇÃO...');
    print('TRANSAÇÃO OK, INICIANDO CONFIRMAÇÃO...');
    sequencial := Utils.getSequencial(resp);
    // confirma a operação por meio do sequencial utilizado
    cnf := confirmar(sequencial);
    retorno := Utils.getRetorno(cnf);
    if (retorno = '') or (retorno <> '1') then
      finalizar();
   end
  else if retorno = '1' then
    begin
      writeLogs('TRANSAÇÃO OK');
      print('TRANSAÇÃO OK');
    end
  else 
    begin
      writeLogs('ERRO NA TRANSAÇÃO');
      print('ERRO NA TRANSAÇÃO');
    end;
  // 4) FINALIZAR CONEXAO
  endFinalizar := finalizar();
  retorno := Utils.getRetorno(endFinalizar);
  if (retorno = '') or (retorno <> '1') then
    finalizar();
    exit;
end;
// ===================================================================== //
// ============ MÉTODOS PARA O CONTROLE DA TRANSAÇÃO (E1_TEF) ========== //
// ===================================================================== //
function TfrmPagamento.iniciar():String;
var
  payload : TJsonObject;
  resultado : UTF8String;
begin
  payload := TJsonObject.Create;
  // payload.Add("aplicacao",         "Meu PDV");
  // payload.Add("aplicacao_tela",    "Meu PDV");
  // payload.Add("versao",            "v0.0.001");
  // payload.Add("estabelecimento",   "Elgin");
  // payload.Add("loja",              "01");
  // payload.Add("terminal",          "T0004");
  // payload.Add("nomeAC",                        "Meu PDV");
  // payload.Add("textoPinpad",                   "Meu PDV");
  // payload.Add("versaoAC",                      "v0.0.001");
  // payload.Add("nomeEstabelecimento",           "Elgin");
  // payload.Add("loja",                          "01");
  // payload.Add("identificadorPontoCaptura",     "T0004");

  resultado := IniciarOperacaoTEF(Utils.stringify(payload));
  writeLogs('INICIAR: ' + Utils.jsonify(UTF8ToString(resultado)).Format(2));
  FreeAndNil(payload);
  result := UTF8ToString(resultado);
end;

function TfrmPagamento.vender(cartao:Integer; sequencial:String; operacao:Integer):String;
var
  payload : TJsonObject;
  resultado : UTF8String;
begin 
  payload := TJsonObject.Create;
  writeLogs('VENDER: ' + ' SEQUENCIAL UTILIZADO NA VENDA: ' + sequencial);
  payload.AddPair('sequencial', sequencial);
  if valorTotal <> '' then
    begin
      valorTotal := RemoveNonNumericChars(valorTotal);
      payload.AddPair('valorTotal', valorTotal);
    end;

  if operacao = OPERACAO_TEF then
    resultado := FuncoesDLL.RealizarPagamentoTEF(cartao, Utils.stringify(payload), True)
  else
    resultado := FuncoesDLL.RealizarPixTEF(Utils.stringify(payload), True);

  writeLogs('VENDER: ' + Utils.jsonify(UTF8ToString(resultado)).Format(2));
  FreeAndNil(payload);
  result := UTF8ToString(resultado);
end;

function TfrmPagamento.adm(opcao:Integer; sequencial:String):String;
var
  payload : TJsonObject;
  resultado : UTF8String;
begin
  payload := TJsonObject.Create;
  writeLogs('ADM: ' + ' SEQUENCIAL UTILIZADO NA VENDA: ' + sequencial);
  payload.AddPair('sequencial', sequencial);
  // payload.Add("transacao_administracao_usuario", ADM_USUARIO);
  // payload.Add("transacao_administracao_senha",   ADM_SENHA);
  // payload.Add("admUsuario",                      ADM_USUARIO);
  // payload.Add("admSenha",                        ADM_SENHA);
  resultado := FuncoesDLL.RealizarAdmTEF(opcao, Utils.stringify(payload), True);
  writeLogs('ADM: ' + Utils.jsonify(UTF8ToString(resultado)).Format(2));
  FreeAndNil(payload);
  result := UTF8ToString(resultado);
end;

// COLETAR
function TfrmPagamento.coletar(operacao:Integer; root:TJsonObject):String;
var
  // chaves utilizadas na coleta
  coletaRetorno,      // In/Out; out: 0 = continuar coleta, 9 = cancelar coleta
  coletaSequencial,   // In/Out
  coletaMensagem,     // In/[Out]
  coletaTipo,         // In
  coletaOpcao,        // In
  coletaMascara,
  coletaInformacao : String;   // Out
  payload : TJsonObject;
  resp : UTF8String;
  retorno : String;
  opcoes : TStringList;
  elements : TStringList;
  i : Integer;
begin
  // extrai os dados da resposta / coleta
  coletaRetorno       := Utils.getStringValue(root, 'tef.automacao_coleta_retorno');
  coletaSequencial    := Utils.getStringValue(root, 'tef.automacao_coleta_sequencial');
  coletaMensagem      := Utils.getStringValue(root, 'tef.mensagemResultado');
  coletaTipo          := Utils.getStringValue(root, 'tef.automacao_coleta_tipo');
  coletaOpcao         := Utils.getStringValue(root, 'tef.automacao_coleta_opcao');
  coletaMascara       := Utils.getStringValue(root, 'tef.automacao_coleta_mascara');
  writeLogs('COLETAR: ' +  UpperCase(coletaMensagem));
  print(UpperCase(coletaMensagem));

  // em caso de erro, encerra coleta
  if coletaRetorno <> '0' then begin
    result := Utils.stringify(root);
    exit;
  end;

  // em caso de sucesso, monta o (novo) payload e continua a coleta
  payload := TJsonObject.Create;
  payload.AddPair('automacao_coleta_retorno', coletaRetorno);
  payload.AddPair('automacao_coleta_sequencial', coletaSequencial);

  // coleta dados do usuário
  if (coletaTipo <> '') and (coletaOpcao = '') then begin // valor inserido (texto)
    writeLogs('INFORME O VALOR SOLICITADO: ');
    coletaInformacao := readInput();

    // se houve cancelamento, adiciona a chave com cancelamento para avisar a dll
    if (cancelarColeta <> '') then begin
      payload.RemovePair('automacao_coleta_retorno');
      payload.AddPair('automacao_coleta_retorno', cancelarColeta);
      cancelarColeta := '';
    end;
    
    payload.AddPair('automacao_coleta_informacao', coletaInformacao);
  end
  else if (coletaTipo <> '') and (coletaOpcao <> '') then begin // valor selecionado (lista)
    opcoes := TStringList.Create;
    elements := TStringList.Create;
    Utils.Split(';', coletaOpcao, opcoes);
    for i := 0 to opcoes.Count - 1 do
    begin
      elements.Add('[' + IntToStr(i) + ']' + UpperCase(opcoes[i]) + #13#10);
    end;
    for i := 0 to opcoes.Count - 1 do
    begin
      writeLogs('[' + IntToStr(i) + '] ' + UpperCase(opcoes[i]) + #13#10)
    end;
    printArray(elements);
    writeLogs(#13#10 + 'DIGITE A OPÇÂO DESEJADA: ');
    coletaInformacao := opcoes[strtoint(readInput())];
    // se houve cancelamento, adiciona a chave com cancelamento para avisar a dll
    if (cancelarColeta <> '') then begin
      payload.RemovePair('automacao_coleta_retorno');
      payload.AddPair('automacao_coleta_retorno', cancelarColeta);
      cancelarColeta := '';
    end;
    payload.AddPair('automacao_coleta_informacao', coletaInformacao);
    FreeAndNil(elements);
  end;

  // informa os dados coletados
  if operacao = 1 then begin
    resp := FuncoesDLL.RealizarAdmTEF(0, Utils.stringify(payload), false);
  end
  else begin
    if operacaoAtual = OPERACAO_PIX then
      resp := FuncoesDLL.RealizarPixTEF(Utils.stringify(payload), false)
    else
      resp := FuncoesDLL.RealizarPagamentoTEF(0, Utils.stringify(payload), false)
  end;

  FreeAndNil(payload);

  writeLogs(Utils.jsonify(UTF8ToString(resp)).Format(2));

  // verifica fim da coleta
  retorno := Utils.getRetorno(UTF8ToString(resp));
  if retorno <> '' then begin
    result := UTF8ToString(resp);
    exit;
  end;
  result := coletar(operacao, Utils.jsonify(UTF8ToString(resp)));
end;

function TfrmPagamento.confirmar(sequencial:String):String;
var
  resultado : UTF8String;
begin
  writeLogs('CONFIRMAR: ' + 'SEQUENCIAL DA OPERAÇÃO A SER CONFIRMADA: ');
  print('AGUARDE, CONFIRMANDO OPERAÇÃO...');
 
  resultado := FuncoesDLL.ConfirmarOperacaoTEF(strtoint(sequencial), 1);
  writeLogs('CONFIRMAR: ' + Utils.jsonify(UTF8ToString(resultado)).Format(2));
  result := UTF8ToString(resultado);
end;

function TfrmPagamento.finalizar():String;
var
  resultado : UTF8String;
begin
  resultado := FuncoesDLL.FinalizarOperacaoTEF(1); // api resolve o sequencial
  writeLogs('Finalizar: ' + Utils.jsonify(UTF8ToString(resultado)).Format(2));
  valorTotal := '';
  print('OPERAÇÃO FINALIZADA');
  result := UTF8ToString(resultado);
end;

function TfrmPagamento.readInput():String;
begin
  myThread.Suspended := true; //PAUSA A THREAD AGUARDANDO A ENTRADA DO USUARIO...
  result := retornoUI;
end;

end.
