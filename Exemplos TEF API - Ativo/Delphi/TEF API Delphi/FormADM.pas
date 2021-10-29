unit FormADM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,System.JSON, FuncoesDLL, StrUtils;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    btnProsseguir: TButton;
    Edit1: TEdit;
    ListBox1: TListBox;
    GroupBox1: TGroupBox;
    btnCancelarVenda: TButton;
    btnReimpressao: TButton;
    Logs: TGroupBox;
    memoLog: TMemo;
    GroupBox2: TGroupBox;
    btnCancelar: TButton;
    btnVoltar: TButton;
    function CriaJson(valor:string): boolean;
    Procedure OperacaoADM(codigo:Integer);
    procedure log(dados:string);
    procedure ProcessaComponentesTela(json:String);
    Procedure MaquinaEstados();
    procedure btnCancelarVendaClick(Sender: TObject);
    procedure btnProsseguirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnReimpressaoClick(Sender: TObject);
  private
    { Private declarations }
    jsonObj:TJSONObject;
    myThread : TThread;
    caso : Integer;
    valorCancelamento:Integer;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation
const
  TEFElginBufferSize = 4096;

//OPÇÕES DO FLUXO DE COLETA
  TEFElginFluxo_Solicitacao = 0;// – Solicitação de Captura.
  TEFElginFluxo_Prosseguir  =	1;// – Prosseguir Captura.
  TEFElginFluxo_Cancelar    =	2;// – Cancelar Operação.
  TEFElginFluxo_Retornar    =	3;// – Retornar Captura.
  TEFElginFluxo_Seguir      =	4;// – Seguir o Fluxo.

// OPÇÕES PARA CONFIRMAÇÃO DA TRANSAÇÃO OU CANCELAMENTO
  TEFElgin_CancelarOperacao  = 0;
  TEFElgin_ConfirmarOperacao = 1;

// OPÇÕES PARA FINALIZAÇÃO DA OPERAÇÃO
  TEFElgin_FinalizarTransacao = 0;  //Automação comercial continuará executando.
  TEFElgin_FinalizarAutomacao = 1;  //Automação comercial está sendo encerrada

// CODIGO DAS OPERAÇÕES ADMINISTRATIVAS
TEFElgin_OP_ADM_Cancelamento       = 12;	//Cancelamento de compras
TEFElgin_OP_ADM_Consultar_CDC      = 61;	//Consulta planos de pagamento para cartão CDC
TEFElgin_OP_ADM_Estorno            = 86;	//Estorno de pré-autorização
TEFElgin_OP_ADM_Pre_Autorizacao_CC = 102;	//Pré-autorização com cartão de crédito
TEFElgin_OP_ADM_Recarga_Celular    = 106;	//Recarga de celular
TEFElgin_OP_ADM_Simula_crediario   = 118;	//Simulação de crediário
TEFElgin_OP_ADM_Reimpressao        = 128;	//Reimpressão de comprovante


