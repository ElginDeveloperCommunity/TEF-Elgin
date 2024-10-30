unit urelatorio;

interface

uses
  Winapi.shellAPI,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Data.DB,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.Grids,
  Vcl.DBGrids;

type
  Tfrmrelatorio = class(TForm)
    DBGridtef: TDBGrid;
    pntitulo: TPanel;
    pnrodape: TPanel;
    btcancelartef: TSpeedButton;
    btcancelar: TSpeedButton;
    btcomprovante: TSpeedButton;
    procedure btcancelarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btcomprovanteClick(Sender: TObject);
    procedure btcancelartefClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmrelatorio: Tfrmrelatorio;

implementation

{$R *.dfm}

uses udm, uprinc;

procedure Tfrmrelatorio.btcancelarClick(Sender: TObject);
begin
   frmrelatorio.Close;
end;

procedure Tfrmrelatorio.btcancelartefClick(Sender: TObject);
begin
   if dm.tbltefNSU.Text<>'' then
      begin
         SA_Cancelar_TEF_ELGIN( dm.tbltefNSU.Text, dm.tbltef.FieldByName('dh').AsDateTime,dm.tbltef.FieldByName('valor').AsFloat);
      end
   else
      begin
         beep;
         ShowMessage('Não existe nenhuma transação para cancelar !');
      end;
end;

procedure Tfrmrelatorio.btcomprovanteClick(Sender: TObject);
begin
   if fileexists(GetCurrentDir+'\comprovantes\compr_loja_'+dm.tbltefNSU.Text+'.txt') then
      ShellExecute(GetDesktopWindow,'open',pchar(GetCurrentDir+'\comprovantes\compr_loja_'+dm.tbltefNSU.Text+'.txt'),nil,nil,sw_ShowNormal);

end;

procedure Tfrmrelatorio.FormActivate(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   pntitulo.Align := alTop;
   pnrodape.Align := alBottom;
   //---------------------------------------------------------------------------
   DBGridtef.Align := alClient;
   //---------------------------------------------------------------------------
   frmrelatorio.WindowState := wsMaximized;

   //---------------------------------------------------------------------------
   dm.tbltef.Close;
   dm.tbltef.Open;
   dm.tbltef.EmptyDataSet;
   if fileexists(GetCurrentDir+'\tef.xml') then
      dm.tbltef.LoadFromFile(GetCurrentDir+'\tef.xml');


end;

end.
