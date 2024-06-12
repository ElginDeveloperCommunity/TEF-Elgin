unit FormColetaPinPad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FuncoesDLL, Utils;

type
  TfrmColetaPinpad = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    memoLogs: TMemo;
    cmbTipoColeta: TComboBox;
    Label1: TLabel;
    rdbNotConfirm: TRadioButton;
    rdbConfirm: TRadioButton;
    btnRealizaColeta: TButton;
    procedure finalizar(reason: string);
    procedure rdbConfirmClick(Sender: TObject);
    procedure rdbNotConfirmClick(Sender: TObject);
    procedure btnRealizaColetaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

    // hr para logs
    const hrLogs = #13#10 + '==============================================' + #13#10;
  public
    { Public declarations }
  end;

var
  frmColetaPinpad: TfrmColetaPinpad;

implementation

{$R *.dfm}

procedure TfrmColetaPinpad.btnRealizaColetaClick(Sender: TObject);
var
  tipoColeta: integer;
  confirmar: boolean;
  confirmarStr: string;
  cmbIndex: integer;
  retornoDLL: string;
  resultadoCapturaPinPad: string;
begin
  // As funções de coleta dos valores com o pinpad não dependem do fluxo de
  // transação da api (descrito na documentação), mas precisam que a conexão
  // com o pinpad esteja aberta. A conexão com o pinpad fica aberta entre os
  // passos 1 e 4 descritos na documentação, ou seja, entre o uso das funções
  // IniciarOperacaoTEF e FinalizarOPeracaoTEF.

  // inicia conexão do tef
  memoLogs.Clear;
  memoLogs.Lines.Add('INICIANDO OPERAÇÃO');

  // seleciona o index da combobox
  cmbIndex := cmbTipoColeta.ItemIndex;
  if  cmbIndex = -1 then
  begin
    ShowMessage('Selecione o tipo de operação!');
    cmbTipoColeta.SetFocus;
    exit;
  end;

  // inicia operação tef
  retornoDLL := IniciarOperacaoTEF('{}');
  memoLogs.Lines.Add(retornodll);

  // adiciona 1 para corresponder aos valores na documentação
  // 1 - RG
  // 2 - CPF
  // 3 - CNPJ
  // 4 - Telefone
  tipoColeta := cmbIndex + 1;
  confirmar := rdbConfirm.Checked;

  // apenas para mostrar nos logs qual rdb foi selecionado
  if confirmar then
    confirmarStr := 'true'
  else
    confirmarStr := 'false';

  // logs das opções escolhidas
  memoLogs.Lines.Add(hrLogs);
  memoLogs.Lines.Add('OPÇÕES ESCOHIDAS');
  memoLogs.Lines.Add('tipoColeta: ' + inttostr(tipoColeta));
  memoLogs.Lines.Add('confirmar: ' + confirmarStr);

  // realiza a coleta
  retornodll := FuncoesDLL.RealizarColetaPinPad(tipoColeta, confirmar);

  // checkar se a operação foi bem sucedida ou não
  if strtoint(getRetorno(retornoDll)) = 1 then begin
    // pega o valor digitado pelo usuário no pinpad
    resultadoCapturaPinPad := getStringValue(jsonify(retornoDll), 'tef.resultadoCapturaPinPad');
    memoLogs.Lines.Add('RESULTADO CAPTURA: ' + resultadoCapturaPinPad);
  end
  else begin
    finalizar(getStringValue(jsonify(retornodll), 'tef.mensagemResultado'));
    exit;
  end;

  // logs do retorno da DLL
  memoLogs.Lines.Add(hrLogs);
  memoLogs.Lines.Add('RETORNO DLL: RealizarColetaPinPad');
  memoLogs.Lines.Add(retornodll);

  // se a variável <confirmar> for true, a confirmação será feita automaticamente
  // caso o desenvolvedor queira fazer algo com o valor antes da confirmação,
  // ele pode usar a função ConfirmarCapturaPinPad como exemplificado a seguir:
  if confirmar then begin
    finalizar('FIM DA OPERAÇÃO');
    exit;
  end;

  memoLogs.Lines.Add(hrlogs);
  memoLogs.Lines.Add('INICIANDO CONFIRMAÇÂO');

  // faz algo com o valor coletado
  // nesse exemplo são adicionadas as máscaras dos valores
  case tipoColeta of
    1 : resultadoCapturaPinPad := FormatRG(resultadoCapturaPinPad);
    2 : resultadoCapturaPinPad := FormatCPF(resultadoCapturaPinPad);
    3 : resultadoCapturaPinPad := FormatCNPJ(resultadoCapturaPinPad);
    4 : resultadoCapturaPinPad := FormatPhone(resultadoCapturaPinPad);
  end;

  retornoDll := FuncoesDLL.ConfirmarCapturaPinPad(tipoColeta, PAnsiChar(AnsiString(resultadoCapturaPinPad)));

  // checkar se a operação foi bem sucedida ou não
  if strtoint(getRetorno(retornoDll)) = 1 then begin
    // pega o valor digitado pelo usuário no pinpad
    resultadoCapturaPinPad := getStringValue(jsonify(retornoDll), 'tef.resultadoCapturaPinPad');
    memoLogs.Lines.Add('RESULTADO CONFIRMAÇÃO: ' + resultadoCapturaPinPad);
    // logs do retorno da DLL
    memoLogs.Lines.Add('RETORNO DLL: ConfirmarCapturaPinPad');
    memoLogs.Lines.Add(retornodll);
  end
  else begin
    finalizar(getStringValue(jsonify(retornodll), 'tef.mensagemResultado'));
    exit;
  end;


  // finalizar operação
  finalizar('FIM DA OPERAÇÃO');
end;

procedure TfrmColetaPinpad.finalizar(reason: string);
var
  retornoDLL : string;
  hrLogs: string;
begin
  memoLogs.Lines.Add(hrlogs);
  memoLogs.Lines.Add('FINALIZANDO OPERAÇÂO - REASON: ' + reason);

  // Finalizando operação
  retornoDLL := FuncoesDLL.FinalizarOperacaoTEF(1); // api resolve o sequencial
  if strtoint(getRetorno(retornoDLL)) = 1 then begin
    memoLogs.Lines.Add(hrLogs);
    memoLogs.Lines.Add('FINALIZADA OPERAÇÃO COM SUCESSO!')
  end
  else begin
    memoLogs.Lines.Add(hrLogs);
    memoLogs.Lines.Add('FINALIZADA OPERAÇÃO COM ERRO!');
    memoLogs.Lines.Add(retornodll);
  end;
end;


procedure TfrmColetaPinpad.FormShow(Sender: TObject);
begin
  memoLogs.Clear;
end;

procedure TfrmColetaPinpad.rdbConfirmClick(Sender: TObject);
begin
  rdbConfirm.Checked := true;
  rdbNotConfirm.Checked := false;
end;

procedure TfrmColetaPinpad.rdbNotConfirmClick(Sender: TObject);
begin
  rdbConfirm.Checked := false;
  rdbNotConfirm.Checked := true;
end;

end.
