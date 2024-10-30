unit udm;

interface

uses
  midaslib,
  System.SysUtils,
  System.Classes,
  Data.DB,
  Datasnap.DBClient;

type
  Tdm = class(TDataModule)
    tblconf: TClientDataSet;
    tblconfIMPRESSORAPortaNome: TStringField;
    tblconfIMPRESSORAModelo: TIntegerField;
    tblconfIMPRESSORAAvanco: TIntegerField;
    tbltef: TClientDataSet;
    dtstef: TDataSource;
    tblconfELGIN_ComprovanteCliente: TIntegerField;
    tblconfELGIN_ComprovanteLoja: TIntegerField;
    tblconfELGIN_SalvarLOG: TBooleanField;
    tblconfELGIN_ImpressaoReduzida: TBooleanField;
    tblconfELGIN_ComprovanteSimplificado: TBooleanField;
    tbltefdh: TDateTimeField;
    tbltefforma: TStringField;
    tbltefNSU: TStringField;
    tbltefvalor: TFloatField;
    tbltefRede_Adquirente: TStringField;
    tbltefPagamento_Cartao: TStringField;
    tbltefPagamento_Tipo: TStringField;
    tbltefCodigo_de_Autorizacao: TStringField;
    tbltefDocumento_numero: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   tblconf.CreateDataSet;
   tblconf.Open;
   tblconf.EmptyDataSet;
   if fileexists(GetCurrentDir+'\config.xml') then  // Verificando se o arquivo de configurações existe na pasta (diretório) corrente
      tblconf.LoadFromFile(GetCurrentDir+'\config.xml')  // Carregar o arquivo de configurações para o DataSet
   else
      begin
         //---------------------------------------------------------------------
         //   Se o arquivo de configurações não existir, criar com as configurações padrão
         //---------------------------------------------------------------------
         tblconf.Append;
         //---------------------------------------------------------------------
         dm.tblconf.FieldByName('ELGIN_ComprovanteCliente').AsInteger           := 1;
         dm.tblconf.FieldByName('ELGIN_ComprovanteLoja').AsInteger              := 1;
         dm.tblconf.FieldByName('ELGIN_SalvarLOG').AsBoolean                    := true;
         dm.tblconf.FieldByName('ELGIN_ImpressaoReduzida').AsBoolean            := true;
         dm.tblconf.FieldByName('ELGIN_ComprovanteSimplificado').AsBoolean  := true;
         //---------------------------------------------------------------------
         tblconf.FieldByName('IMPRESSORAPortaNome').AsString          := '';
         tblconf.FieldByName('IMPRESSORAModelo').AsInteger            := 4;  // Padrão EPSON
         tblconf.FieldByName('IMPRESSORAAvanco').AsInteger            := 5;  //  Padrão 5 linhas
         tblconf.Post;
         tblconf.SaveToFile('config.xml');
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
   // Operações TEF realizadas
   //---------------------------------------------------------------------------
   tbltef.CreateDataSet;
   tbltef.Open;
   tbltef.EmptyDataSet;
   if fileexists(GetCurrentDir+'\tef.xml') then
      tbltef.LoadFromFile(GetCurrentDir+'\tef.xml');
   if not DirectoryExists(GetCurrentDir+'\comprovantes') then
      createdir(GetCurrentDir+'\comprovantes');
   //---------------------------------------------------------------------------
end;

end.
