unit FormPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Imaging.GIFImg, Vcl.ExtCtrls, FuncoesDLL;
//
// Aplicativo Exemplo para E1_Tef Api, versão Delphi VCL
// Gabriel Franzeri @ Elgin, 2022
//

type
  TfrmPrincipal = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    ComboBox2: TComboBox;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses FormPagamento, FormAdm;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
var
a : Integer;
dados : string;
begin
a := ComboBox2.ItemIndex;
if  a = -1 then
begin
  ShowMessage('Selecione o tipo de opera��o!');
  ComboBox2.SetFocus;
  exit;
end;

if a = 0 then
  frmPagamento.ShowModal;

if a = 1 then
  frmAdm.ShowModal;

end;


end.
