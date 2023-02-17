unit FormADM;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,System.JSON,
  Utils, FuncoesDLL, StrUtils, Vcl.Mask;
//
// Aplicativo Exemplo para E1_Tef Api, versão Delphi VCL
// Gabriel Franzeri @ Elgin, 2022
//
type
  TfrmAdm = class(TForm)
    lblOperador: TLabel;
    btnOk: TButton;
    txtOperador: TEdit;
    listOperador: TListBox;
    GroupBox1: TGroupBox;
    btnIniciarOperacao: TButton;
    Logs: TGroupBox;
    memoLogs: TMemo;
    GroupBox2: TGroupBox;
    btnCanc: TButton;

    // Prototypes
    // M�todos para o controle da transa��o (E1_Tef)
    procedure TesteApiElginTEF;
    function iniciar():String;
    function vender(cartao:Integer; sequencial:String):String;
    function adm(opcao:Integer; sequencial:String):String;
    function coletar(operacao:Integer; root:TJsonObject):String;
    function confirmar(sequencial:String):String;
    function finalizar():String;

    // M�todos utilit�rios
    function readInput():String;
    procedure writeLogs(logs:String);
    procedure print(msg:String);
    procedure printArray(elements : TStringList);
    procedure printArrayThread(elements : TStringList);

    // M�todos UI
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
    cancelarColeta:String;
    txtOperadorTextoAtual : String;
    ApplyingMask: String;
  end;
var
  frmAdm: TfrmAdm;
implementation
const
  OPERACAO_VENDER = 0;
  OPERACAO_ADM = 1;


{$R *.dfm}

procedure TfrmAdm.txtOperadorKeyPress(Sender: TObject; var Key: Char);
var
  retList : String;
  retTxt : String;
  input,
  res: string;
  len,
  dotPos,
  dotIndex: Integer;
begin

// tecla "Enter"
if Key = #13 then
begin
  // mesmo c�digo do btnOKClick
  retornoUI := '';
  if (listOperador.ItemIndex = -1) and (listOperador.Visible) then begin
      ShowMessage('Escolha uma op��o');
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

