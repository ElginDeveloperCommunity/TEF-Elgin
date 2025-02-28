﻿unit FormPagamento;
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


// ===================================================================== //
// ============================ MÉTODOS DE UI ========================== //
// ===================================================================== //

// handle da tecla "Enter" durante fase de coleta em que informações são 
// pedidas para o usuário
procedure TfrmPagamento.txtOperadorKeyPress(Sender: TObject; var Key: Char);
var
  retList : String;
  retTxt : String;
begin
if Key = #13 then
begin
  // mesmo código do btnOKClick

  // variável global usada no fluxo de transação para pegar retorno do usuário
  retornoUI := '';

  // Se usuário não escolher nenhuma opção, pedir para que seja escolhida 
  // uma opção
  if (listOperador.ItemIndex = -1) and (listOperador.Visible) then begin
      ShowMessage('Escolha uma opção');
    exit;
  end;

  // Se usuário não escolher escrever o valor pedido, pedir para que seja 
  // escrito
  if (txtOperador.Text = '') and (txtOperador.Visible) then begin
    ShowMessage('Escreva o valor pedido');
    exit;
  end;

  // pega valor escolhido pelo usuário
  retList := IntToStr(listOperador.ItemIndex);
  retTxt := txtOperador.Text;

  // reseta UI
  txtOperador.Text := '';
  lblOperador.Visible := false;
  txtOperador.Visible := false;
  btnOK.Visible := false;
  btnCanc.Visible := false;

  // define variável global como retorno do usuário
  if listOperador.Visible then begin
    retornoUI := retList;
  end else begin
    retornoUI := retTxt;
  end;
  listOperador.Visible := false;

  // retoma a execução da thread da transação
  myThread.Resume;
end;
end;

// handle da tecla "Enter" durante fase de coleta em que informações são 
// pedidas para o usuário
procedure TfrmPagamento.btnOKClick(Sender: TObject);
var
  retList : String;
  retTxt : String;
begin
  // variável global usada no fluxo de transação para pegar retorno do usuário
  retornoUI := '';

  // Se usuário não escolher nenhuma opção, pedir para que seja escolhida 
  // uma opção
  if (listOperador.ItemIndex = -1) and (listOperador.Visible) then begin
      ShowMessage('Escolha uma opção');
    exit;
  end;

  // Se usuário não escolher escrever o valor pedido, pedir para que seja 
  // escrito
  if (txtOperador.Text = '') and (txtOperador.Visible) then begin
   ShowMessage('Escreva o valor pedido');
   exit;
  end;

  // pega valor escolhido pelo usuário
  retList := IntToStr(listOperador.ItemIndex);
  retTxt := txtOperador.Text;

  // reseta UI
  txtOperador.Text := '';
  lblOperador.Visible := false;
  txtOperador.Visible := false;
  btnOK.Visible := false;
  btnCanc.Visible := false;
  imgQrcode.Visible := false;

  // define variável global como retorno do usuário
  if listOperador.Visible then begin
    retornoUI := retList;
  end else begin
    retornoUI := retTxt;
  end;
  listOperador.Visible := false;

  // retoma execução da thread da transação
  myThread.Resume;
end;

// botão 'Cancelar'
procedure TfrmPagamento.btnCancClick(Sender: TObject);
begin

  // define a variável global retornoUI = 0 
  retornoUI := '0';

  // define variavel global cancelarColeta = 9 para que quando o fluxo da 
  // transação for retomado, a transação seja cancelada (na função coleta)
  cancelarColeta := '9';

  // retorma execução da thread da transação
  myThread.Resume;
end;

