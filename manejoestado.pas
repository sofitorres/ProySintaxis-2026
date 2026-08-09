unit ManejoEstado;

{$mode ObjFPC}{$H+}

interface

uses
  crt,TIpos;
function ObtenerValorVariable(var estado: tEstado; nombre: string; var valor: tResultado): boolean;
procedure AsignarValorVariable(var estado: tEstado; nombre: string; valor: tResultado);
procedure InicializarEstado(var estado: tEstado);
procedure RegistrarVariable(var estado: tEstado; nombre: string; tipo: TPrincipalTipo);
implementation
 procedure InicializarEstado(var estado: tEstado);
begin
  estado.cant := 0;
end;
 procedure RegistrarVariable(var estado: tEstado; nombre: string; tipo: TPrincipalTipo);
begin
  if estado.cant < MaxSim then
  begin
    inc(estado.cant);
    estado.variables[estado.cant].nombre := LowerCase(nombre);
    estado.variables[estado.cant].tipo := tipo;
    estado.variables[estado.cant].inicializada := False;

    // Valores por defecto
    if tipo = tpReal then
      estado.variables[estado.cant].valor.valorReal := 0.0
    else
      estado.variables[estado.cant].valor.valorString := '';
  end
  else
    writeln('Error en tiempo de ejecucion: Memoria llena.');
end;
 procedure AsignarValorVariable(var estado: tEstado; nombre: string; valor: tResultado);
var
  i: integer;
  encontrado: boolean;
begin
  nombre := LowerCase(nombre);
  encontrado := false;
  i := 1;

  while (i <= estado.cant) and (not encontrado) do
  begin
    if estado.variables[i].nombre = nombre then
    begin
      encontrado := true;
      if estado.variables[i].tipo = valor.tipo then
      begin
        estado.variables[i].valor := valor;
        estado.variables[i].inicializada := true;
      end
      else
        writeln('Error de tipos: No se puede asignar este valor a ', nombre);
    end;
    inc(i);
  end;

  if not encontrado then
    writeln('Error en tiempo de ejecucion: Variable no declarada: ', nombre);
end;
 function ObtenerValorVariable(var estado: tEstado; nombre: string; var valor: tResultado): boolean;
var
  i: integer;
begin
  nombre := LowerCase(nombre);
  ObtenerValorVariable := false;

  for i := 1 to estado.cant do
  begin
    if estado.variables[i].nombre = nombre then
    begin
      valor := estado.variables[i].valor;
      ObtenerValorVariable := true;
      Exit;
    end;
  end;
end;
end.

