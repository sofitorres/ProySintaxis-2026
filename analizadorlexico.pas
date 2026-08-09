unit analizadorLexico;

interface

uses Classes, SysUtils, crt, Tipos;

const
  FinArch = #0;

type
  FileOfChar = file of char;

  { Nota: TElemTS debe estar definido en tu unit Tipos }
  TablaDeSimbolos = record
    elem: array[1..MaxSim] of TElemTS;
    cant: 0..maxsim;
  end;

  Sigma = (Letra, Dig, Otro);

procedure LeerCar(var Fuente: FileOfChar; var control: Longint; var car: char);
procedure ObtenerSiguienteSimbolo(var Fuente: FileOfChar; var control: Longint; var token: TElemTS);
procedure InicializarTabla(var TS: TablaDeSimbolos);

var
  TS: TablaDeSimbolos;

implementation

procedure LeerCar(var Fuente: FileOfChar; var control: Longint; var car: char);
begin
  if control < filesize(Fuente) then
  begin
    seek(Fuente, control);
    read(Fuente, car);
    control := control + 1;
  end
  else
  begin
    car := FinArch;
  end;
end;

procedure InicializarTabla(var TS: TablaDeSimbolos);
begin
  TS.cant := 0;
end;

function EsPalabraReservada(lexema: string; var comp: SimboloGramatical): boolean;
begin
  Result := True;
  lexema := LowerCase(lexema);

  if lexema = 'tingui' then comp := tTingui
  else if lexema = 'var' then comp := tVar
  else if lexema = 'real' then comp := tReal
  else if lexema = 'string' then comp := tString
  else if lexema = 'if' then comp := tIf
  else if lexema = 'then' then comp := tThen
  else if lexema = 'else' then comp := tElse
  else if lexema = 'while' then comp := tWhile
  else if lexema = 'do' then comp := tDo
  else if lexema = 'write' then comp := tWrite
  else if lexema = 'read' then comp := tRead
  else if lexema = 'and' then comp := tAnd
  else if lexema = 'or' then comp := tOr
  else if lexema = 'not' then comp := tNot
  else if lexema = 'sqrt' then comp := tSqrt
  else if lexema = 'largo' then comp := tLargo
  else if lexema = 'busca' then comp := tBusca
  else if lexema = 'subcad' then comp := tSubcad
  else Result := False;
end;

function CarASimb(c: Char): Sigma;
begin
  if c in ['a'..'z', 'A'..'Z', '_'] then
    CarASimb := Letra
  else if c in ['0'..'9'] then
    CarASimb := Dig
  else
    CarASimb := Otro;
end;

procedure SaltarBlancos(var Fuente: FileOfChar; var Control: LongInt);
var
  Car: Char;
