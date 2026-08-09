unit manejoArbol;

interface

uses
  Tipos, crt;

const
  max = 10;

Type
  arbolDerivacion = ^t_nodo_arbol;
  t_nodo_arbol = record
    simbolo: Simbologramatical;
    Lexema: string;
    Hijos: array[1..max] of arbolDerivacion;
    cant: byte;   // cantidad de hijos
  end;

procedure crearArbol(var nodo: arbolDerivacion; complex: Simbologramatical; Lexema: string);
procedure insertarHijo(var raiz: arbolDerivacion; hijo: arbolDerivacion);
procedure guardarArbol(var archivo: text; var raiz: arbolDerivacion; Desplazamiento: integer);
Procedure Mostrar_arbol(var arbol: arbolDerivacion);

{ --- AGREGAR ESTA LÍNEA EN LA INTERFACE --- }
procedure liberarArbol(var raiz: arbolDerivacion);

implementation

procedure crearArbol(var nodo: arbolDerivacion; complex: Simbologramatical; Lexema: string);
var
  i: integer;
begin
  new(nodo);
  nodo^.cant := 0;
  nodo^.Lexema := Lexema;
  nodo^.simbolo := complex;
  { Corregido: Usar 'max' que es tu constante local, no Elemmax }
  for i := 1 to max do
  begin
    nodo^.hijos[i] := nil;
  end;
end;

procedure insertarHijo(var raiz: arbolDerivacion; hijo: arbolDerivacion);
begin
  if (raiz^.cant < max) then
  begin
    inc(raiz^.cant);
    raiz^.hijos[raiz^.cant] := hijo;
  end;
end;

Procedure Mostrar_arbol(var arbol: arbolDerivacion);
var
  i: integer;
begin
  if arbol <> nil then
  begin
    writeln(arbol^.simbolo);
    for i := 1 to arbol^.cant do
    begin
      Mostrar_arbol(arbol^.hijos[i]);
    end;
  end;
end;

procedure guardarArbol(var archivo: text; var raiz: arbolDerivacion; Desplazamiento: integer);
var
  i: integer;
begin
  if raiz <> nil then
  begin
    Writeln(archivo, '': desplazamiento, raiz^.simbolo, ': ', raiz^.lexema);
    for i := 1 to raiz^.cant do
    begin
      guardarArbol(archivo, raiz^.hijos[i], Desplazamiento + 2);
    end;
  end;
end;

{ --- AGREGAR ESTE PROCEDIMIENTO AL FINAL DE IMPLEMENTATION --- }
procedure liberarArbol(var raiz: arbolDerivacion);
var
  i: integer;
begin
  if raiz <> nil then
  begin
    { 1. Primero liberamos recursivamente a todos los hijos }
    for i := 1 to raiz^.cant do
    begin
      liberarArbol(raiz^.Hijos[i]);
    end;

    { 2. Ahora que no tiene hijos, liberamos el nodo actual }
    Dispose(raiz);

    { 3. Ponemos el puntero en nil por seguridad }
    raiz := nil;
  end;
end;

end.
