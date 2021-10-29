unit FormPagamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, FuncoesDLL, System.JSON, StrUtils;

type
  TForm2 = class(TForm)
    Button13: TButton;
    Button14: TButton;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    GroupBox2: TGroupBox;
    btnOK: TButton;
    btnCanc: TButton;
    btnVoltar: TButton;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    GroupBox4: TGroupBox;
    lblProc2: TLabel;
    lblProc: TLabel;
    Edit1: TEdit;
    ListBox1: TListBox;
    procedure Button12Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonGenericClick(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);

    function ValidaCampos():boolean;
    procedure ProcessaOperacaoTEF(tipo:Integer);
    procedure log(dados:string);
    procedure MaquinaEstados();
    procedure ProcessaComponentesTela(json:string);
    function  CriaJson(tipo:Integer; valor, taxa:string):boolean;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnVoltarClick(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);

  private
    myThread : TThread;
    jsonObj:TJSONObject;
    caso:Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation


const
  TEFElginBufferSize = 4096;

  // OPERAÇÕES DE PAGAMENTO
  TEFElginPagtoDebito  = 1;
  TEFElginPagtoCredito = 2;

  TEFElginCancelamento = 3;
  TEFElginConfiguracao = 4;
  TEFElginReimpressao  = 128;

  // OPÇÕES DO FLUXO DE COLETA
  TEFElginFluxo_Solicitar   = 0;// – Solicitação de Captura.
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

{$R *.dfm}


