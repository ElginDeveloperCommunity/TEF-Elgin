program ExemploAPITEFElgin;

uses
  Vcl.Forms,
  FormPrincipal in 'FormPrincipal.pas' {Form1},
  FuncoesDLL in 'FuncoesDLL.pas',
  FormPagamento in 'FormPagamento.pas' {Form2},
  FormADM in 'FormADM.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
