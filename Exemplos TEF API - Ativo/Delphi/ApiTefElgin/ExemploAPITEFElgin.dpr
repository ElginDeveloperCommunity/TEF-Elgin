program ExemploAPITEFElgin;
uses
  Vcl.Forms,
  FormPrincipal in 'FormPrincipal.pas' {frmPrincipal},
  FuncoesDLL in 'FuncoesDLL.pas',
  FormPagamento in 'FormPagamento.pas' {frmPagamento},
  FormADM in 'FormADM.pas' {frmAdm};

{$R *.res}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmPagamento, frmPagamento);
  Application.CreateForm(TfrmAdm, frmAdm);
  Application.Run;
end.
