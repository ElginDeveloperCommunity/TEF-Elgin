unit TEFElginDadosCaptura;

interface

uses
  Classes, SysUtils, Rest.Json, contnrs;

type

  TTipoComponenteTela = (ctLabel, ctTextBox, ctListBox, ctButton, ctSeguirFluxo,
    ctComprovante);

  TTipoFluxo = (flSolicitacaoDeCaptura, flProsseguirCaptura, flCancelarOperacao,
    flRetornarCaptura, flSeguirOFluxo);

  TFormatoCampos = (fcDDMMAA, fcDDMM, fcMMAA, fcHHMMSS, fcNumerico, fcSenha,
    fcNumerico4Digitos, fcAlfaNumerico, fcDDMMAAAA);

  { TComponenteTela }

  TComponenteTela = class
  private
    FCodigoComponenteTela: TTipoComponenteTela;
    FConteudoComponente: String;
    FFormatoDeCaptura: TFormatoCampos;
    FNomeComponente: String;
  public
    constructor Create;
    procedure Clear;

    property CodigoComponenteTela: TTipoComponenteTela read FCodigoComponenteTela write FCodigoComponenteTela;
    property NomeComponente: String read FNomeComponente write FNomeComponente;
    property ConteudoComponente: String read FConteudoComponente write FConteudoComponente;
    property FormatoDeCaptura: TFormatoCampos read FFormatoDeCaptura write FFormatoDeCaptura;
  end;

  { TComponentesTela }

  TComponentesTela = class(TObjectList)
  protected
    procedure SetObject (Index: Integer; Item: TComponenteTela);
    function GetObject (Index: Integer): TComponenteTela;
    procedure Insert (Index: Integer; Obj: TComponenteTela);
  public
    function New: TComponenteTela;
    function Add (Obj: TComponenteTela): Integer;
    property Objects [Index: Integer]: TComponenteTela
      read GetObject write SetObject; default;
  end;

  { TDadosCaptura }

  TDadosCaptura = class

  private
    FAbortarFluxoCaptura: Boolean;
    FComponentesTela: TComponentesTela;
    FFormatoInfoCaptura: TFormatoCampos;
    FInfoCaptura: String;
    FSequenciaCaptura: Integer;
    FTipoFluxo: TTipoFluxo;

    function GetAsJSon: String;
    procedure SetAsJSon(AValue: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    property AsJSon: String read GetAsJSon write SetAsJSon;

    property SequenciaCaptura: Integer read FSequenciaCaptura write FSequenciaCaptura;
    property TipoFluxo: TTipoFluxo read FTipoFluxo write FTipoFluxo;
    property InfoCaptura: String read FInfoCaptura write FInfoCaptura;
    property FormatoInfoCaptura: TFormatoCampos read FFormatoInfoCaptura write FFormatoInfoCaptura;
    property ComponentesTela: TComponentesTela read FComponentesTela;
    property AbortarFluxoCaptura: Boolean read FAbortarFluxoCaptura write FAbortarFluxoCaptura;
  end;

implementation

{ TComponenteTela }

constructor TComponenteTela.Create;
begin
  inherited Create;
  Clear;
end;

procedure TComponenteTela.Clear;
begin
  FCodigoComponenteTela := ctLabel;
  FFormatoDeCaptura := fcNumerico;
  FConteudoComponente := '';
  FNomeComponente := '';
end;

{ TComponentesTela }

procedure TComponentesTela.SetObject(Index: Integer; Item: TComponenteTela);
begin
  inherited SetItem (Index, Item) ;
end;

function TComponentesTela.GetObject(Index: Integer): TComponenteTela;
begin
  Result := inherited GetItem(Index) as TComponenteTela ;
end;

procedure TComponentesTela.Insert(Index: Integer; Obj: TComponenteTela);
begin
  inherited Insert(Index, Obj);
end;

function TComponentesTela.New: TComponenteTela;
begin
  Result := TComponenteTela.create;
  Add(Result);
end;

function TComponentesTela.Add(Obj: TComponenteTela): Integer;
begin
  Result := inherited Add(Obj) ;
end;

{ TDadosCaptura }

constructor TDadosCaptura.Create;
begin
  inherited Create;

  FComponentesTela := TComponentesTela.Create(True);
end;

destructor TDadosCaptura.Destroy;
begin
  FComponentesTela.Free;
  inherited Destroy;
end;

procedure TDadosCaptura.Clear;
begin
  FAbortarFluxoCaptura := False;
  FComponentesTela.Clear;
  FFormatoInfoCaptura := fcNumerico;
  FInfoCaptura := '';
  FSequenciaCaptura := 0;
  FTipoFluxo := flSolicitacaoDeCaptura;
end;

function TDadosCaptura.GetAsJSon: String;
var
  AJSon, AJSonCompTela: TJSONObject;
  AJSonArrComponentesTela: TJSONArray;
  I: Integer;
begin
  AJSonArrComponentesTela := Nil;
  AJSon := TJSONObject.Create;
  try
    AJSon.Add('SequenciaCaptura', SequenciaCaptura);
    AJSon.Add('TipoFluxo', Integer(TipoFluxo));
    AJSon.Add('InfoCaptura', InfoCaptura);

    if (ComponentesTela.Count > 0) then
    begin
      AJSonArrComponentesTela := TJSONArray.Create;
      For I := 0 to ComponentesTela.Count-1 do
      begin
        AJSonCompTela := TJSONObject.Create;
        AJSonCompTela.Add('CodigoComponenteTela', Integer(ComponentesTela[I].CodigoComponenteTela));
        AJSonCompTela.Add('NomeComponenteTela', ComponentesTela[I].NomeComponente);
        AJSonCompTela.Add('ConteudoComponenteTela', ComponentesTela[I].ConteudoComponente);
        AJSonCompTela.Add('FormatoDeCaptura', Integer(ComponentesTela[I].FormatoDeCaptura));
        AJSonArrComponentesTela.Add(AJSonCompTela);
      end;
    end;

    AJSon.Add('CompoenentesTela', AJSonArrComponentesTela);
    AJSon.Add('AbortarFluxoCaptura', AbortarFluxoCaptura);
    AJSon.Add('FormatoInfoCaptura', Integer(FormatoInfoCaptura));

    Result := AJSon.AsJSON;
  finally
    AJSon.Free;
  end;
end;

procedure TDadosCaptura.SetAsJSon(AValue: String);
var
  AJSonCompTela: TJSONObject;
  AJSonArrComponentesTela: TJSONArray;
  I: Integer;
  AJSon: TJSONData;
begin
  AJSon := GetJSON(AValue);
  try
    with TJSONObject(AJSon) do
    begin
      SequenciaCaptura := Get('SequenciaCaptura', 0);
      TipoFluxo := TTipoFluxo( Get('TipoFluxo', 4) );
      InfoCaptura := Get('InfoCaptura', '');
      AbortarFluxoCaptura := Get('AbortarFluxoCaptura', False);
      FormatoInfoCaptura := TFormatoCampos( Get('FormatoInfoCaptura', Integer(fcNumerico)));

      ComponentesTela.Clear;
      AJSonArrComponentesTela := Nil;
      AJSonArrComponentesTela := Get('CompoenentesTela', AJSonArrComponentesTela);
      if Assigned(AJSonArrComponentesTela) then
      begin
        for I := 0 to AJSonArrComponentesTela.Count-1 do
        begin
          with ComponentesTela.New do
          begin
            AJSonCompTela := TJSONObject( AJSonArrComponentesTela.Items[I] );
            CodigoComponenteTela := TTipoComponenteTela( AJSonCompTela.Get('CodigoComponenteTela', 0) );
            NomeComponente := AJSonCompTela.Get('NomeComponenteTela', '');
            ConteudoComponente := AJSonCompTela.Get('ConteudoComponenteTela', '');
            FormatoDeCaptura := TFormatoCampos(AJSonCompTela.Get('FormatoDeCaptura', Integer(fcNumerico)));
          end;
        end;
      end;
    end;
  finally
    AJSon.Free;
  end;
end;

end.

