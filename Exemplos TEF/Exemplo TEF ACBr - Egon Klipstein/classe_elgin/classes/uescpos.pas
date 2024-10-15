unit uescpos;

interface

uses
   ACBrPosPrinter,
   System.Classes,
   System.SysUtils;

type
  TESCPos = class

  const
     MInicializar = '</zera>';
     Barra        = '<ean13>';
     DBarra       = '</ean13>';
     MGaveta      = '</abre_gaveta>';
     MGuilhotina  = '</corte_total>';
     Negrito      = '<n>';
     DNegrito     = '</n>';
     Comprimido   = '<c>';
     DComprimido  = '</c>';
     Expandido    = '<e>';
     DExpandido   = '</e>';
     MBEEP        = '</beep>';
     QRCode       = '<qrcode_error>0</qrcode_error><qrcode>';
     DQRCode      = '</qrcode>';
  private
     //-------------------------------------------------------------------------
     LModeloImpressoraACBR   : TACBrPosPrinterModelo;
     LPortaImpressora        : string;
     //-------------------------------------------------------------------------
     LCabecalho         : TStringList;
     LCorpo             : TStringList;
     LRodape            : TStringList;
     LImprimirCabecalho : boolean;
     LAvanco            : integer;
     LColunas           : integer;
     LMargemEsquerda    : integer;
     //-------------------------------------------------------------------------
     function Read_SA_ESCPOS_Largura_Linha_Normal: integer;
     function Read_SA_ESCPOS_Largura_Linha_Comprimida: integer;
     function Read_SA_ESCPOS_Largura_Linha_Expandida: integer;
     procedure SA_Set_ModeloImpressoraACBR(const Value: TACBrPosPrinterModelo);
     procedure SA_Set_PortaImpressora(const Value: string);
     procedure SASet_PaginadeCodigo(const Value: TACBrPosPaginaCodigo);
     function Read_SA_PaginadeCodigo: TACBrPosPaginaCodigo;
     procedure SA_SetColunas(const Value: integer);
    procedure SA_SetMargemEsquerda(const Value: integer);
  public
     //-------------------------------------------------------------------------
     ImpressoraPOSPrinter : TACBrPosPrinter;
     //-------------------------------------------------------------------------
     constructor Create();
     destructor free();
     //-------------------------------------------------------------------------
     property ModeloImpressoraACBR : TACBrPosPrinterModelo read LModeloImpressoraACBR write SA_Set_ModeloImpressoraACBR;
     property PortaImpressora      : string read LPortaImpressora write SA_Set_PortaImpressora;
     property PaginadeCodigo       : TACBrPosPaginaCodigo read Read_SA_PaginadeCodigo write SASet_PaginadeCodigo;
     //-------------------------------------------------------------------------
     property Cabecalho         : TStringList read LCabecalho write LCabecalho;
     property Corpo             : TStringList read LCorpo write LCorpo;
     property Rodape            : TStringList read LRodape write LRodape;
     property ImprimirCabecalho : boolean read LImprimirCabecalho write LImprimirCabecalho;
     property Avanco            : integer read LAvanco write LAvanco;
     property MLNormal          : integer read Read_SA_ESCPOS_Largura_Linha_Normal;
     property MLComprimida      : integer read Read_SA_ESCPOS_Largura_Linha_Comprimida;
     property MLExpandida       : integer read Read_SA_ESCPOS_Largura_Linha_Expandida;
     property MAvanco           : integer read LAvanco;
     property Colunas           : integer read LColunas write SA_SetColunas;
     property MargemEsquerda    : integer read LMargemEsquerda write SA_SetMargemEsquerda;
     //-------------------------------------------------------------------------
     function MBarra(codigo : string) : string;
     function MNegrito(palavra : string) : string;
     function MComprimir(palavra : string) : string;
     function MExpandir(palavra : string) : string;
     function MQrCode(frase:string): string;
     //-------------------------------------------------------------------------
     procedure SA_Imprimir(qtde : integer);
     procedure SA_Acionar_Gaveta;
     procedure SA_Acionar_Guilhotina;

  end;

implementation



{ TESCPos }

//------------------------------------------------------------------------------
//   Função para decompor string
//------------------------------------------------------------------------------
procedure TESCPos.SASet_PaginadeCodigo(const Value: TACBrPosPaginaCodigo);
begin
   ImpressoraPOSPrinter.PaginaDeCodigo := Value;
