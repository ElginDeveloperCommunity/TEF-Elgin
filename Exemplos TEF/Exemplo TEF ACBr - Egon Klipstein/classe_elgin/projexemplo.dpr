program projexemplo;

uses
  Vcl.Forms,
  uprinc in 'uprinc.pas' {frmprinc},
  uconfig in 'uconfig.pas' {frmconfig},
  udm in 'udm.pas' {dm: TDataModule},
  tbotao in 'classes\tbotao.pas',
  uescpos in 'classes\uescpos.pas',
  urelatorio in 'urelatorio.pas' {frmrelatorio},
  uElginTEF in 'classes\uElginTEF.pas',
  uwebtefmp in 'classes\uwebtefmp.pas' {frmwebtef};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrmprinc, frmprinc);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.