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
    tbltefcorrelationId: TStringField;
    tbltefidPayer: TStringField;
    tbltefacquirer: TStringField;
    tbltefflag: TStringField;
    tbltefoperationType: TStringField;
    tbltefcompanyId: TStringField;
    tbltefstoreId: TStringField;
    tbltefterminalId: TStringField;
    tbltefvalue: TFloatField;
    tbltefpaymentMethod: TStringField;
    tbltefpaymentType: TStringField;
    tbltefpaymentMethodSubType: TStringField;
    tbltefinstallments: TIntegerField;
    tbltefcardNumber: TStringField;
    tbltefpaymentDate: TStringField;
    tblteftransactionDateTime: TStringField;
    tbltefthirdPartyId: TStringField;
    tbltefauthorizerId: TStringField;
    tbltefauthorizerUsn: TStringField;
    tbltefdocumentNumber: TStringField;
    tbltefshopTextReceipt: TMemoField;
    tbltefcustomerTextReceipt: TMemoField;
    tbltefreducedShopPaymentReceipt: TMemoField;
    tbltefreducedCustomerPaymentReceipt: TMemoField;
    tbltefrejectionCode: TStringField;
    tbltefrejectionMessage: TStringField;
    tbltefpaymentProvider: TStringField;
    dtstef: TDataSource;
    tblconfELGIN_ComprovanteCliente: TIntegerField;
    tblconfELGIN_ComprovanteLoja: TIntegerField;
    tblconfELGIN_SalvarLOG: TBooleanField;
    tblconfELGIN_ImpressaoReduzida: TBooleanField;
    tblconfELGIN_ComprovanteSimplificado: TBooleanField;
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
   if fileexists(GetCurrentDir+'\config.xml') then  // Verificando se o arquivo de configura��es existe na pasta (diret�rio) corrente
      tblconf.LoadFromFile(GetCurrentDir+'\config.xml')  // Carregar o arquivo de configura��es para o DataSet
   else
      begin
         //---------------------------------------------------------------------
         //   Se o arquivo de configura��es n�o existir, criar com as configura��es padr�o
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
         tblconf.FieldByName('IMPRESSORAModelo').AsInteger            := 4;  // Padr�o EPSON
         tblconf.FieldByName('IMPRESSORAAvanco').AsInteger            := 5;  //  Padr�o 5 linhas
         tblconf.Post;
         tblconf.SaveToFile('config.xml');
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
   // Opera��es TEF realizadas
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
