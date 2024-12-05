unit FuncoesDLL;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections;

type
  TSetClientTCP = function(ip: PAnsiChar; porta: Integer): PAnsiChar; stdcall;
  TConfigurarDadosPDV = function(textoPinpad, versaoAC, nomeEstabelecimento, loja, identificadorPontoCaptura: PAnsiChar): PAnsiChar; stdcall;
  TIniciarOperacaoTEF = function(dadosCaptura: PAnsiChar): PAnsiChar; stdcall;
  TRecuperarOperacaoTEF = function(dadosCaptura: PAnsiChar): PAnsiChar; stdcall;
  TRealizarPagamentoTEF = function(codigoOperacao: Integer; dadosCaptura: PAnsiChar; novaTransacao: Boolean): PAnsiChar; stdcall;
  TRealizarPixTEF = function(dadosCaptura: PAnsiChar; novaTransacao: Boolean): PAnsiChar; stdcall;
  TRealizarAdmTEF = function(codigoOperacao: Integer; dadosCaptura: PAnsiChar; novaTransacao: Boolean): PAnsiChar; stdcall;
  TConfirmarOperacaoTEF = function(id, acao: Integer): PAnsiChar; stdcall;
  TFinalizarOperacaoTEF = function(id: Integer): PAnsiChar; stdcall;
  TRealizarColetaPinPad = function(tipoColeta: Integer; confirmar: Boolean): PAnsiChar; stdcall;
  TConfirmarCapturaPinPad = function(tipoCaptura: Integer; dadosCaptura: PAnsiChar): PAnsiChar; stdcall;

type
  TElginDLL = class (TObject)
  strict private const
    PASTA_DLL = 'C:\Elgin\TEF\';
    DLL_ELGIN = PASTA_DLL + 'E1_Tef01.dll';
  strict private
    FCanExecute: Boolean;
    FDLLPaths: TList<string>;
    FHandles: TList<THandle>;
    FSetClientTCP: TSetClientTCP;
    FConfigurarDadosPDV: TConfigurarDadosPDV;
    FIniciarOperacaoTEF: TIniciarOperacaoTEF;
    FRecuperarOperacaoTEF: TRecuperarOperacaoTEF;
    FRealizarPagamentoTEF: TRealizarPagamentoTEF;
    FRealizarPixTEF: TRealizarPixTEF;
    FRealizarAdmTEF: TRealizarAdmTEF;
    FConfirmarOperacaoTEF: TConfirmarOperacaoTEF;
    FFinalizarOperacaoTEF: TFinalizarOperacaoTEF;
    FRealizarColetaPinPad: TRealizarColetaPinPad;
    FConfirmarCapturaPinPad: TConfirmarCapturaPinPad;
    function LoadDLL(const ADLLName: string): Boolean;
    procedure LoadAllDLLs();
    procedure UnloadAllDLLs();
    procedure InitializeFunctionPointers(const AHandle: THandle);
    procedure ClearFunctionPointers();  
    procedure FillDLLPaths(); 
    function Execute<T>(const ACall: TFunc<T>): T;
  public
    constructor Create();
    destructor Destroy(); override;
    function SetClientTCP(const AIp: string; const APorta: Integer): PAnsiChar;
    function ConfigurarDadosPDV(const ATextoPinpad, AVersaoAC, ANomeEstabelecimento, ALoja, AIdentificadorPontoCaptura: string): PAnsiChar;
    function IniciarOperacaoTEF(const ADadosCaptura: PAnsiChar): PAnsiChar;
    function RecuperarOperacaoTEF(const ADadosCaptura: string): PAnsiChar;
    function RealizarPagamentoTEF(const ACodigoOperacao: Integer; const ADadosCaptura: string; const ANovaTransacao: Boolean): PAnsiChar;
    function RealizarPixTEF(const ADadosCaptura: string; const ANovaTransacao: Boolean): PAnsiChar;
    function RealizarAdmTEF(const ACodigoOperacao: Integer; const ADadosCaptura: string; const ANovaTransacao: Boolean): PAnsiChar;
    function ConfirmarOperacaoTEF(const AId, AACao: Integer): PAnsiChar;
    function FinalizarOperacaoTEF(const AId: Integer): PAnsiChar;
    function RealizarColetaPinPad(const ATipoColeta: Integer; const AConfirmar: Boolean): PAnsiChar;
    function ConfirmarCapturaPinPad(const ATipoCaptura: Integer; const ADadosCaptura: string): PAnsiChar;
  end;

implementation

{ TElginDLL }

constructor TElginDLL.Create();
begin
  FCanExecute := False;
  FDLLPaths := TList<string>.Create();
  FHandles := TList<THandle>.Create();
  Self.FillDLLPaths();
  Self.LoadAllDLLs();
end;

