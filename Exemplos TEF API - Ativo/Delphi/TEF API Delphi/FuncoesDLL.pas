unit FuncoesDLL;


interface

  function ElginTEF_Autenticador():Integer;stdcall; external 'APITEFElgin.dll';

  function ElginTEF_IniciarOperacaoTEF():Integer; stdcall; external 'APITEFElgin.dll';

  function ElginTEF_RealizarPagamentoTEF(codigoOperacao:Integer; dadosCaptura:PAnsiChar; var tamDados:Integer):Integer; stdcall; external 'APITEFElgin.dll';

  function ElginTEF_RealizarPagamentoTEF2(codigoOperacao:Integer; dadosCaptura:PAnsiChar):String; stdcall; external 'APITEFElgin.dll';

  function ElginTEF_RealizarAdmTEF(codigoOperacao:Integer; dadosCaptura:PAnsiChar; var tamDados:Integer):Integer;stdcall;external 'APITEFElgin.dll';

  function ElginTEF_RealizarAdmTEF2(codigoOperacao:Integer; &dadosCaptura:PChar):String;stdcall;external 'APITEFElgin.dll';

  function ElginTEF_ConfirmarOperacaoTEF(acao:Integer):Integer; stdcall; external 'APITEFElgin.dll';

  function ElginTEF_FinalizarOperacaoTEF(encerramento:Integer):Integer; stdcall; external 'APITEFElgin.dll';

  function ElginTEF_RealizarCancelametoTEF(dadosCaptura:PAnsiChar; var tamDados:Integer):Integer; stdcall; external 'APITEFElgin.dll';

  function ElginTEF_RealizarConfiguracao(dadosCaptura:PAnsiChar; var tamDados:Integer):Integer; stdcall; external 'APITEFElgin.dll';

implementation

end.
