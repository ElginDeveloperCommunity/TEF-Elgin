unit tbotao;

interface

uses
   System.UITypes,Vcl.Controls,System.Classes,Vcl.Buttons,Vcl.ExtCtrls,Vcl.Graphics,System.SysUtils;

type
   TTipoBotao = (tpCustom,tpNovo,tpAlterar,tpApagar,tpConfig,tpAgente,tpImprimir,tpOk,tpCancela,tpSalvar);

   TMKMBotao = class

   private
      LTpBotao      : TTipoBotao;
      LPx           : integer;
      LPy           : integer;
      LLargura      : integer;
      LAltura       : integer;
      LLarguraIcone : integer;
      LNome         : string;
      LTexto        : string;
      LCorFundo     : TColor;
      LCorLetra     : TColor;
      LCorIcone     : TColor;
      LArqIcone     : string;
      LPai          : TWinControl;
      LOnClick      : TNotifyEvent;
      LFontSyze     : integer;
      LIconStretch  : boolean;
      LTag          : integer;
      //------------------------------------------------------------------------
      Lbotao  : TSpeedButton;
      Lbox1   : TShape;
      Lbox2   : TShape;
      Limagem : TImage;
      //------------------------------------------------------------------------
      LVisible : boolean;
      //------------------------------------------------------------------------
      procedure MKMtpNovo;
      procedure MKMtpAlterar;
      procedure MKMtpApagar;
      procedure MKMtpConfig;
      procedure MKMtpAgente;
      procedure MKMtpImprimir;
      procedure MKMtpOk;
      procedure MKMtpCancelar;
      procedure MKMtpSalvar;
      procedure SetVisible(const Value: boolean);

   public
      constructor Create;
      destructor free;
      procedure show;
      property TpBotao      : TTipoBotao write LTpBotao;
      property Px           : integer read LPx write LPx;
      property Py           : integer read LPy write LPy;
      property Largura      : integer read LLargura write LLargura;
      property Altura       : integer read LAltura write LAltura;
      property LarguraIcone : integer write LLarguraIcone;
      property Nome         : string write LNome;
      property Texto        : string read LTexto write LTexto;
      property CorFundo     : TColor write LCorFundo;
      property CorLetra     : TColor write LCorLetra;
      property CorIcone     : TColor write LCorIcone;
      property ArqIcone     : string write LArqIcone;
      property Pai          : TWinControl write LPai;
      property OnClick      : TNotifyEvent write LOnClick;
      property FontSize     : integer write LFontSyze;
      property IconStretch  : boolean write LIconStretch;
      property Tag          : integer read LTag write LTag;
      property Visible      : boolean read LVisible write SetVisible;
   end;


implementation

{ TMKMBotao }

constructor TMKMBotao.Create;
begin
   //---------------------------------------------------------------------------
   LFontSyze     := 10;
   LPx           := 5;
   lpy           := 5;
   LLargura      := 250;
   LAltura       := 30;
   LLarguraIcone := 0;
   LNome         := 'MKMbt'+formatdatetime('yyyymmddhhmmsszzz',now);
   LTexto        := LNome;
   LCorFundo     := clSilver;
   LCorLetra     := clBlack;
   LCorIcone     := clWhite;
   IconStretch   := true;
   LTpBotao      := tpCustom;
   LVisible      := true;
   //---------------------------------------------------------------------------
   inherited;
end;

destructor TMKMBotao.free;
begin
   Lbotao.DisposeOf;
   Lbox1.DisposeOf;
   Lbox2.DisposeOf;
   Limagem.DisposeOf;
end;

procedure TMKMBotao.MKMtpAgente;
begin
   LTexto       := '   Cadastro de Agentes';
   LCorFundo    := $00E06C1F;
   LCorLetra    := $00DFFFFF;
   LCorIcone    := $00EEEEEE;
   LIconStretch := false;
   LArqIcone    := ExtractFilePath(ParamStr(0))+'icones\agente.bmp';
end;

procedure TMKMBotao.MKMtpAlterar;
begin
   LTexto    := '   ENTER - Alterar';
   LCorFundo := $00029D25;
   LCorLetra := $00DFFFFF;
   LCorIcone := $00EEEEEE;
   LIconStretch := false;
   LArqIcone    := ExtractFilePath(ParamStr(0))+'icones\alterar.bmp';
end;

procedure TMKMBotao.MKMtpApagar;
begin
   LTexto    := '   DEL - Apagar';
   LCorFundo := $004728D7;
   LCorLetra := $00DFFFFF;
   LCorIcone := $00EEEEEE;
   LIconStretch := false;
   LArqIcone    := ExtractFilePath(ParamStr(0))+'icones\apagar.bmp';
end;

procedure TMKMBotao.MKMtpCancelar;
begin
   LTexto    := '   ESC - Voltar';
   LCorFundo := $004728D7;
   LCorLetra := $00DFFFFF;
   LCorIcone := $00EEEEEE;
   LIconStretch := false;
   LArqIcone    := ExtractFilePath(ParamStr(0))+'icones\voltar.bmp';
end;

procedure TMKMBotao.MKMtpConfig;
begin
   LTexto    := '   Configurações';
   LCorFundo := $00F58798;
   LCorLetra := $00DFFFFF;
   LCorIcone := $00EEEEEE;
   LIconStretch := false;
   LArqIcone    := ExtractFilePath(ParamStr(0))+'icones\config.bmp';