//FUNÇÃO RESPONSAVEL POR CRIAR O JSON ENVIADO PARA PROCESSAMENTO DA API
//RECEBE 3 PARAMETROS, SENDO ELES:
//TIPO:  TIPO DO JSON A SER CRIADO, PODENDO SER UM JSON DE CANCELAMENTO OU VENDA
//VALOR: VALOR DA TRANSAÇÃO OU DA TRANSAÇÃO A SER CANCELADA
//TAXA:  CASO A TRANSAÇÃO POSSUA TAXA DE SERVIÇO
function TForm2.CriaJson(tipo:Integer; valor, taxa:string):boolean;
begin
       jsonObj := TJSONObject.Create;

       jsonObj.AddPair('SequenciaCaptura', TJSONNumber.Create(0));
       jsonObj.AddPair('TipoFluxo', TJSONNumber.Create(0));
       jsonObj.AddPair('ComponentesTela', nil);
       jsonObj.AddPair('AbortarFluxoCaptura', TJSONBool.Create(false));
       jsonObj.AddPair('FormatoInfoCaptura', TJSONNumber.Create(0));

       if tipo <> TEFElginCancelamento then
       begin
        jsonObj.AddPair('InfoCaptura',valor);
       end
       else
       begin
        jsonObj.AddPair('InfoCaptura', 'ValorCancelamento:'+valor+',TaxaCancelamento:'+taxa);
       end;

       log('JSON PAGAMENTO CRIADO' + #13#10 + jsonObj.ToJSON);

       result := true;
end;

procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  jp : TJSONPair;
begin
if Key = #13 then
begin
  jp := jsonObj.RemovePair('TipoFluxo');
  jp.JsonValue.Free;
  jsonObj.AddPair('TipoFluxo', TJSONNumber.Create(TEFElginFluxo_Prosseguir));
  MaquinaEstados
end
end;

//GRAVA LOG NO COMPONENTE MEMO
procedure TForm2.log(dados: string);
begin

  Memo1.Lines.Add('---------------------'+#13#10+dados );

end;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True;
   ListOfStrings.DelimitedText   := Str;
end;

procedure TForm2.ProcessaOperacaoTEF(tipo: Integer);
var
dados : PAnsiChar;
aux : string;
ret : Integer;
begin

   //CRIA JSON DE ENTRADA DA API
  if not CriaJson(tipo, Label1.Caption, '0') then
  begin
    ShowMessage('ERRO AO CRIAR JSON!');
    log('ERRO AO CRIAR JSON!');
    exit;
  end;

  if tipo <> TEFElginConfiguracao then
  begin

    //REALIZA A AUTENTICAÇÃO DO CLIENTE NO SERVIDOR
    ret := FuncoesDLL.ElginTEF_Autenticador;
    log('ElginTEF_Autenticador:'+ IntToStr(ret));

    if ret <> 0 then
    begin
       ShowMessage('Erro em Autenticador: ' + IntToStr(ret));
       log('Erro em Autenticador: ' + IntToStr(ret));
       exit;
    end;

    //REALIZA A CONEXÃO COM O SERVIDOR E TRATA QUEDA DE ENERGIA CASO TENHA OCORRIDO
    ret := FuncoesDLL.ElginTEF_IniciarOperacaoTEF;
    log('ElginTEF_IniciarOperacaoTEF:'+ IntToStr(ret));

    if ret <> 0 then
    begin
         ShowMessage('1 - Erro para Iniciar Operação TEF: ' + IntToStr(ret));
         log('1 - Erro para Iniciar Operação TEF: ' + IntToStr(ret));
         exit;
    end;
  end;


  //INSTANCIA THREAD RESPONSAVEL POR INICIAR A TRANSAÇÃO
  //NESSE EXEMPLO A TRANSAÇÃO É FEITA EM UMA THREAD PARA NÃO OCORRER CONGELAMENTO
  //DA TELA PRINCIPAL
  myThread := TThread.CreateAnonymousThread(
  procedure
  var
  lenght:Integer;
  begin
    lenght := TEFElginBufferSize;

    try
      repeat

      //REALIZA ALOCAÇÃO DE MEMORIA PARA A VARIAVEL QUE SERÁ USADA PARA RECEBER OS
      //DADOS DA API
        dados := AllocMem(Length(jsonObj.ToJSON));

        //COPIA OS DADOS DO JSON PARA A VARIAVEL QUE SERÁ PASSADA COMO PARAMETRO
        StrPLCopy(dados, jsonObj.ToJSON, Length(jsonObj.ToJSON));
        log('JSON ENVIADO');
        log(dados);

        if tipo = TEFElginCancelamento then
        begin
          ret := FuncoesDLL.ElginTEF_RealizarCancelametoTEF(dados, lenght);
        end
        else if tipo = TEFElginConfiguracao then
        begin
          ret := FuncoesDLL.ElginTEF_RealizarConfiguracao(dados, lenght);
        end
        else if tipo = TEFElginReimpressao then
        begin
          ret := FuncoesDLL.ElginTEF_RealizarAdmTEF(TEFElginReimpressao, dados, lenght)
        end
        else
        begin
          ret := FuncoesDLL.ElginTEF_RealizarPagamentoTEF(tipo, dados, lenght);
        end;


        log('ElginTEF_RealizarPagamentoTEF:[ret]'+ IntToStr(ret));

        setstring(aux,dados, lenght);

        FreeMem(dados);

        log('JSON RETORNADO');
        log(aux);
        jsonObj := TJSONObject.ParseJSONValue(aux)as TJSONObject;

        {
          O Metodo synchronize é utilizado para atualizar os componentes de tela
          Os processos executados dentro deste método são direcionados para a
          Thread principal executar, pois os objetos da VCL não podem ser
          diretamente atualizados em uma Thread que não seja a principal.
        }
        TThread.Synchronize(nil, procedure begin ProcessaComponentesTela(aux)end);

      until ((jsonObj.GetValue<string>('SequenciaCaptura') = '99') or (jsonObj.GetValue<boolean>('AbortarFluxoCaptura') = true));

      if tipo <> TEFElginConfiguracao then
      begin
         //ERRO NA EXECUÇÃO DA VENDA, CONSULTAR DOCUMENTAÇÃO
        if ret <> 0 then
        begin
          ShowMessage('ERRO NO PAGAMENTO: ' + IntToStr(ret));
          log('ERRO NO PAGAMENTO: ' + IntToStr(ret));
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
      end;

      except
      on E : Exception do
      begin
        aux := 'Exception [nome da classe]: '+ E.ClassName +
               #13#10 + 'Exception [mensagem]: '+E.Message +
               #13#10 + 'PILHA: ' + E.StackTrace;

        ShowMessage(aux);
        log(aux);
      end
    end;
  end
  );

  log('Inicializando thread de pagamento...');
  myThread.start();

end;

procedure TForm2.btnCancClick(Sender: TObject);
var
  jp : TJSONPair;
begin
  jp := jsonObj.RemovePair('TipoFluxo');
  jp.JsonValue.Free;
  jsonObj.AddPair('TipoFluxo', TJSONNumber.Create(TEFElginFluxo_Cancelar));
  myThread.Resume;
  caso := -1;
end;

procedure TForm2.btnOKClick(Sender: TObject);
var
  jp : TJSONPair;
begin
  jp := jsonObj.RemovePair('TipoFluxo');
  jp.JsonValue.Free;
  jsonObj.AddPair('TipoFluxo', TJSONNumber.Create(TEFElginFluxo_Prosseguir));
  MaquinaEstados
end;

procedure TForm2.btnVoltarClick(Sender: TObject);
var
  jp : TJSONPair;
begin
  jp := jsonObj.RemovePair('TipoFluxo');
  jp.JsonValue.Free;
  jsonObj.AddPair('TipoFluxo', TJSONNumber.Create(TEFElginFluxo_Retornar));
  myThread.Resume;
  caso := -1;
end;

procedure TForm2.Button10Click(Sender: TObject);
begin
  Label1.Caption:='';
end;

procedure TForm2.ButtonGenericClick(Sender: TObject);
begin
  if ValidaCampos then
  begin
    Label1.Caption := Label1.Caption + (Sender as TButton).Caption;
  end;

end;

procedure TForm2.Button12Click(Sender: TObject);     //Cancelamento 
begin

  if Application.MessageBox('Deseja cancelar operação', 'Confirme!', MB_OKCANCEL) = 1 then
  begin
    Form2.Close;

  end;

end;

procedure TForm2.Button13Click(Sender: TObject);
begin
  GroupBox1.Enabled := false;
  ProcessaOperacaoTEF(TEFElginPagtoDebito);
  GroupBox1.Enabled := true;
end;

procedure TForm2.Button14Click(Sender: TObject);
begin
  GroupBox1.Enabled := false;
  ProcessaOperacaoTEF(TEFElginPagtoCredito);
  GroupBox1.Enabled := true;
end;

procedure TForm2.Button15Click(Sender: TObject);
begin
  if Label1.Caption = '' then
  begin
    Application.MessageBox('Informe o valor!','Erro', MB_OK);
    exit;
  end;

  ProcessaOperacaoTEF(TEFElginCancelamento);
end;

procedure TForm2.Button16Click(Sender: TObject);
begin
  ProcessaOperacaoTEF(TEFElginReimpressao);
end;

procedure TForm2.Button17Click(Sender: TObject);
begin
  ProcessaOperacaoTEF(TEFElginConfiguracao);
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ret:Integer;
begin
  ret := FuncoesDLL.ElginTEF_FinalizarOperacaoTEF(TEFElgin_FinalizarAutomacao);
  log('ElginTEF_FinalizarOperacaoTEF: '+ IntToStr(ret));
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Label1.Caption := '';
end;

function TForm2.ValidaCampos: boolean;
begin
  if Length(Label1.Caption) > 5 then
  begin
    result := false;
  end
  else
  begin
    result := true;
  end;
end;

procedure TForm2.MaquinaEstados();
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
        log('InfoCaptura recebeu do textbox:'+Edit1.Text);
        Edit1.Visible := false;

        caso := -1;
        myThread.Resume;
        exit;
      end;

      else ShowMessage('Operação invalida!');
    end;
  end;

procedure TForm2.ProcessaComponentesTela(json: string);
var
    arrayJson, aux:TJSONArray;
    jsonVal, auxObj : TJSONObject;
    I,K, J,valor: Integer;
    List : TStringList;
    NomeComponenteTela,TipoVisor, auxstr:string;

  begin

     jsonVal := TJSONObject.Create;
     jsonVal := TJSONObject.ParseJSONValue(json)as TJSONObject;

     arrayJson := jsonVal.GetValue('ComponentesTela')as TJSONArray;

     {DESABILITA OS BOTÕES PARA QUE ELES SEJA HABILITADOS DURANTE AS ITERAÇÕES
     DO FOR DE PROCESSAMENTO DE COMPONENTES DA TELA}
     btnOK.Visible := false;
     btnCanc.Visible := false;
     btnVoltar.Visible := false;
     Edit1.Visible := False;
     ListBox1.Visible := false;

     for I := 0 to arrayJson.Count-1 do
     begin

      NomeComponenteTela := arrayJson.Items[I].GetValue<string>('NomeComponenteTela');

      case AnsiIndexStr(NomeComponenteTela,['label','button','listbox','comprovanteloja','comprovantecliente','textbox','dadostransacao']) of
        0:
          begin
            lblProc.Visible := true;
            TipoVisor := arrayJson.Items[I].GetValue<string>('TipoVisor');
            if TipoVisor = 'operador' then
             begin
              auxstr :=  arrayJson.Items[I].GetValue<string>('ConteudoComponenteTela');
              lblProc.Caption := auxstr;
             end;
             if TipoVisor = 'cliente' then
             begin
              auxstr := arrayJson.Items[I].GetValue<string>('ConteudoComponenteTela');
              lblProc2.Caption := auxstr;
             end;
          end;
        1:
          begin
            auxstr := arrayJson.Items[I].GetValue<string>('ConteudoComponenteTela');
            case AnsiIndexStr(auxstr,['Prosseguir','Cancelar','Voltar']) of
              0:
              begin
                btnOK.Visible := true;
              end;
              1:
              begin
                btnCanc.Visible := true;
              end;
              2:
              begin
                btnVoltar.Visible := true;
              end;
            end;
          end;
        2:
          begin
              ListBox1.Clear;
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
        4:ShowMessage(arrayJson.Items[I].GetValue<string>('ConteudoComponenteTela'));
        5:
          begin
            Edit1.Text := arrayJson.Items[I].GetValue<string>('ConteudoComponenteTela');
            Edit1.Visible := true;
            Edit1.SetFocus;
            caso := 1;
            myThread.Suspended := True; //PAUSA A THREAD AGUARDANDO A ENTRADA DO USUARIO...
          end;
        6:
          begin
           List := TStringList.Create;
           auxstr :=  arrayJson.Items[I].GetValue<string>('ConteudoComponenteTela');
           Split(',',auxstr,List);
           ShowMessage(List.Text);
         end;
      end;
      Application.ProcessMessages;
    end;
  end;

end.