{$R *.dfm}

  procedure TForm3.btnCancelarClick(Sender: TObject);
  var
    jp : TJSONPair;
  begin
    jp := jsonObj.RemovePair('TipoFluxo');
    jp.JsonValue.Free;
    jsonObj.AddPair('TipoFluxo', TJSONNumber.Create(TEFElginFluxo_Cancelar));
    myThread.Resume;
    caso := -1;
  end;

  procedure TForm3.log(dados: string);
  begin

    memoLog.Lines.Add('---------------------'+#13#10+dados );

  end;

  Procedure TForm3.OperacaoADM(codigo:Integer);
  var
  dados : PAnsiChar;
  ret : Integer;
  aux : string;
  begin
    if codigo = TEFElgin_OP_ADM_Cancelamento then
    begin
      try
        repeat
          valorCancelamento := StrToInt(inputbox('Valor', 'Valor a ser Cancelado', ''));
        until valorCancelamento > 0;
        except
        on E : Exception do
        begin
         ShowMessage('Exception message = '+E.Message);
         end
      end;
    end;

    if not CriaJson(IntToStr(valorCancelamento)) then
    begin
      ShowMessage('Erro ao criar json de cancelamento');
      log('Erro ao criar json de cancelamento');
      exit;
    end;

    dados := AllocMem(Length(jsonObj.ToJSON));
    ret :=  ElginTEF_Autenticador;
    log('ElginTEF_Autenticador:'+ IntToStr(ret));

    if ret <> 0 then
    begin
         ShowMessage('Erro em Autenticador: ' + IntToStr(ret));
         log('Erro em Autenticador: ' + IntToStr(ret));
         exit;
    end;

    ret := FuncoesDLL.ElginTEF_IniciarOperacaoTEF;
    log('ElginTEF_IniciarOperacaoTEF:'+ IntToStr(ret));

    if ret <> 0 then
    begin
         ShowMessage('1 - Erro para Iniciar Operação TEF: ' + IntToStr(ret));
         log('1 - Erro para Iniciar Operação TEF: ' + IntToStr(ret));
         exit;
    end;

    ret := TEFElginBufferSize;

    myThread := TThread.CreateAnonymousThread(
    procedure
    begin

      try
        repeat

        log('JSON ENVIADO');
        log(dados);

        StrPLCopy(dados, jsonObj.ToJSON, Length(jsonObj.ToJSON));
        ret := FuncoesDLL.ElginTEF_RealizarAdmTEF(codigo ,dados,ret);

        log('JSON RETORNADO');
        log(dados);
        log('ElginTEF_RealizarAdmTEF:'+ IntToStr(ret));

        aux := dados;
        jsonObj := TJSONObject.ParseJSONValue(aux)as TJSONObject;

        TThread.Synchronize(nil,
          procedure
          begin
            ProcessaComponentesTela(aux);
          end);


        until ((ret = 0) and (jsonObj.GetValue<string>('SequenciaCaptura') = '99'));

        //ERRO NA EXECUÇÃO DA VENDA, CONSULTAR DOCUMENTAÇÃO
        if ret <> 0 then
        begin
          ShowMessage('ERRO NA OPERAÇÃO: ' + IntToStr(ret));
          log('ERRO NA OPERAÇÃO: ' + IntToStr(ret));
          ret := FuncoesDLL.ElginTEF_ConfirmarOperacaoTEF(TEFElgin_CancelarOperacao);
          log('ElginTEF_ConfirmarOperacaoTEF'+IntToStr(ret));
          exit;
        end;

        ret := FuncoesDLL.ElginTEF_ConfirmarOperacaoTEF(TEFElgin_ConfirmarOperacao);
        log('ElginTEF_ConfirmarOperacaoTEF: '+IntToStr(ret));

        if ret <> 0 then
        begin
          ShowMessage('ERRO NA CONFIRMAÇÃO: ' + IntToStr(ret));
          log('ERRO NA CONFIRMAÇÃO: ' + IntToStr(ret));
          exit;
        end;

        ShowMessage('Transação finalizada Retorno: ' + IntToStr(ret));
        log('Transação finalizada Retorno: ' + IntToStr(ret));
        jsonObj.Destroy;
        jsonObj := nil;

        ret := FuncoesDLL.ElginTEF_FinalizarOperacaoTEF(TEFElgin_FinalizarTransacao);
        log('ElginTEF_FinalizarOperacaoTEF: '+ IntToStr(ret));

        except
        on E : Exception do
        begin
         ShowMessage('Exception class name = '+E.ClassName);
         ShowMessage('Exception message = '+E.Message);
        end
      end;
    end
    );
    log('Inicializando thread de pagamento...');
    myThread.start();

  end;

  procedure TForm3.btnCancelarVendaClick(Sender: TObject);
  begin
    GroupBox1.Enabled := false;
    OperacaoADM(TEFElgin_OP_ADM_Cancelamento);
    GroupBox1.Enabled := true;
  end;

  procedure TForm3.btnProsseguirClick(Sender: TObject);
  begin
    MaquinaEstados;
  end;

  procedure TForm3.btnReimpressaoClick(Sender: TObject);
  begin
   GroupBox1.Enabled := false;
   OperacaoADM(TEFElgin_OP_ADM_Reimpressao);
   GroupBox1.Enabled := true;
  end;

  procedure TForm3.btnVoltarClick(Sender: TObject);
  var
    jp : TJSONPair;
  begin
    jp := jsonObj.RemovePair('TipoFluxo');
    jp.JsonValue.Free;
    jsonObj.AddPair('TipoFluxo', TJSONNumber.Create(TEFElginFluxo_Retornar));
    myThread.Resume;
    caso := -1;
  end;

  procedure TForm3.Button4Click(Sender: TObject);
  var
    ret :Integer;
  begin
    ret := FuncoesDLL.ElginTEF_Autenticador;
    ShowMessage(IntToStr(ret));

    ret := FuncoesDLL.ElginTEF_FinalizarOperacaoTEF(0);
    ShowMessage(IntToStr(ret));
  end;

  function TForm3.CriaJson(valor:string):boolean;
  begin
      jsonObj := TJSONObject.Create;

      jsonObj.AddPair('SequenciaCaptura', TJSONNumber.Create(0));
      jsonObj.AddPair('TipoFluxo', TJSONNumber.Create(0));
      jsonObj.AddPair('InfoCaptura', valor);
      jsonObj.AddPair('ComponentesTela', nil);
      jsonObj.AddPair('AbortarFluxoCaptura', TJSONBool.Create(false));
      jsonObj.AddPair('FormatoInfoCaptura', TJSONNumber.Create(0));

      result := true;

  end;

  procedure TForm3.FormCreate(Sender: TObject);
  begin
    caso := -1;
  end;

  procedure TForm3.ProcessaComponentesTela(json:String);
  var
    arrayJson, aux:TJSONArray;
    jsonVal, auxObj : TJSONObject;
    I, J,valor: Integer;
    NomeComponenteTela, auxstr:string;

  begin

     jsonVal := TJSONObject.Create;
     jsonVal := TJSONObject.ParseJSONValue(json)as TJSONObject;

     arrayJson := jsonVal.GetValue('ComponentesTela')as TJSONArray;
     Label1.Caption := '';

     {DESABILITA OS BOTÕES PARA QUE ELES SEJA HABILITADOS DURANTE AS ITERAÇÕES
     DO FOR DE PROCESSAMENTO DE COMPONENTES DA TELA}
     btnProsseguir.Visible := false;
     btnCancelar.Visible := false;
     btnVoltar.Visible := false;
     Edit1.Visible := false;
     ListBox1.Visible := false;

     for I := 0 to arrayJson.Count-1 do
     begin

      NomeComponenteTela := arrayJson.Items[I].GetValue<string>('NomeComponenteTela');

      case AnsiIndexStr(NomeComponenteTela,['label','button','listbox','comprovante','textbox']) of
        0:
          begin
            auxstr :=  arrayJson.Items[I].GetValue<string>('ConteudoComponenteTela');
            Label1.Caption := auxstr;
          end;
        1:
          begin
            auxstr := arrayJson.Items[I].GetValue<string>('ConteudoComponenteTela');
            case AnsiIndexStr(auxstr,['Prosseguir','Cancelar','Voltar']) of
              0:
              begin
                btnProsseguir.Visible := true;
              end;
              1:
              begin
                btnCancelar.Visible := true;
              end;
              2:
              begin
                btnVoltar.Visible := true;
              end;
            end;
          end;
        2:
          begin
              ListBox1.Visible := true;
              auxstr := arrayJson.Items[I].GetValue<string>('ConteudoComponenteTela');
              auxObj := TJSONObject.ParseJSONValue(auxstr) as TJSONObject;
              aux := auxObj.GetValue('ArrayListBox') as TJSONArray;
              for J := 0 to aux.Count -1 do
              begin
                ListBox1.Items.Add(aux.Items[J].GetValue<string>('ConteudoItem'));
              end;
              caso := 0;
              myThread.Suspended := true; //PAUSA A THREAD AGUARDANDO A ENTRADA DO USUARIO...
          end;
        3:ShowMessage(arrayJson.Items[I].GetValue<string>('ConteudoComponenteTela'));
        4:
          begin
            Edit1.Text := '';
            Edit1.Visible := true;
            caso := 1;
            myThread.Suspended := True; //PAUSA A THREAD AGUARDANDO A ENTRADA DO USUARIO...
          end;

      end;
      Application.ProcessMessages;
    end;
  end;

  Procedure TForm3.MaquinaEstados;
  var
    jp : TJSONPair;
    index : string;
  begin
    case caso of
      0: //TRATA ENTRADAS VIA LISTBOX
      begin
        if ListBox1.ItemIndex = -1 then
        Begin
          ShowMessage('Escolha uma opção!');
          exit;
        end;

        index := IntToStr(ListBox1.ItemIndex + 1);

        jp := jsonObj.RemovePair('InfoCaptura');
        jp.JsonValue.Free;
        jsonObj.AddPair('InfoCaptura', index);

        ListBox1.visible := false;
        caso := -1;
        myThread.Resume;
      end;

      1: //TRATA AS ENTRADAS FEITAS VIA TEXTBOX
      begin
        if Edit1.Text = '' then
        begin
          ShowMessage('Preencha o valor!');
          Edit1.SetFocus;
          exit;
        end;

        jp := jsonObj.RemovePair('InfoCaptura');
        jp.JsonValue.Free;
        jsonObj.AddPair('InfoCaptura', Edit1.Text);
        Edit1.Visible := false;
        caso := -1;
        myThread.Resume;
        exit;
      end;

      else ShowMessage('Operação invalida!');
    end;

  end;

end.
