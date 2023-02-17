unit Utils;

interface
uses System.Classes, System.SysUtils, System.JSON, StrUtils;

type
    TFormato = (Personalizado, Valor);

    // Métodos utilitários
    function incrementarSequencial(sequencial: String):String;
    function getRetorno(resp: String):String;
    function getComprovante(resp: String; via:String):String;
    function getSequencial(resp: String):String;
    function jsonify(jsonString: String):TJsonObject;
    function stringify(json: TJsonObject):PAnsiChar;
    function getStringValue(json: TJsonObject; key:String):String;
    function naoContem(msg: String): Boolean;
    procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
    function FormatNumber(const AStr: string; dotIndex: Integer = 2): string;
    function MaskValor(valor: string; dotIndex: integer): string;
    function MaskDate(date: string; backSpace: boolean = false): string;
    function RemoveNonNumericChars(const AStr: string): string;
    function ExtractTextBetween(const Input, Delim1, Delim2: string): string;
implementation

// ===================================================================== //
// =========== METODOS UTILITÁRIOS PARA O EXEMPLO DELPHI =============== //
// ===================================================================== //

function incrementarSequencial(sequencial:String):String;
var
  seq : Integer;
begin
  try
    seq := strtoint(sequencial) + 1;
    result := IntToStr(seq);
  except
    on Exception : EConvertError do
      result := ''; // sequencial informado não numérico
  end;
end;

function getRetorno(resp:String):String;
begin
  result := getStringValue(jsonify(resp), 'tef.retorno')
end;

function getSequencial(resp:String):String;
begin
  result := getStringValue(jsonify(resp), 'tef.sequencial')
end;

function getComprovante(resp:String; via:String):String;
begin
  if via = 'loja' then begin
    result := getStringValue(jsonify(resp), 'tef.comprovanteDiferenciadoLoja')
    end
  else if via = 'cliente' then begin
    result := getStringValue(jsonify(resp), 'tef.comprovanteDiferenciadoPortador')
    end
  else begin
    result := ''
  end
end;

function jsonify(jsonString: String):TJsonObject;
begin
  result := TJsonObject.ParseJSONValue(jsonString) as TJsonObject;
end;

function stringify(json:TJsonObject):PAnsiChar;
begin
  result := PAnsiChar(AnsiString(json.ToString));
end;

function getStringValue(json:TJsonObject; key:String):String;
var
  value : TJsonString;
  valueSt : String;
begin
  if (json.TryGetValue(key, value)) then begin
	valueSt := value.ToString;
    result := copy(valueSt, 2, valueSt.Length-2);
   end
  else
    result := '';
end;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

function naoContem(msg: string): Boolean;
var
  P : Integer;
  strings : TArray<String>;
  element : String;
  contem : boolean;
begin
  strings := ['AGUARDE', 'FINALIZADA', 'PASSAGEM', 'CANCELADA', 'APROVADA'];
  contem := false;

  for element in strings do
    begin
        P := Pos(element, msg);
        if P = 0 then
          contem := true
        else begin
          contem := false;
          break;
        end;
    end;
    result := contem;
end;

function RemoveNonNumericChars(const AStr: string): string;
var
  i: Integer;
  c: Char;
  resString: String;
begin
  Result := '';
  for c in Astr do
  begin
    if CharInSet(c, ['0'..'9']) then
      resString := resString + c;
  end;
  result := resString;
end;

function FormatNumber(const AStr: string; dotIndex: Integer = 2): string;
var
  dotPos: Integer;
  cleanString: String;
  num: Double;
  len: Integer;
begin
  cleanString := RemoveNonNumericChars(AStr);

  if Length(cleanString) > 8 then
    result := '0.00';

  if cleanString = '' then
    cleanstring := '0'
  else
    cleanString := inttostr(strtoint(cleanString));

  len := Length(cleanString);

  if len <= 1 then begin
    result := '0.0' + cleanString;
  end
  else if len <= 2 then begin
    result := '0.' + cleanString;
  end
  else begin
    dotPos := Length(AStr) - dotIndex;
    result := Copy(cleanString, 1, dotPos) + '.' + Copy(cleanString, dotPos + 1, 2);
  end;
end;

function MaskDate(date: string; backSpace: boolean = false): string;
var
  cleanDate: string;
  len: integer;
begin
  cleanDate := removenonNumericChars(date);
  len := length(cleanDate);

  if len >= 5 then
    result := copy(cleanDate, 1, 2) + '/' +
              copy(cleanDate, 3, 2) + '/' +
              copy(cleanDate, 5, 1)
  else
    result := cleanDate;

end;

function MaskValor(valor: string; dotIndex: integer): string;
var
  len: integer;
  dotPos: integer;
  input : string;
begin
    input := removeNonNumericChars(valor);
    if input = '' then
      input := '0';

    input := inttostr(strtoint(input));
    len := length(input);

    if len <= 1 then begin
      result := '0.' + input;
    end
    else if (len <= 3) and (dotIndex = 3) then begin
      if len = 3 then result := '0.' + input;
      if len = 2 then result := '0.0' + input;
      if len = 1 then result := '0.00';
    end
    else begin
      dotPos := len - dotIndex;
      result := Copy(input, 1, dotPos) + '.' + Copy(input, dotPos + 1, len);
    end;
end;

function ExtractTextBetween(const Input, Delim1, Delim2: string): string;
var
  aPos, bPos: Integer;
begin
  result := '';
  aPos := Pos(Delim1, Input);
  if aPos > 0 then begin
    bPos := PosEx(Delim2, Input, aPos + Length(Delim1));
    if bPos > 0 then begin
      result := Copy(Input, aPos + Length(Delim1), bPos - (aPos + Length(Delim1)));
    end;
  end;
end;

end.