destructor TElginDLL.Destroy();
begin
  Self.UnloadAllDLLs();
  FHandles.Free();
  FDLLPaths.Free();
  inherited;
end;

procedure TElginDLL.FillDLLPaths();
begin
  FDLLPaths.Add(PASTA_DLL + 'libwinpthread-1.dll');
  FDLLPaths.Add(PASTA_DLL + 'libgcc_s_dw2-1.dll');
  FDLLPaths.Add(PASTA_DLL + 'libstdc++-6.dll');
  FDLLPaths.Add(PASTA_DLL + 'Qt5Core.dll');
  FDLLPaths.Add(PASTA_DLL + 'Qt5Network.dll');
  FDLLPaths.Add(PASTA_DLL + 'Qt5Gui.dll');
  FDLLPaths.Add(PASTA_DLL + 'Qt5Xml.dll');
  FDLLPaths.Add(DLL_ELGIN);
end;

function TElginDLL.LoadDLL(const ADLLName: string): Boolean;
var
  vDLLHandle: THandle;
begin
  Result := False;
  if not TFile.Exists(ADLLName) then
    raise Exception.CreateFmt('DLL not found: %s', [ADLLName]);

  vDLLHandle := GetModuleHandle(PChar(ADLLName));
  if vDLLHandle = 0 then
  begin
    vDLLHandle := LoadLibrary(PChar(ADLLName));
    if vDLLHandle = 0 then
      raise Exception.CreateFmt('Error loading DLL: %s', [ADLLName]);
  end;
  FHandles.Add(vDLLHandle);

  if ADLLName = DLL_ELGIN then
    Self.InitializeFunctionPointers(vDLLHandle);
  Result := True;
end;

procedure TElginDLL.UnloadAllDLLs();
begin
  Self.ClearFunctionPointers();
  for var vHandle in FHandles do
    if (GetModuleHandle(PChar(vHandle)) > 0) then
      FreeLibrary(vHandle);
end;

procedure TElginDLL.LoadAllDLLs();
begin
  for var vDLL in FDLLPaths do
  begin
    try
      FCanExecute := Self.LoadDLL(vDLL);
      if not FCanExecute then
        raise Exception.CreateFmt('Erro ao carregar DDL de dependência: %s', [vDLL])
    except
      on E: Exception do
        raise Exception.CreateFmt('Erro ao carregar DDL de dependência %s: %s', [vDLL, E.Message]);
    end;
  end;
end;

procedure TElginDLL.InitializeFunctionPointers(const AHandle: THandle);
begin
  FSetClientTCP := GetProcAddress(AHandle, 'SetClientTCP');
  FConfigurarDadosPDV := GetProcAddress(AHandle, 'ConfigurarDadosPDV');
  FIniciarOperacaoTEF := GetProcAddress(AHandle, 'IniciarOperacaoTEF');
  FRecuperarOperacaoTEF := GetProcAddress(AHandle, 'RecuperarOperacaoTEF');
  FRealizarPagamentoTEF := GetProcAddress(AHandle, 'RealizarPagamentoTEF');
  FRealizarPixTEF := GetProcAddress(AHandle, 'RealizarPixTEF');
  FRealizarAdmTEF := GetProcAddress(AHandle, 'RealizarAdmTEF');
  FConfirmarOperacaoTEF := GetProcAddress(AHandle, 'ConfirmarOperacaoTEF');
  FFinalizarOperacaoTEF := GetProcAddress(AHandle, 'FinalizarOperacaoTEF');
  FRealizarColetaPinPad := GetProcAddress(AHandle, 'RealizarColetaPinPad');
  FConfirmarCapturaPinPad := GetProcAddress(AHandle, 'ConfirmarCapturaPinPad');

  if not Assigned(FSetClientTCP) or not Assigned(FConfigurarDadosPDV) or
     not Assigned(FIniciarOperacaoTEF) or not Assigned(FRecuperarOperacaoTEF) or
     not Assigned(FRealizarPagamentoTEF) or not Assigned(FRealizarPixTEF) or
     not Assigned(FRealizarAdmTEF) or not Assigned(FConfirmarOperacaoTEF) or
     not Assigned(FFinalizarOperacaoTEF) or not Assigned(FRealizarColetaPinPad) or
     not Assigned(FConfirmarCapturaPinPad) then
    raise Exception.CreateFmt('Não foi possível carregar as funções da DLL Elgin: %s', [DLL_ELGIN]);
end;

procedure TElginDLL.ClearFunctionPointers();
begin
  @FSetClientTCP := nil;
  @FConfigurarDadosPDV := nil;
  @FIniciarOperacaoTEF := nil;
  @FRecuperarOperacaoTEF := nil;
  @FRealizarPagamentoTEF := nil;
  @FRealizarPixTEF := nil;
  @FRealizarAdmTEF := nil;
  @FConfirmarOperacaoTEF := nil;
  @FFinalizarOperacaoTEF := nil;
  @FRealizarColetaPinPad := nil;
  @FConfirmarCapturaPinPad := nil;