// APLICA MASCARAS NO TEDIT
if ApplyingMask = '.##' then begin

  if (key = removeNonNumericChars(key)) or (key = #8) then begin
    if key = removeNonNumericChars(key) then
      dotIndex := 1;
    if key = #8 then
      dotIndex := 3;

    res := maskValor(txtOperador.Text, dotIndex);

    txtOperador.Text := res;
    txtOperador.SelStart := length(res);
  end;
end else if ApplyingMask = 'dd\/MM\/yy' then begin
    res := maskDate(txtOperador.Text);

    txtOperador.Text := res;
    txtOperador.SelStart := length(res);
end;

end;

procedure TfrmAdm.btnOKClick(Sender: TObject);
var
  retList : String;
  retTxt : String;
begin
  retornoUI := '';
  if (listOperador.ItemIndex = -1) and (listOperador.Visible) then begin
      ShowMessage('Escolha uma op��o');
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
procedure TfrmAdm.btnCancClick(Sender: TObject);
begin
  retornoUI := '';
  cancelarColeta := '9';
  myThread.Resume;
end;
procedure TfrmAdm.btnIniciarOperacaoClick(Sender: TObject);
begin

  lblOperador.Visible := true;
  lblOperador.Caption := 'AGUARDE...';


  //INSTANCIA THREAD RESPONSAVEL POR INICIAR A TRANSA��O
  //NESSE EXEMPLO A TRANSA��O � FEITA EM UMA THREAD PARA N�O OCORRER CONGELAMENTO
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
procedure TfrmAdm.print(msg:String);
begin
  TThread.Synchronize(nil, procedure
  begin
    listOperador.Visible := false;
    txtOperador.Visible := false;
    btnOK.Visible := false;
    btnCanc.Visible := false;
    lblOperador.Caption := msg;
    lblOperador.Visible := true;

    if naoContem(msg) then begin
      txtOperador.Visible := true;
      txtOperador.SetFocus;
      btnOK.Visible := true;
      btnCanc.Visible := true;
    end;
  end

  );
end;
procedure TfrmAdm.printArray(elements : TStringList);
begin
  TThread.Synchronize(nil, procedure
    begin
      printArrayThread(elements);
    end
  );
end;
procedure TfrmAdm.printArrayThread(elements : TStringList);
var
  element : String;
begin
      listOperador.Clear;

      listOperador.Visible := false;
      txtOperador.Visible := false;
      btnOK.Visible := false;
      btnCanc.Visible := false;
      lblOperador.Visible := true;
      btnOK.Visible := true;
      for element in elements do
        listOperador.Items.Add(element);
      listOperador.Visible := true;
end;

procedure TfrmAdm.writeLogs(logs:String);
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
// ============================ L�GICA DO TEF ========================== //
// ===================================================================== //
// =============================== TESTES ============================== //
// ===================================================================== //
procedure TfrmAdm.TesteApiElginTEF;
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
  FuncoesDLL.ConfigurarDadosPDV('TEFElgin Delphi', 'v1.0.000', 'Elgin', '01', 'T0004');
  // 1) INICIAR CONEX�O COM CLIENT
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

  // POR SER A JANELA DE ADM, USAR A FUN��O ADm
  resp := adm(0, sequencial);
  retorno := getRetorno(resp);
  if retorno = '' then
  // Continuar operacao/iniciar o processo de coleta
    begin
      // 0 para coletar vendas, 1 para coletar adm
      resp := coletar(OPERACAO_ADM, jsonify(resp));
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
    writeLogs('TRANSA��O OK, INICIANDO CONFIRMA��O...');
    print('TRANSA��O OK, INICIANDO CONFIRMA��O...');
    sequencial := getSequencial(resp);
    // confirma a opera��o por meio do sequencial utilizado
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
      writeLogs('ERRO NA TRANSA��O');
      print('ERRO NA TRANSA��O');
    end;
  // 4) FINALIZAR CONEXAO
  endFinalizar := finalizar();
  retorno := getRetorno(endFinalizar);
  if (retorno = '') or (retorno <> '1') then
    finalizar();
    exit;
end;
// ===================================================================== //
// ============ M�TODOS PARA O CONTROLE DA TRANSA��O (E1_TEF) ========== //
// ===================================================================== //
function TfrmAdm.iniciar():String;
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

  resultado := IniciarOperacaoTEF(stringify(payload));
  writeLogs('INICIAR: ' + jsonify(UTF8toString(resultado)).Format(2));
  FreeAndNil(payload);
  result := UTF8ToString(resultado);
end;

// VENDER
function TfrmAdm.vender(cartao:Integer; sequencial:String):String;
var
  payload : TJsonObject;
  resultado : UTF8String;
begin
  payload := TJsonObject.Create;
  writeLogs('VENDER: ' + ' SEQUENCIAL UTILIZADO NA VENDA: ' + sequencial);
  payload.AddPair('sequencial', sequencial);

  resultado := FuncoesDLL.RealizarPagamentoTEF(cartao, stringify(payload), True);
  writeLogs('VENDER: ' + jsonify(UTF8ToString(resultado)).Format(2));
  FreeAndNil(payload);
  result := UTF8ToString(resultado);
end;

// ADM
function TfrmAdm.adm(opcao:Integer; sequencial:String):String;
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
  writeLogs('ADM: ' + jsonify(UTF8ToString(resultado)).Format(2));
  FreeAndNil(payload);
  result := UTF8ToString(resultado);
end;

// COLETAR
function TfrmAdm.coletar(operacao:Integer; root:TJsonObject):String;
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
  coletaRetorno       := getStringValue(root, 'tef.automacao_coleta_retorno');
  coletaSequencial    := getStringValue(root, 'tef.automacao_coleta_sequencial');
  coletaMensagem      := getStringValue(root, 'tef.mensagemResultado');
  coletaTipo          := getStringValue(root, 'tef.automacao_coleta_tipo');
  coletaOpcao         := getStringValue(root, 'tef.automacao_coleta_opcao');
  coletaMascara       := getStringValue(root, 'tef.automacao_coleta_mascara');
  writeLogs('COLETAR: ' +  UpperCase(coletaMensagem));
  print(UpperCase(coletaMensagem));

  // em caso de erro, encerra coleta
  if coletaRetorno <> '0' then begin
    result := stringify(root);
    exit;
  end;

  ApplyingMask := coletaMascara;

  // em caso de sucesso, monta o (novo) payload e continua a coleta
  payload := TJsonObject.Create;
  payload.AddPair('automacao_coleta_retorno', coletaRetorno);
  payload.AddPair('automacao_coleta_sequencial', coletaSequencial);
  // coleta dados do usu�rio
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
    writeLogs(#13#10 + 'DIGITE A OP��O DESEJADA: ');
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
  // informa od dados coletados
  if operacao = OPERACAO_ADM then begin
    resp := FuncoesDLL.RealizarAdmTEF(0, stringify(payload), false);
  end
  else begin
    resp := FuncoesDLL.RealizarPagamentoTEF(0, stringify(payload), false);
  end;

  writeLogs(jsonify(UTF8ToString(resp)).Format(2));
  // verifica fim da coleta
  retorno := getRetorno(UTF8ToString(resp));
  if retorno <> '' then begin
    result := UTF8ToString(resp);
    exit;
  end;
  result := coletar(operacao, jsonify(UTF8ToString(resp)));
end;
function TfrmAdm.confirmar(sequencial:String):String;
var
  resultado : UTF8String;
begin
  writeLogs('CONFIRMAR: ' + 'SEQUENCIAL DA OPERA��O A SER CONFIRMADA: ');
  print('AGUARDE, CONFIRMANDO OPERA��O...');

  resultado := FuncoesDLL.ConfirmarOperacaoTEF(strtoint(sequencial), 1);
  writeLogs('CONFIRMAR: ' + jsonify(UTF8ToString(resultado)).Format(2));
  result := UTF8ToString(resultado);
end;

function TfrmAdm.finalizar():String;
var
  resultado : UTF8String;
begin
  resultado := FuncoesDLL.FinalizarOperacaoTEF(1); // api resolve o sequencial
  writeLogs('Finalizar: ' + jsonify(UTF8ToString(resultado)).Format(2));
  print('OPERA��O FINALIZADA');
  result := UTF8ToString(resultado);
end;
// ===================================================================== //
// ========== METODOS UTILIT�RIOS PARA O EXEMPLO DELPHI ================ //
// ===================================================================== //

function TfrmAdm.readInput():String;
begin
  myThread.Suspended := true; //PAUSA A THREAD AGUARDANDO A ENTRADA DO USUARIO...
  result := retornoUI;
end;

end.
