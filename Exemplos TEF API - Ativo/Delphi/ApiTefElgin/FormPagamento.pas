unit FormPagamento;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, FuncoesDLL, System.JSON, StrUtils;
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
    btnIniciarOperacao: TButton;

    // PROTOTYPES
    // Métodos para o controle da transação (E1_Tef)
    procedure TesteApiElginTEF;
    function iniciar():String;
    function vender(cartao:Integer; sequencial:String):String;
    function adm(opcao:Integer; sequencial:String):String;
    function coletar(operacao:Integer; root:TJsonObject):String;
    function confirmar(sequencial:String):String;
    function finalizar():String;

    // Métodos utilitários
    function incrementarSequencial(sequencial:String):String;
    function getRetorno(resp:String):String;
    function getComprovante(resp:String; via:String):String;
    function getSequencial(resp:String):String;
    function jsonify(jsonString:String):TJsonObject;
    function stringify(json:TJsonObject):PAnsiChar;
    function getStringValue(json:TJsonObject; key:String):String;
    function readInput():String;
    function naoContem(msg: String): Boolean;
    procedure writeLogs(logs:String);
    procedure print(msg:String);
    procedure printArray(elements : TStringList);
    procedure printArrayThread(elements : TStringList);
    procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;

    // Métodos UI
    procedure btnClearClick(Sender: TObject);
    procedure btnGenericClick(Sender: TObject);
    procedure btnBSClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancClick(Sender: TObject);
    procedure btnIniciarOperacaoClick(Sender: TObject);
    procedure txtOperadorKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    myThread : TThread;
    caso:Integer;
    retornoUI:String;
    valorTotal:String;
    cancelarColeta:String;
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
  cancelarColeta := '9';
  myThread.Resume;
end;

procedure TfrmPagamento.btnIniciarOperacaoClick(Sender: TObject);
begin

  lblOperador.Visible := true;
  lblOperador.Caption := 'AGUARDE...';

  if lblValor.Caption <> '' then begin
    valorTotal := lblValor.Caption + '00';
  end;

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
var
  text : String;
begin
  text := lblValor.Caption;
  if text <> '' then
    lblValor.Caption := text.Substring(0, text.Length - 1);
end;

procedure TfrmPagamento.btnGenericClick(Sender: TObject);
begin
  if Length(lblValor.Caption) < 6 then
  begin
    if lblValor.Caption <> '0' then
      lblValor.Caption := lblvalor.Caption + (Sender as TButton).Caption
    else
      lblValor.Caption := (Sender as TButton).Caption;
  end;
end;

procedure TfrmPagamento.btnClearClick(Sender: TObject);
begin
  lblValor.Caption := '';
end;