end;

function TElginDLL.Execute<T>(const ACall: TFunc<T>): T;
begin
  if not FCanExecute then
    Exit();
  try
    Result := ACall();
  except
    on E: Exception do
    begin
      raise Exception.CreateFmt('Erro ao executar função. Detalhes: %s', [E.Message]);
    end;
  end;
end;

function TElginDLL.RealizarAdmTEF(const ACodigoOperacao: Integer; const ADadosCaptura: string; const ANovaTransacao: Boolean): PAnsiChar;
begin
  Result := Self.Execute<PAnsiChar>(
    function: PAnsiChar
    begin
      Result := FRealizarAdmTEF(ACodigoOperacao, PAnsiChar(AnsiString(ADadosCaptura)), ANovaTransacao);
    end
  );
end;

function TElginDLL.RealizarColetaPinPad(const ATipoColeta: Integer; const AConfirmar: Boolean): PAnsiChar;
begin
  Result := Self.Execute<PAnsiChar>(
    function: PAnsiChar
    begin
      Result := FRealizarColetaPinPad(ATipoColeta, AConfirmar);
    end
  );
end;

function TElginDLL.RealizarPagamentoTEF(const ACodigoOperacao: Integer; const ADadosCaptura: string; const ANovaTransacao: Boolean): PAnsiChar;
begin
  Result := Self.Execute<PAnsiChar>(
    function: PAnsiChar
    begin
      Result := FRealizarPagamentoTEF(ACodigoOperacao, PAnsiChar(AnsiString(ADadosCaptura)), ANovaTransacao);
    end
  );
end;

function TElginDLL.RealizarPixTEF(const ADadosCaptura: string; const ANovaTransacao: Boolean): PAnsiChar;
begin
  Result := Self.Execute<PAnsiChar>(
    function: PAnsiChar
    begin
      Result := FRealizarPixTEF(PAnsiChar(AnsiString(ADadosCaptura)), ANovaTransacao);
    end
  );
end;

function TElginDLL.RecuperarOperacaoTEF(const ADadosCaptura: string): PAnsiChar;
begin
  Result := Self.Execute<PAnsiChar>(
    function: PAnsiChar
    begin
      Result := FRecuperarOperacaoTEF(PAnsiChar(AnsiString(ADadosCaptura)));
    end
  );
end;

function TElginDLL.SetClientTCP(const AIp: string; const APorta: Integer): PAnsiChar;
begin
  Result := Self.Execute<PAnsiChar>(
    function: PAnsiChar
    begin
      Result := FSetClientTCP(PAnsiChar(AnsiString(AIp)), APorta);
    end
  );
end;

function TElginDLL.IniciarOperacaoTEF(const ADadosCaptura: PAnsiChar): PAnsiChar;
begin
  Result := Self.Execute<PAnsiChar>(
    function: PAnsiChar
    begin
      Result := FIniciarOperacaoTEF(ADadosCaptura);
    end
  );
end;

function TElginDLL.FinalizarOperacaoTEF(const AId: Integer): PAnsiChar;
begin
  Result := Self.Execute<PAnsiChar>(
    function: PAnsiChar
    begin 
      Result := FFinalizarOperacaoTEF(AId);
    end
  );
end;

function TElginDLL.ConfigurarDadosPDV(const ATextoPinpad, AVersaoAC, ANomeEstabelecimento, ALoja, AIdentificadorPontoCaptura: string): PAnsiChar;
begin
  Result := Self.Execute<PAnsiChar>(
    function: PAnsiChar
    begin
      Result :=  FConfigurarDadosPDV(PAnsiChar(AnsiString(ATextoPinpad)),
                                     PAnsiChar(AnsiString(AVersaoAC)),
                                     PAnsiChar(AnsiString(ANomeEstabelecimento)),
                                     PAnsiChar(AnsiString(ALoja)),
                                     PAnsiChar(AnsiString(AIdentificadorPontoCaptura)));
    end
  );
end;

function TElginDLL.ConfirmarCapturaPinPad(const ATipoCaptura: Integer; const ADadosCaptura: string): PAnsiChar;
begin
  Result := Self.Execute<PAnsiChar>(
    function: PAnsiChar
    begin 
      Result := FConfirmarCapturaPinPad(ATipoCaptura, PAnsiChar(AnsiString(ADadosCaptura)));
    end
  );
end;

function TElginDLL.ConfirmarOperacaoTEF(const AId, AACao: Integer): PAnsiChar;
begin
  Result := Self.Execute<PAnsiChar>(
    function: PAnsiChar
    begin 
      Result := FConfirmarOperacaoTEF(AId, AACao);
    end
  );
end;

end.