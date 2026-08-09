unit ManejoListas;

interface

uses Tipos; // Para poder usar SimboloGramatical si fuera necesario

type
  t_puntero = ^t_nodo;

  t_nodo = record
    nombre: string;     // Aquí guardamos el nombre de la variable (ej: "x")
    tipo: string;       // Aquí si es "Real" o "String"
    sig: t_puntero;     // El enlace al siguiente nodo
  end;

{ Declaración de los métodos para que otras unidades los vean }
procedure CrearLista(var L: t_puntero);
procedure Insertar(var L: t_puntero; nom: string; tip: string);
function Buscar(L: t_puntero; nom: string): boolean;

implementation

{ Inicializa la lista como vacía }
procedure CrearLista(var L: t_puntero);
begin
  L := nil;
end;

{ Agrega un nuevo elemento al principio de la lista }
procedure Insertar(var L: t_puntero; nom: string; tip: string);
var
  nuevo: t_puntero;
begin
  new(nuevo);          // Pide memoria para el nuevo nodo
  nuevo^.nombre := nom;
  nuevo^.tipo := tip;
  nuevo^.sig := L;     // El nuevo apunta al que antes era el primero
  L := nuevo;          // Ahora el primero es el nuevo
end;

{ Recorre la lista buscando un nombre }
function Buscar(L: t_puntero; nom: string): boolean;
var
  aux: t_puntero;
begin
  aux := L;
  while (aux <> nil) and (aux^.nombre <> nom) do
    aux := aux^.sig;

  Buscar := (aux <> nil); // Si aux no es nil, es porque lo encontró
end;

end.