end;

procedure TESCPos.SA_Acionar_Gaveta;
begin
   ImpressoraPOSPrinter.Ativar;
   ImpressoraPOSPrinter.AbrirGaveta();
   ImpressoraPOSPrinter.Desativar;
end;

procedure TESCPos.SA_Acionar_Guilhotina;
begin
   ImpressoraPOSPrinter.Ativar;
   ImpressoraPOSPrinter.CortarPapel();
   ImpressoraPOSPrinter.Desativar;
end;

procedure TESCPos.SA_Imprimir(qtde: integer);
var
   d : integer;
begin
   ImpressoraPOSPrinter.Buffer.Clear;
   if LImprimirCabecalho then
      ImpressoraPOSPrinter.Buffer.AddStrings(LCabecalho);
   ImpressoraPOSPrinter.Buffer.AddStrings(LCorpo);
   ImpressoraPOSPrinter.Buffer.AddStrings(LRodape);
   for d := 1 to qtde do
      begin
         try
            ImpressoraPOSPrinter.Ativar;
            ImpressoraPOSPrinter.Imprimir;
            ImpressoraPOSPrinter.Desativar;
         except

         end;
      end;
   ImpressoraPOSPrinter.Buffer.Clear;
   LCorpo.Clear;
end;

//------------------------------------------------------------------------------
procedure TESCPos.SA_SetColunas(const Value: integer);
begin
   LColunas := value;
   ImpressoraPOSPrinter.ColunasFonteNormal := LColunas;
end;

procedure TESCPos.SA_SetMargemEsquerda(const Value: integer);
begin
   LMargemEsquerda := Value;
   ImpressoraPOSPrinter.ConfigModoPagina.Esquerda := LMargemEsquerda;
end;

procedure TESCPos.SA_Set_ModeloImpressoraACBR( const Value: TACBrPosPrinterModelo);
begin
   ImpressoraPOSPrinter.Modelo := Value;
end;

procedure TESCPos.SA_Set_PortaImpressora(const Value: string);
begin
   ImpressoraPOSPrinter.Porta := value;
end;

destructor TESCPos.free;
begin
   LCabecalho.Free;
   LCorpo.Free;
   LRodape.Free;
   ImpressoraPOSPrinter.Free;
end;

function TESCPos.MBarra(codigo: string): string;
begin
   Result := Barra+copy(codigo,1,12)+DBarra;
end;


function TESCPos.MComprimir(palavra: string): string;
begin
   Result := Comprimido+palavra+DComprimido;
end;

function TESCPos.MExpandir(palavra: string): string;
begin
   Result := Expandido+palavra+DExpandido;
end;


constructor TESCPos.Create;
begin
   ImpressoraPOSPrinter         := TACBrPosPrinter.Create(nil);
   ImpressoraPOSPrinter.ColunasFonteNormal := 48;
//   ImpressoraPOSPrinter.ConfigModoPagina.EspacoEntreLinhas := 1;
   LMargemEsquerda              := 1;
   LCabecalho                   := TStringList.Create;
   LCorpo                       := TStringList.Create;
   LRodape                      := TStringList.Create;
   inherited;
end;


function TESCPos.MNegrito(palavra: string): string;
begin
   Result := Negrito+palavra+DNegrito;
end;

function TESCPos.MQrCode(frase: string): string;
begin
   Result := QRCode+frase+DQRCode;
end;

function TESCPos.Read_SA_ESCPOS_Largura_Linha_Comprimida: integer;
begin
   Result := ImpressoraPOSPrinter.ColunasFonteCondensada;
end;

function TESCPos.Read_SA_ESCPOS_Largura_Linha_Expandida: integer;
begin
   Result := ImpressoraPOSPrinter.ColunasFonteExpandida;
end;

function TESCPos.Read_SA_ESCPOS_Largura_Linha_Normal: integer;
begin
   Result := ImpressoraPOSPrinter.ColunasFonteNormal;
end;

function TESCPos.Read_SA_PaginadeCodigo: TACBrPosPaginaCodigo;
begin
   Result := ImpressoraPOSPrinter.PaginaDeCodigo;
end;

end.
