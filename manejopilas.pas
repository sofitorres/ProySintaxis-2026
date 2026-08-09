unit ManejoPilas;

interface

uses Tipos, manejoArbol;

type
  PunteroPila = ^NodoPila;
  NodoPila = record
    info: SimboloGramatical;
    nodoArbol: arbolDerivacion;
    sig: PunteroPila;
  end;

  TipoPila = record
    tope: PunteroPila;
  end;

procedure CrearPila(var P: TipoPila);
procedure Apilar(var P: TipoPila; item: SimboloGramatical; nodo: arbolDerivacion);
procedure Desapilar(var P: TipoPila; var item: SimboloGramatical; var nodo:arbolDerivacion);
function PilaVacia(P: TipoPila): Boolean;
function VerTope(P: TipoPila): SimboloGramatical;

implementation

procedure CrearPila(var P: TipoPila);
begin
  P.tope := nil;
end;

procedure Apilar(var P: TipoPila; item: SimboloGramatical; nodo: arbolDerivacion);
var
  nuevo: PunteroPila;
begin
  new(nuevo);
  nuevo^.info := item;
  nuevo^.nodoArbol:= nodo;
  nuevo^.sig := P.tope;
  P.tope := nuevo;
end;

procedure Desapilar(var P: TipoPila; var item: SimboloGramatical; var nodo: arbolDerivacion);
var
  aux: PunteroPila;
begin
  if P.tope <> nil then
  begin
    item := P.tope^.info;
    nodo := P.tope^.nodoArbol;
    aux := P.tope;
    P.tope := P.tope^.sig;
    dispose(aux);
  end;
end;

function PilaVacia(P: TipoPila): Boolean;
begin
  PilaVacia := (P.tope = nil);
end;

function VerTope(P: TipoPila): SimboloGramatical;
begin
  if P.tope <> nil then
    VerTope := P.tope^.info
  else
    VerTope := pesos;
end;

end.
