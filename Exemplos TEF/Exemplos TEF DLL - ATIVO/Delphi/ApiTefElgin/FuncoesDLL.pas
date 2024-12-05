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

var
  SetClientTCP: TSetClientTCP = nil;
  ConfigurarDadosPDV: TConfigurarDadosPDV = nil;
  IniciarOperacaoTEF: TIniciarOperacaoTEF = nil;
  RecuperarOperacaoTEF: TRecuperarOperacaoTEF = nil;
  RealizarPagamentoTEF: TRealizarPagamentoTEF = nil;
  RealizarPixTEF: TRealizarPixTEF = nil;
  RealizarAdmTEF: TRealizarAdmTEF = nil;
  ConfirmarOperacaoTEF: TConfirmarOperacaoTEF = nil;
  FinalizarOperacaoTEF: TFinalizarOperacaoTEF = nil;
  RealizarColetaPinPad: TRealizarColetaPinPad = nil;
  ConfirmarCapturaPinPad: TConfirmarCapturaPinPad = nil;

function LoadElginDLL(const ADLLPath: string): Boolean;
procedure LoadAllDLLs();
procedure UnloadElginDLL;

implementation

var
  vDLLHandle: THandle = 0;

function LoadElginDLL(const ADLLPath: string): Boolean;
begin
  Result := False;

  if not TFile.Exists(ADLLPath) then
    raise Exception.CreateFmt('DLL não foi encontrada: %s', [ADLLPath]);

  vDLLHandle := LoadLibrary(PChar(ADLLPath));
  if vDLLHandle = 0 then
  begin
    raise Exception.CreateFmt('Erro ao carregar a DLL: %s', [ADLLPath]);
  end;

  if ADLLPath = ('C:\Elgin\TEF\E1_Tef01.dll') then
  begin
    SetClientTCP := GetProcAddress(vDLLHandle, 'SetClientTCP');
    ConfigurarDadosPDV := GetProcAddress(vDLLHandle, 'ConfigurarDadosPDV');
    IniciarOperacaoTEF := GetProcAddress(vDLLHandle, 'IniciarOperacaoTEF');
    RecuperarOperacaoTEF := GetProcAddress(vDLLHandle, 'RecuperarOperacaoTEF');
    RealizarPagamentoTEF := GetProcAddress(vDLLHandle, 'RealizarPagamentoTEF');
    RealizarPixTEF := GetProcAddress(vDLLHandle, 'RealizarPixTEF');
    RealizarAdmTEF := GetProcAddress(vDLLHandle, 'RealizarAdmTEF');
    ConfirmarOperacaoTEF := GetProcAddress(vDLLHandle, 'ConfirmarOperacaoTEF');
    FinalizarOperacaoTEF := GetProcAddress(vDLLHandle, 'FinalizarOperacaoTEF');
    RealizarColetaPinPad := GetProcAddress(vDLLHandle, 'RealizarColetaPinPad');
    ConfirmarCapturaPinPad := GetProcAddress(vDLLHandle, 'ConfirmarCapturaPinPad');

    if not Assigned(SetClientTCP) or not Assigned(ConfigurarDadosPDV) or
       not Assigned(IniciarOperacaoTEF) or not Assigned(RecuperarOperacaoTEF) or
       not Assigned(RealizarPagamentoTEF) or not Assigned(RealizarPixTEF) or
       not Assigned(RealizarAdmTEF) or not Assigned(ConfirmarOperacaoTEF) or
       not Assigned(FinalizarOperacaoTEF) or not Assigned(RealizarColetaPinPad) or
       not Assigned(ConfirmarCapturaPinPad) then
    begin
      FreeLibrary(vDLLHandle);
      raise Exception.CreateFmt('Não foi possível carregar as funções da DLL Elgin: %s', [ADLLPath]);
    end;
  end;

  Result := True;
end;

procedure LoadAllDLLs();
const
  DLL_FOLDER = 'C:\Elgin\TEF\';
var
  vDLLPaths: TList<string>;
  vKey, vDLLPath: string;
begin
  vDLLPaths := TList<string>.Create();
  try
    vDLLPaths.Add(DLL_FOLDER + 'libwinpthread-1.dll');
    vDLLPaths.Add(DLL_FOLDER + 'libgcc_s_dw2-1.dll');
    vDLLPaths.Add(DLL_FOLDER + 'libstdc++-6.dll');
    vDLLPaths.Add(DLL_FOLDER + 'Qt5Core.dll');
    vDLLPaths.Add(DLL_FOLDER + 'Qt5Network.dll');
    vDLLPaths.Add(DLL_FOLDER + 'Qt5Gui.dll');
    vDLLPaths.Add(DLL_FOLDER + 'Qt5Xml.dll');
    vDLLPaths.Add(DLL_FOLDER + 'E1_Tef01.dll');

   for vDLLPath in vDLLPaths do
   begin
      try
        if not LoadElginDLL(vDLLPath) then
          raise Exception.CreateFmt('Erro ao carregar DDL de dependência: %s', [vKey]);
      except
        on E: Exception do
          raise Exception.CreateFmt('Erro ao carregar DDL de dependência %s: %s', [vKey, E.Message]);
      end;
    end;
  finally
    vDLLPaths.Free();
  end;
end;

procedure UnloadElginDLL();
begin
  if vDLLHandle <> 0 then
  begin
    FreeLibrary(vDLLHandle);
    vDLLHandle := 0;
  end;

  @SetClientTCP := nil;
  @ConfigurarDadosPDV := nil;
  @IniciarOperacaoTEF := nil;
  @RecuperarOperacaoTEF := nil;
  @RealizarPagamentoTEF := nil;
  @RealizarPixTEF := nil;
  @RealizarAdmTEF := nil;
  @ConfirmarOperacaoTEF := nil;
  @FinalizarOperacaoTEF := nil;
  @RealizarColetaPinPad := nil;
  @ConfirmarCapturaPinPad := nil;
end;

end.