end;

procedure TMKMBotao.MKMtpImprimir;
begin
   LTexto       := '   F5 - Imprimir';
   LCorFundo    := $00949449;
   LCorLetra    := $00DFFFFF;
   LCorIcone    := $00EEEEEE;
   LIconStretch := false;
   LArqIcone    := ExtractFilePath(ParamStr(0))+'icones\imprimir.bmp';
end;

procedure TMKMBotao.MKMtpNovo;
begin
   LTexto       := '   INS - Novo';
   LCorFundo    := $00487807;
   LCorLetra    := $00DFFFFF;
   LCorIcone    := $00EEEEEE;
   LIconStretch := false;
   LArqIcone    := ExtractFilePath(ParamStr(0))+'icones\novo.bmp';
end;

procedure TMKMBotao.MKMtpOk;
begin
   LTexto       := '   ENTER - Ok';
   LCorFundo    := $00029D25;
   LCorLetra    := $00DFFFFF;
   LCorIcone    := $00EEEEEE;
   LIconStretch := false;
   LArqIcone    := ExtractFilePath(ParamStr(0))+'icones\ok.bmp';
end;

procedure TMKMBotao.MKMtpSalvar;
begin
   LTexto       := '   Salvar';
   LCorFundo    := $00029D25;
   LCorLetra    := $00DFFFFF;
   LCorIcone    := $00EEEEEE;
   LIconStretch := false;
   LArqIcone    := ExtractFilePath(ParamStr(0))+'icones\Salvar.bmp';
end;

procedure TMKMBotao.SetVisible(const Value: boolean);
begin
   LVisible        := value;
end;

procedure TMKMBotao.show;
begin
   case LTpBotao of
     tpNovo     : MKMtpNovo;
     tpAlterar  : MKMtpAlterar;
     tpApagar   : MKMtpApagar;
     tpConfig   : MKMtpConfig;
     tpAgente   : MKMtpAgente;
     tpImprimir : MKMtpImprimir;
     tpOk       : MKMtpOk;
     tpCancela  : MKMtpCancelar;
     tpSalvar   : MKMtpSalvar;
   end;
   //---------------------------------------------------------------------------
   Lbox1             := TShape.Create(LPai);
   Lbox1.Top         := LPy;
   Lbox1.Left        := LPx;
   Lbox1.Width       := LLargura;
   Lbox1.Height      := LAltura;
   Lbox1.Brush.Color := LCorFundo;
   Lbox1.Brush.Style := bsSolid;
   Lbox1.Pen.Style   := psClear;
   Lbox1.Shape       := stRoundRect;
   Lbox1.Name        := 'box'+LNome;
   Lbox1.Visible     := true;
   Lbox1.Parent      := LPai;
   Lbox1.Repaint;
   //---------------------------------------------------------------------------
   Lbox2             := TShape.Create(LPai);
   Lbox2.Top         := LPy;
   Lbox2.Left        := LPx;
   if LLarguraIcone=0 then
      LLarguraIcone := trunc(LLargura*0.15);
   Lbox2.Width       := LLarguraIcone;
   Lbox2.Height      := LAltura;
   Lbox2.Brush.Color := LCorIcone;
   Lbox2.Brush.Style := bsSolid;
   Lbox2.Pen.Style   := psClear;
   Lbox2.Shape       := stRectangle;
   Lbox2.Name        := 'boxicone'+LNome;
   Lbox2.Visible     := true;
   Lbox2.Parent      := LPai;
   Lbox2.Repaint;
   //---------------------------------------------------------------------------
   if LArqIcone<>'' then
      begin
         if FileExists(LArqIcone) then
            begin
               Limagem             := TImage.Create(LPai);
               Limagem.Top         := LPy+4;
               Limagem.Left        := LPx+4;
               Limagem.Width       := LLarguraIcone - 8;
               Limagem.Height      := LAltura - 8;
               Limagem.Stretch     := LIconStretch;
               if LIconStretch then
                  begin
                     Limagem.Proportional := false;
                     Limagem.Center       := false;
                  end
               else
                  begin
                     Limagem.Proportional := true;
                     Limagem.Center       := true;
                  end;
               Limagem.Transparent := true;
               Limagem.Name        := 'img'+LNome;
               Limagem.Parent      := LPai;
               try
                  Limagem.Picture.LoadFromFile(LArqIcone);
               except
               end;
               Limagem.Repaint;
            end;
      end;
   //---------------------------------------------------------------------------
   Lbotao            := TSpeedButton.Create(LPai);
   Lbotao.Top        := LPy;
   Lbotao.Left       := LPx;
   Lbotao.Height     := LAltura;
   Lbotao.Width      := LLargura;
   Lbotao.Flat       := true;
   Lbotao.Caption    := LTexto;
   Lbotao.Font.Color := LCorLetra;
   Lbotao.Font.Style := [fsBold];
   Lbotao.Font.Size  := LFontSyze;
   Lbotao.Name       := 'bt_principal'+LNome;
   Lbotao.Visible    := true;
   Lbotao.Cursor     := crHandPoint;
   Lbotao.OnClick    := LOnClick;
   Lbotao.Tag        := LTag;
   Lbotao.Parent     := LPai;
   //---------------------------------------------------------------------------
end;

end.