procedure TfrmPagamento.print(msg:String);
begin
  TThread.Synchronize(nil, procedure
  begin
    listOperador.Visible := false;
    txtOperador.Visible := false;
    Label2.Visible := false;
    btnOK.Visible := false;
    btnCanc.Visible := false;
    lblOperador.Caption := msg;
    lblOperador.Visible := true;
    // não mostra na tela nem os botões nem o TEdit durante processamentos
    if naoContem(msg) then begin
      txtOperador.Visible := true;
      txtOperador.SetFocus;
      btnOK.Visible := true;
      btnCanc.Visible := true;
    end;
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
      Label2.Visible := false;
      btnOK.Visible := false;
      btnCanc.Visible := false;
      lblOperador.Visible := true;
      btnOK.Visible := true;
      for element in elements do
        listOperador.Items.Add(element);
      listOperador.Visible := true;
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
  ret : String;
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
  retorno := getRetorno(start);
  if (retorno = '') or (retorno <> '1') then begin
      finalizar();
      exit;
    end;
  // 2) REALIZAR OPERACAO
  sequencial := getSequencial(start);
  sequencial := incrementarSequencial(sequencial);
                
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
  resp := vender(0, sequencial);
  retorno := getRetorno(resp);
  if retorno = '' then
  // Continuar operacao/iniciar o processo de coleta
    begin
      // 0 para coletar vendas, 1 para coletar adm
      resp := coletar(OPERACAO_VENDER, jsonify(resp));
      retorno := getRetorno(resp);
    end;
  // 3) VERIFICAR RESULTADO / CONFIRMAR
  if retorno = '' then
    begin
      writeLogs('ERRO AO COLETAR DADOS');
      print('ERRO AO COLETAR DADOS');
    end
  else if retorno = '0' then
   begin
    comprovanteLoja := getComprovante(resp, 'loja');
    comprovanteCliente := getComprovante(resp, 'cliente');
    writeLogs(comprovanteLoja);
    writeLogs(comprovanteCliente);
    writeLogs('TRANSAÇÃO OK, INICIANDO CONFIRMAÇÃO...');
    print('TRANSAÇÃO OK, INICIANDO CONFIRMAÇÃO...');
    sequencial := getSequencial(resp);
    // confirma a operação por meio do sequencial utilizado
    cnf := confirmar(sequencial);
    retorno := getRetorno(cnf);
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
  retorno := getRetorno(endFinalizar);
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
  retp : String;
  reta : AnsiString;
  ret : PAnsiChar;
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

  resultado := IniciarOperacaoTEF(stringify(payload));
  writeLogs('INICIAR: ' + jsonify(resultado).Format(2));
  result := resultado;
end;

function TfrmPagamento.vender(cartao:Integer; sequencial:String):String;
var
  payload : TJsonObject;
  resultado : UTF8String;
begin 
  payload := TJsonObject.Create;
  writeLogs('VENDER: ' + ' SEQUENCIAL UTILIZADO NA VENDA: ' + sequencial);
  payload.AddPair('sequencial', sequencial);
  if valorTotal <> '' then
    begin
      // tira sujeira da string
      payload.AddPair('valorTotal', valorTotal);
    end;
  
  resultado := FuncoesDLL.RealizarPagamentoTEF(cartao, stringify(payload), True);
  writeLogs('VENDER: ' + jsonify(resultado).Format(2));
  result := resultado;
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
  resultado := FuncoesDLL.RealizarAdmTEF(opcao, stringify(payload), True);
  writeLogs('ADM: ' + jsonify(resultado).Format(2));
  result := resultado;
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
  coletaInformacao : String;   // Out
  payload : TJsonObject;
  resp : UTF8String;
  retorno : String;
  opcoes : TStringList;
  elements : TStringList;
  i : Integer;
begin
  // extrai os dados da resposta / coleta
  coletaRetorno       := getStringValue(root, 'tef.automacao_coleta_retorno');
  coletaSequencial    := getStringValue(root, 'tef.automacao_coleta_sequencial');
  coletaMensagem      := getStringValue(root, 'tef.mensagemResultado');
  coletaTipo          := getStringValue(root, 'tef.automacao_coleta_tipo');
  coletaOpcao         := getStringValue(root, 'tef.automacao_coleta_opcao');
  writeLogs('COLETAR: ' +  UpperCase(coletaMensagem));
  print(UpperCase(coletaMensagem));
  // em caso de erro, encerra coleta
  if coletaRetorno <> '0' then begin
    result := stringify(root);
  end;
  
  // em caso de sucesso, monta o (novo) payload e continua a coleta
  payload := TJsonObject.Create;
  payload.AddPair('automacao_coleta_retorno', coletaRetorno);
  payload.AddPair('automacao_coleta_sequencial', coletaSequencial);
  // coleta dados do usuário
  if (coletaTipo <> '') and (coletaOpcao = '') then begin // valor inserido (texto)
    writeLogs('INFORME O VALOR SOLICITADO: ');
    coletaInformacao := readInput();
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
    Split(';', coletaOpcao, opcoes);
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
    payload.AddPair('automacao_coleta_informacao', coletaInformacao);
    elements := nil;
  end;
  // informa od dados coletados
  if operacao = 1 then begin
    resp := FuncoesDLL.RealizarAdmTEF(0, stringify(payload), false);
  end
  else begin
    resp := FuncoesDLL.RealizarPagamentoTEF(0, stringify(payload), false);
  end;

  writeLogs(jsonify(resp).Format(2));
  // verifica fim da coleta
  retorno := getRetorno(resp);
  if retorno <> '' then begin
    result := resp;
    exit;
  end;
  result := coletar(operacao, jsonify(resp));
end;

function TfrmPagamento.confirmar(sequencial:String):String;
var
  resultado : UTF8String;
begin
  writeLogs('CONFIRMAR: ' + 'SEQUENCIAL DA OPERAÇÃO A SER CONFIRMADA: ');
  print('AGUARDE, CONFIRMANDO OPERAÇÃO...');
 
  resultado := FuncoesDLL.ConfirmarOperacaoTEF(strtoint(sequencial), 1);
  writeLogs('CONFIRMAR: ' + jsonify(resultado).Format(2));
  result := resultado;
end;
 
function TfrmPagamento.finalizar():String;
var
  resultado : UTF8String;
begin
  resultado := FuncoesDLL.FinalizarOperacaoTEF(1); // api resolve o sequencial
  writeLogs('Finalizar: ' + jsonify(resultado).Format(2));
  valorTotal := '';
  print('OPERAÇÃO FINALIZADA');
  result := resultado;
end;

// ===================================================================== //
// ============ METODOS UTILITÁRIOS PARA O EXEMPLO C# ================== //
// ===================================================================== //
function TfrmPagamento.incrementarSequencial(sequencial:String):String;
var
  seq : Integer;
begin
  try
    seq := strtoint(sequencial) + 1;
    result := IntToStr(seq);
  except
    on Exception : EConvertError do
      result := ''; // sequencial informado não numérico
  end;
end;

function TfrmPagamento.getRetorno(resp:String):String;
begin
  result := getStringValue(jsonify(resp), 'tef.resultadoTransacao')
end;

function TfrmPagamento.getSequencial(resp:String):String;
begin
  result := getStringValue(jsonify(resp), 'tef.sequencial')
end;

function TfrmPagamento.getComprovante(resp:String; via:String):String;
begin
  if via = 'loja' then begin
    result := getStringValue(jsonify(resp), 'comprovanteDiferenciadoLoja')
    end
  else if via = 'cliente' then begin
    result := getStringValue(jsonify(resp), 'comprovanteDiferenciadoPortador')
    end
  else begin
    result := ''
  end
end;

function TfrmPagamento.jsonify(jsonString:String):TJsonObject;
begin
  result := TJsonObject.ParseJSONValue(jsonString) as TJsonObject;
end;

function TfrmPagamento.stringify(json:TJsonObject):PAnsiChar;
begin
  result := PAnsiChar(AnsiString(json.ToString));
end;

function TfrmPagamento.getStringValue(json:TJsonObject; key:String):String;
var
  value : TJsonString;
  valueSt : String;
begin
  if (json.TryGetValue(key, value)) then begin
	valueSt := value.ToString;
    result := copy(valueSt, 2, valueSt.Length-2);
   end
  else
    result := '';
end;

procedure TfrmPagamento.Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

function TfrmPagamento.naoContem(msg: string): Boolean;
var
  P : Integer;
  strings : TArray<String>;
  element : String;
  contem : boolean;
begin
  strings := ['AGUARDE', 'FINALIZADA', 'PASSAGEM', 'CANCELADA'];

  for element in strings do
    begin
        P := Pos(element, msg);
        if P = 0 then
          contem := true
        else begin
          contem := false;
          break;
        end;
    end;
    result := contem;
end;

function TfrmPagamento.readInput():String;
begin
  myThread.Suspended := true; //PAUSA A THREAD AGUARDANDO A ENTRADA DO USUARIO...
  result := retornoUI;
end;

end.