begin
  LeerCar(Fuente, Control, Car);
  while (Car = #32) or (Car = #9) or (Car = #10) or (Car = #13) do
  begin
    LeerCar(Fuente, Control, Car);
  end;
  if (Car <> FinArch) then
    Control := Control - 1;
end;

function EsIdentificador(var Fuente: FileOfChar; var Control: LongInt; var Lexema: String): Boolean;
const
  q0 = 0;
  F = [3];
type
  Q = 0..3;
  TipoDelta = array[Q, Sigma] of Q;
var
  ControlAux: LongInt;
  EstadoActual: Q;
  Delta: TipoDelta;
  Car: Char;
begin
  Delta[0, Letra] := 2;
  Delta[0, Dig]   := 1;
  Delta[0, Otro]  := 1;
  Delta[2, Letra] := 2;
  Delta[2, Dig]   := 2;
  Delta[2, Otro]  := 3;

  ControlAux := Control;
  EstadoActual := q0;
  Lexema := '';

  while (EstadoActual <> 1) and (EstadoActual <> 3) do
  begin
    LeerCar(Fuente, ControlAux, Car);
    EstadoActual := Delta[EstadoActual, CarASimb(Car)];
    { Eliminado ControlAux := ControlAux + 1; LeerCar ya lo hace }

    if EstadoActual <> 3 then
      Lexema := Lexema + Car;
  end;

  if EstadoActual in F then
  begin
    EsIdentificador := True;
    Control := ControlAux - 1; { Volvemos uno atrás porque el 'Otro' no es parte del ID }
  end
  else
    EsIdentificador := False;
end;

function EsConstantReal(var Fuente: FileOfChar; var Control: LongInt; var Lexema: String): Boolean;
var
  ControlAux: LongInt;
  Car: Char;
  Estado: Integer;
begin
  ControlAux := Control;
  Lexema := '';
  Estado := 0;
  EsConstantReal := False;

  while (Estado <> 4) and (Estado <> 5) do
  begin
    LeerCar(Fuente, ControlAux, Car);
    { Eliminado ControlAux := ControlAux + 1; }

    case Estado of
      0: if Car in ['0'..'9'] then
           begin Estado := 1; Lexema := Lexema + Car; end
         else Estado := 5;

      1: if Car in ['0'..'9'] then
           begin Estado := 1; Lexema := Lexema + Car; end
         else if Car = '.' then
           begin Estado := 2; Lexema := Lexema + Car; end
         else
           begin Estado := 4; ControlAux := ControlAux - 1; end;

      2: if Car in ['0'..'9'] then
           begin Estado := 3; Lexema := Lexema + Car; end
         else
           begin Estado := 5; end;

      3: if Car in ['0'..'9'] then
           begin Estado := 3; Lexema := Lexema + Car; end
         else
           begin Estado := 4; ControlAux := ControlAux - 1; end;
    end;
  end;

  if Estado = 4 then
  begin
    EsConstantReal := True;
    Control := ControlAux;
  end
  else
    EsConstantReal := False;
end;

function EsCadena(var Fuente: FileOfChar; var Control: LongInt; var Lexema: String): Boolean;
var
  ControlAux: LongInt;
  Car: Char;
begin
  ControlAux := Control;
  LeerCar(Fuente, ControlAux, Car); { Lee la comilla inicial }

  if Car = '''' then
  begin
    Lexema := '';
    LeerCar(Fuente, ControlAux, Car); { Lee el primer caracter de la cadena }
    while (Car <> '''') and (Car <> FinArch) and (Car <> #13) do
    begin
      Lexema := Lexema + Car;
      LeerCar(Fuente, ControlAux, Car);
    end;

    if Car = '''' then
    begin
      EsCadena := True;
      Control := ControlAux; { El puntero ya está después de la comilla de cierre }
    end
    else
      EsCadena := False;
  end
  else
    EsCadena := False;
end;

function EsSimbolo(var Fuente: FileOfChar; var Control: LongInt; var comp: SimboloGramatical): Boolean;
var
  Car: Char;
  ControlAux: LongInt;
begin
  ControlAux := Control;
  LeerCar(Fuente, ControlAux, Car);
  EsSimbolo := True;

  case Car of
    ';': comp := tPyC;
    ',': comp := tComa;
    '(': comp := tParAbre;
    ')': comp := tParCierra;
    '[': comp := tCorcheteAbre;
    ']': comp := tCorcheteCierra;
    '{': comp := tLlaveAbre;  { Agregados para tu gramatica }
    '}': comp := tLlaveCierra;
    '+': comp := tMas;
    '-': comp := tMenos;
    '*': comp := tPor;
    '/': comp := tDiv;
    '^': comp := tPotencia;
    '.': comp := tPunto;
    '=': begin
           LeerCar(Fuente, ControlAux, Car);
           if Car = '=' then comp := tIgual
           else begin comp := tIgual; ControlAux := ControlAux - 1; end;
         end;
    ':': begin
           LeerCar(Fuente, ControlAux, Car);
           if Car = '=' then comp := tAsig
           else begin comp := tDosP; ControlAux := ControlAux - 1; end;
         end;
    '<': begin
           LeerCar(Fuente, ControlAux, Car);
           if Car = '>' then comp := tDistinto
           else if Car = '=' then comp := tMenorIgual
           else if Car = '-' then comp := tAsig
           else begin comp := tMenor; ControlAux := ControlAux - 1; end;
         end;
    '>': begin
           LeerCar(Fuente, ControlAux, Car);
           if Car = '=' then comp := tMayorIgual
           else begin comp := tMayor; ControlAux := ControlAux - 1; end;
         end;
    else
      EsSimbolo := False;
  end;

  if EsSimbolo then
     Control := ControlAux;
end;

procedure ObtenerSiguienteSimbolo(var Fuente: FileOfChar; var control: Longint; var token: TElemTS);
var
  Lexema: String;
  Comp: SimboloGramatical;
  Car: Char;
begin
  SaltarBlancos(Fuente, Control);

  LeerCar(Fuente, Control, Car);
  if Car = FinArch then
  begin
    token.compLex := pesos;
    token.Lexema := '';
    Exit;
  end
  else
    Control := Control - 1; { Retrocedemos para que las funciones de prueba lean el car }

  if EsIdentificador(Fuente, Control, Lexema) then
  begin
    token.Lexema := Lexema;
    if EsPalabraReservada(Lexema, Comp) then
      token.compLex := Comp
    else
      token.compLex := tId;
  end
  else if EsConstantReal(Fuente, Control, Lexema) then
  begin
     token.Lexema := Lexema;
     token.compLex := tCreal;
  end
  else if EsCadena(Fuente, Control, Lexema) then
  begin
     token.Lexema := Lexema;
     token.compLex := tCad;
  end
  else if EsSimbolo(Fuente, Control, Comp) then
  begin
    token.compLex := Comp;
    token.Lexema := '';
  end
  else
  begin
    token.compLex := pesos;
    token.Lexema := 'Error';
    Control := Control + 1;
  end;
end;

end.
