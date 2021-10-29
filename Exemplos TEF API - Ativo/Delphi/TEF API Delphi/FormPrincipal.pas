unit FormPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Imaging.GIFImg, Vcl.ExtCtrls, FuncoesDLL;

type
  TForm1 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    ComboBox2: TComboBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses FormPagamento, FormADM;

procedure TForm1.Button1Click(Sender: TObject);
var
a : Integer;
dados : string;
begin
a := ComboBox2.ItemIndex;
if  a = -1 then
begin
  ShowMessage('Selecione o tipo de operação!');
  ComboBox2.SetFocus;
  exit;
end;

if a = 0 then
  Form2.ShowModal;

if a = 1 then
  Form3.ShowModal;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    FuncoesDLL.ElginTEF_FinalizarOperacaoTEF(1);
end;

end.