// botão que inicia o fluxo de uma transação PIX
procedure TfrmPagamento.btnIniciarOperacaoPIXClick(Sender: TObject);
begin

  // altera o estado da variével global operacaoAtual para que na função coleta
  // a função de operação PIX seja chamada
  operacaoAtual := OPERACAO_PIX;

  // antes de começar a transação, feedback visual para o usuário saber que 
  // a transação irá iniciar
  lblOperador.Visible := true;
  lblOperador.Caption := 'AGUARDE...';

  // reseta o label do valor da transação
  lblValor.Caption := '';

  // INSTANCIA THREAD RESPONSAVEL POR INICIAR A TRANSAÇÃO
  // NESSE EXEMPLO A TRANSAÇÃO É FEITA EM UMA THREAD PARA NÃO OCORRER CONGELAMENTO
  // DA TELA PRINCIPAL
  myThread := TThread.CreateAnonymousThread(
    procedure
      begin
        try
          // chama a função que contém o fluxo principal da transação
          // https://elgindevelopercommunity.github.io/group__t20.html
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
  // começa a execução da thread
  myThread.start();
end;

// botão que inicia o fluxo de uma transação TEF
procedure TfrmPagamento.btnIniciarOperacaoTEFClick(Sender: TObject);
begin
  // altera o estado da variével global operacaoAtual para que na função coleta
  // a função de operação TEF seja chamada
  operacaoAtual := OPERACAO_TEF;

  // antes de começar a transação, feedback visual para o usuário saber que 
  // a transação irá iniciar
  lblOperador.Visible := true;
  lblOperador.Caption := 'AGUARDE...';

  // reseta o label do valor da transação
  lblValor.Caption := '';

  //INSTANCIA THREAD RESPONSAVEL POR INICIAR A TRANSAÇÃO
  //NESSE EXEMPLO A TRANSAÇÃO É FEITA EM UMA THREAD PARA NÃO OCORRER CONGELAMENTO
  //DA TELA PRINCIPAL
  myThread := TThread.CreateAnonymousThread(
    procedure
      begin
        try
          // chama a função que contém o fluxo principal da transação
          // https://elgindevelopercommunity.github.io/group__t20.html
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
  // começa a execução da thread
  myThread.start();
end;

// botão BackSpace que apaga um dígito do valor escrito no label valor
procedure TfrmPagamento.btnBSClick(Sender: TObject);
begin
  if text <> '' then begin
    valorTotal := valorTotal.Substring(0, valorTotal.Length - 1);
    lblValor.Caption := FormatNumber(valorTotal);
  end
end;

// lógica nos botões numéricos para definição do valor da venda
procedure TfrmPagamento.btnGenericClick(Sender: TObject);
begin
  // não permite que um valor com mais de 6 dígitos seja escrito 
  // no label lblValor
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

// botão que 'limpa' o lblValor e reseta a variável global do valor da venda
procedure TfrmPagamento.btnClearClick(Sender: TObject);
begin
  valorTotal := '';
  lblValor.Caption := FormatNumber(valorTotal);
end;

// Função usada na fase de coleta para mostrar elementos e escritas enviadas 
// pela API em formato de String à Automação Comercial
procedure TfrmPagamento.print(msg:String);
var
  hexString: String;
begin
  // sincroniza com a thread da UI para mostrar elementos
  TThread.Synchronize(nil, procedure
  begin
    // reseta UI
    listOperador.Visible := false;
    txtOperador.Visible := false;
    lblOperador.Visible := false;
    btnOK.Visible := false;
    btnCanc.Visible := false;
    imgQrcode.Visible := false;

    // QRCODE PIX
    // caso esteja na fase de coleta de uma transação PIX, na String msg estará 
    // presente o texto 'QRCODE', caso isso seja identificado, adentra o 
    // seguinte fluxo para mostrar o QRCode do pix na tela
    if Pos('QRCODE;', msg) <> 0 then begin

      // define a variável que contem a string em formato hexadecimal que 
      // representa o qrcode do pix
      hexString := ExtractTextBetween(msg, ';', ';');

      // função que gera a imagem do qrcode do pix
      displayQRCode(hexString);

      // tornar elementos visíveis ao usuário
      imgqrcode.Visible := true;
      btnOk.Visible := true;
      btnCanc.Visible := true;

    // caso não seja a coleta do pagamento do PIX, mas uma coleta de qualquer 
    // outra funcionalidade, prosseguir no seguinte fluxo
    end else begin

      // definir o conteúdo do lblOperador e torná-lo visível ao usuário
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

// Função usada na fase de coleta para mostrar elementos e escritas enviadas 
// pela API em formato de TStringList à Automação Comercial
procedure TfrmPagamento.printArray(elements : TStringList);
begin
  TThread.Synchronize(nil, procedure
    begin
      // sincroniza com a thread da UI para mostrar elementos
      printArrayThread(elements);
    end
  );
end;

// função chamada pela printArray
procedure TfrmPagamento.printArrayThread(elements : TStringList);
var
  element : String;
begin
      // reseta UI
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

      // adiciona ao listOperador os elementos presentes no parâmetro da função
      for element in elements do
        listOperador.Items.Add(element);
      // torna o listOperador visível ao usuário
      listOperador.Visible := true;
end;

// função que recebe como argumento uma String Hexadecimal representando um
// qrcode (no caso de transações PIX) e o mostra na UI
procedure TfrmPagamento.displayQRCode(hexString: string);
var
  pngImage: TPngImage;
  stream: TMemoryStream;
begin

  // define valor do membro imgQrcode como nulo
  imgQrcode.Picture.Assign(nil);

  // cria uma stream de dados que irá processar a imagem
  stream := TMemoryStream.Create;
  try
    // define o tamanho da stream com base no tamanho da string hexadecimal
    stream.size := Length(hexString) div 2;

    // verifica se a stream possui algum tamanho
    if stream.Size > 0 then begin
      // converte a string hexadecimal para binário e armazena na memória 
      // da stream
      HexToBin(PChar(hexString), stream.Memory, stream.Size);

      // cria uma instância de TPngImage
      pngImage := TPngImage.Create;
      try
        // carrega a imagem PNG a partir da stream
        pngImage.LoadFromStream(stream);

        // atribui a imagem carregada ao componente imgQrcode
        imgQrcode.Picture.Assign(pngImage);
      finally
        // libera a memória ocupada pela instância de TPngImage
        pngImage.Free;
      end;
    end;
  finally
    // libera a memória ocupada pela stream de dados
    stream.Free;
  end;
end;

// escreve logs em tela
procedure TfrmPagamento.writeLogs(logs:String);
var
  divLogs : String;
begin
  TThread.Synchronize(nil, procedure
    begin
      // cria uma string de divisão formatada com quebra linha
      divLogs := #13#10 + '==============================================' + #13#10;

      // adiciona a string de divisão seguida pelo conteúdo dos logs ao 
      // componente memoLogs
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
  // configuração inicial 
  // https://elgindevelopercommunity.github.io/group__t23.html
  FuncoesDLL.SetClientTCP('127.0.0.1', 60906);
  FuncoesDLL.ConfigurarDadosPDV('ApiTEFElgin Delphi', 'v1.0.000', 'Elgin', '01', 'T0004');

  // 1) INICIAR CONEXÃO COM CLIENT
  start := iniciar();

  // faz o parse do retorno da função iniciar
  retorno := Utils.getRetorno(start);
  // dependendo do resultado da função iniciar definido na variável "retorno" o 
  // fluxo poderá terminar ou continuar
  if (retorno = '') or (retorno <> '1') then begin
      finalizar();
      exit;
    end;

  // 2) REALIZAR OPERACAO

  // define a variável "sequencial" a partir do retorno da função "iniciar"
  // e incrementa seu valor para ser enviado na próxima chamada à API
  sequencial := Utils.getSequencial(start);
  sequencial := Utils.incrementarSequencial(sequencial);
                
  // possíveis chamadas a serem feitas
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
  // dependendo do estado da variável "operacaoAtual" seguir com o fluxo da 
  // operação escolhida pelo usuário
  if operacaoAtual = OPERACAO_TEF then
    resp := vender(0, sequencial, OPERACAO_TEF)
  else
    resp := vender(0, sequencial, OPERACAO_PIX);

  // extrair a chave "retorno" do retorno da função vender
  retorno := Utils.getRetorno(resp);
  // se a chave retorno não estiver presente, ou seja, for igual a '', 
  // continuar para o fluxo de coleta
  if retorno = '' then
  // Continuar operacao/iniciar o processo de coleta
    begin
      // 0 para coletar vendas, 1 para coletar adm
      resp := coletar(OPERACAO_VENDER, Utils.jsonify(resp));
      // extrair a chave "retorno" do retorno da função coletar
      retorno := Utils.getRetorno(resp);
    end;

  // 3) VERIFICAR RESULTADO / CONFIRMAR
  // se a chave retorno não estiver presente no retorno da função "coletar", 
  // finalizar operação com erro
  if retorno = '' then
    begin
      writeLogs('ERRO AO COLETAR DADOS');
      print('ERRO AO COLETAR DADOS');
    end
  else if retorno = '0' then
   begin
    // extrair comprovantes das respectivas chaves no retorno da 
    // função "coletar"
    comprovanteLoja := Utils.getComprovante(resp, 'loja');
    comprovanteCliente := Utils.getComprovante(resp, 'cliente');
    writeLogs(comprovanteLoja);
    writeLogs(comprovanteCliente);
    writeLogs('TRANSAÇÃO OK, INICIANDO CONFIRMAÇÃO...');
    print('TRANSAÇÃO OK, INICIANDO CONFIRMAÇÃO...');

    // extrair valor da chave "sequencial" retornado pela função "coletar"
    sequencial := Utils.getSequencial(resp);

    // confirma a operação por meio do sequencial utilizado
    cnf := confirmar(sequencial);

    // extrair chave "retorno" do retorno da função confirmar
    retorno := Utils.getRetorno(cnf);
    // se chave retorno for varia ou diferente de '1' finalizar
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

  // possíveis valores a serem adicionados ao payload, porém não necessários
  // se for escolhido usar os valores default definidos nas funções 

  // SetClientTCP e ConfigurarDadosPDV
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

  // conforme a documentação: 
  // https://elgindevelopercommunity.github.io/group__tf.html#ga1bf9edea41af3c30936caf5ce7f8c988
  resultado := IniciarOperacaoTEF(Utils.stringify(payload));
  // mostrar na UI o retorno da função
  writeLogs('INICIAR: ' + Utils.jsonify(UTF8ToString(resultado)).Format(2));
  // libera a memória ocupada pela instância de TJsonObject
  FreeAndNil(payload);

  // retorna a string retornada pela função IniciarOperacaoTEF
  result := UTF8ToString(resultado);
end;

function TfrmPagamento.vender(cartao:Integer; sequencial:String; operacao:Integer):String;
var
  payload : TJsonObject; // Objeto JSON para armazenar os dados da transação
  resultado : UTF8String; // String UTF-8 para armazenar o resultado da transação
begin 
  // Cria uma instância de TJsonObject para armazenar os dados da transação
  payload := TJsonObject.Create; 
  // registra um log com o sequencial utilizado na venda
  writeLogs('VENDER: ' + ' SEQUENCIAL UTILIZADO NA VENDA: ' + sequencial);
  // adiciona o sequencial ao objecto payload
  payload.AddPair('sequencial', sequencial);

  // verifica valor da variável global "valorTotal"
  if valorTotal <> '' then
    begin
      // Remove caracteres não numéricos do valor total
      valorTotal := RemoveNonNumericChars(valorTotal); 
      // Adiciona o valor total ao objeto payload
      payload.AddPair('valorTotal', valorTotal);
    end;

  if operacao = OPERACAO_TEF then
    resultado := FuncoesDLL.RealizarPagamentoTEF(cartao, Utils.stringify(payload), True)
  else
    resultado := FuncoesDLL.RealizarPixTEF(Utils.stringify(payload), True);

  // Registra um log com o resultado da transação formatado em JSON
  writeLogs('VENDER: ' + Utils.jsonify(UTF8ToString(resultado)).Format(2));
  // Libera a memória ocupada pelo objeto payload
  FreeAndNil(payload);
  // Converte o resultado para uma string e retorna
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
  // libera a memória ocupada pela instância de TJsonObject
  FreeAndNil(payload);
  result := UTF8ToString(resultado);
end;

// COLETAR
// segue lógica de coleta explicada na documentação
// https://elgindevelopercommunity.github.io/group__t21.html
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

  // COLETA DADOS DO USUÀRIO
  // se a chave coletaTipo não for vazia e a chave coletaOpcao for vazia
  // quer dizer que a API está pedindo por um valor que o usuário 
  // precisa digitar
  if (coletaTipo <> '') and (coletaOpcao = '') then begin // valor inserido (texto)
    writeLogs('INFORME O VALOR SOLICITADO: ');
    coletaInformacao := readInput();

    // verifica variável global "cancelarColeta"
    // se houve cancelamento, adiciona a chave com cancelamento para avisar a dll
    if (cancelarColeta <> '') then begin
      payload.RemovePair('automacao_coleta_retorno');
      payload.AddPair('automacao_coleta_retorno', cancelarColeta);
      cancelarColeta := '';
    end;
    
    // adiciona no payload valor digitado pelo usuário 
    payload.AddPair('automacao_coleta_informacao', coletaInformacao);
  end

  // se a chave coletaTipo não for vazia e a chave coletaOpcao também não for 
  // vazia quer dizer que a API está pedindo por um valor que o usuário 
  // precisa escolher dentre algumas opções
  else if (coletaTipo <> '') and (coletaOpcao <> '') then begin // valor selecionado (lista)

    // lógica que lê e separa as opções retornadas na chave 'automacao_coleta_opcao'
    // presentes na variável 'coletaOpcao'
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

    // mostra na UI a lista de opções para que o usuário selecione
    printArray(elements);
    writeLogs(#13#10 + 'DIGITE A OPÇÂO DESEJADA: ');

    // espera o input do usuário para continuar o fluxo. Função readInput irá 
    // retornar o index do array da opção escolhida
    coletaInformacao := opcoes[strtoint(readInput())];

    // verifica variável global "cancelarColeta"
    // se houve cancelamento, adiciona a chave com cancelamento para avisar a dll
    if (cancelarColeta <> '') then begin
      payload.RemovePair('automacao_coleta_retorno');
      payload.AddPair('automacao_coleta_retorno', cancelarColeta);
      cancelarColeta := '';
    end;

    // adiciona no payload valor escolhido pelo usuário
    payload.AddPair('automacao_coleta_informacao', coletaInformacao);
    // libera a memória ocupada pela instância de TJsonObject
    FreeAndNil(elements);
  end;

  // informa os dados coletados
  if operacao = OPERACAO_ADM then begin
    resp := FuncoesDLL.RealizarAdmTEF(0, Utils.stringify(payload), false);
  end
  else begin
    if operacaoAtual = OPERACAO_PIX then
      resp := FuncoesDLL.RealizarPixTEF(Utils.stringify(payload), false)
    else
      resp := FuncoesDLL.RealizarPagamentoTEF(0, Utils.stringify(payload), false)
  end;

  // libera a memória ocupada pela instância de TJsonObject
  FreeAndNil(payload);

  writeLogs(Utils.jsonify(UTF8ToString(resp)).Format(2));

  // verifica fim da coleta
  retorno := Utils.getRetorno(UTF8ToString(resp));
  if retorno <> '' then begin
    result := UTF8ToString(resp);
    exit;
  end;
  // passa para próxima fase da coleta chamando novamente a função até que 
  // a coleta seja finalizada
  result := coletar(operacao, Utils.jsonify(UTF8ToString(resp)));
end;

// função que confirma transações realizadas
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

// ===================================================================== //
// ========== METODOS UTILITÁRIOS PARA O EXEMPLO DELPHI ================ //
// ===================================================================== //

// função chamada quando necessário pegar algum retorno do usuário
// após pausar a thread da transação, quando o usuário informar o dado pedido 
// na UI, a thread recomeça a a função retorna o valor na variável global retornoUI
function TfrmPagamento.readInput():String;
begin
  myThread.Suspended := true; //PAUSA A THREAD AGUARDANDO A ENTRADA DO USUARIO...
  result := retornoUI;
end;

end.
