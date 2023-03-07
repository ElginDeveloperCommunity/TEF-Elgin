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
  // As fun��es de coleta dos valores com o pinpad n�o dependem do fluxo de
  // transa��o da api (descrito na documenta��o), mas precisam que a conex�o
  // com o pinpad esteja aberta. A conex�o com o pinpad fica aberta entre os
  // passos 1 e 4 descritos na documenta��o, ou seja, entre o uso das fun��es
  // IniciarOperacaoTEF e FinalizarOPeracaoTEF.

  // inicia conex�o do tef
  memoLogs.Clear;
  memoLogs.Lines.Add('INICIANDO OPERA��O');

  // seleciona o index da combobox
  cmbIndex := cmbTipoColeta.ItemIndex;
  if  cmbIndex = -1 then
  begin
    ShowMessage('Selecione o tipo de opera��o!');
    cmbTipoColeta.SetFocus;
    exit;
  end;

  // inicia opera��o tef
  retornoDLL := IniciarOperacaoTEF('{}');
  memoLogs.Lines.Add(retornodll);

  // adiciona 1 para corresponder aos valores na documenta��o
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

  // logs das op��es escolhidas
  memoLogs.Lines.Add(hrLogs);
  memoLogs.Lines.Add('OP��ES ESCOHIDAS');
  memoLogs.Lines.Add('tipoColeta: ' + inttostr(tipoColeta));
  memoLogs.Lines.Add('confirmar: ' + confirmarStr);

  // realiza a coleta
  retornodll := FuncoesDLL.RealizarColetaPinPad(tipoColeta, confirmar);

  // checkar se a opera��o foi bem sucedida ou n�o
  if strtoint(getRetorno(retornoDll)) = 1 then begin
    // pega o valor digitado pelo usu�rio no pinpad
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

  // se a vari�vel <confirmar> for true, a confirma��o ser� feita automaticamente
  // caso o desenvolvedor queira fazer algo com o valor antes da confirma��o,
  // ele pode usar a fun��o ConfirmarCapturaPinPad como exemplificado a seguir:
  if confirmar then begin
    finalizar('FIM DA OPERA��O');
    exit;
  end;

  memoLogs.Lines.Add(hrlogs);
  memoLogs.Lines.Add('INICIANDO CONFIRMA��O');

  // faz algo com o valor coletado
  // nesse exemplo s�o adicionadas as m�scaras dos valores
  case tipoColeta of
    1 : resultadoCapturaPinPad := FormatRG(resultadoCapturaPinPad);
    2 : resultadoCapturaPinPad := FormatCPF(resultadoCapturaPinPad);
    3 : resultadoCapturaPinPad := FormatCNPJ(resultadoCapturaPinPad);
    4 : resultadoCapturaPinPad := FormatPhone(resultadoCapturaPinPad);
  end;

  retornoDll := FuncoesDLL.ConfirmarCapturaPinPad(tipoColeta, PAnsiChar(AnsiString(resultadoCapturaPinPad)));

  // checkar se a opera��o foi bem sucedida ou n�o
  if strtoint(getRetorno(retornoDll)) = 1 then begin
    // pega o valor digitado pelo usu�rio no pinpad
    resultadoCapturaPinPad := getStringValue(jsonify(retornoDll), 'tef.resultadoCapturaPinPad');
    memoLogs.Lines.Add('RESULTADO CONFIRMA��O: ' + resultadoCapturaPinPad);
    // logs do retorno da DLL
    memoLogs.Lines.Add('RETORNO DLL: ConfirmarCapturaPinPad');
    memoLogs.Lines.Add(retornodll);
  end
  else begin
    finalizar(getStringValue(jsonify(retornodll), 'tef.mensagemResultado'));
    exit;
  end;


  // finalizar opera��o
  finalizar('FIM DA OPERA��O');
end;

procedure TfrmColetaPinpad.finalizar(reason: string);
var
  retornoDLL : string;
  hrLogs: string;
begin
  memoLogs.Lines.Add(hrlogs);
  memoLogs.Lines.Add('FINALIZANDO OPERA��O - REASON: ' + reason);

  // Finalizando opera��o
  retornoDLL := FuncoesDLL.FinalizarOperacaoTEF(1); // api resolve o sequencial
  if strtoint(getRetorno(retornoDLL)) = 1 then begin
    memoLogs.Lines.Add(hrLogs);
    memoLogs.Lines.Add('FINALIZADA OPERA��O COM SUCESSO!')
  end
  else begin
    memoLogs.Lines.Add(hrLogs);
    memoLogs.Lines.Add('FINALIZADA OPERA��O COM ERRO!');
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
