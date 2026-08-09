unit analizadorSintactico;

interface

uses
  Tipos, analizadorLexico, unitTAS, ManejoPilas, manejoArbol, SysUtils;

{ Devuelve True si el análisis fue exitoso, y por referencia entrega el Árbol completo }
function AnalizarSintaxis(var Fuente: FileOfChar; var ArbolSintactico: arbolDerivacion): Boolean;

implementation

{ Función auxiliar para saber si un símbolo es terminal basándonos en tu enumerado }
function EsTerminal(simbolo: SimboloGramatical): Boolean;
begin
  { En tu unit Tipos, los terminales van desde tTingui hasta pesos }
  Result := (simbolo >= tTingui) and (simbolo <= pesos);
end;

function AnalizarSintaxis(var Fuente: FileOfChar; var ArbolSintactico: arbolDerivacion): Boolean;
var
  Pila: TipoPila;
  Control: LongInt;
  TokenInfo: TElemTS;
  X: SimboloGramatical;
  NodoX, NodoAux: arbolDerivacion;
  TAS: TipoTAS;
  Celda: PunteroCelda;
  i: Integer;
  Exito: Boolean;
  HijosNuevos: array[1..Elemmax] of arbolDerivacion;
begin
  Exito := True;
  Control := 0;

  { 1. Inicializamos la Tabla de Análisis Sintáctico y la Pila }
  InicializarTAS(TAS);
  CargarTAS(TAS);
  CrearPila(Pila);

  { 2. La Pila comienza con el símbolo de fin de archivo (pesos) y el axioma inicial }
  Apilar(Pila, pesos, nil);

  { Creamos la raíz del árbol con el axioma inicial (vPrograma) y lo apilamos }
  crearArbol(ArbolSintactico, vPrograma, '');
  Apilar(Pila, vPrograma, ArbolSintactico);

  { 3. Leemos el primer token del archivo fuente }
  ObtenerSiguienteSimbolo(Fuente, Control, TokenInfo);

  { 4. Ciclo principal del parser LL(1) }
  while not PilaVacia(Pila) and Exito do
  begin
    { Sacamos el tope de la pila }
    Desapilar(Pila, X, NodoX);

    if EsTerminal(X) then
    begin
      { Si es el fin de archivo o un terminal }
      if X = TokenInfo.compLex then
      begin
        { ¡Match! El símbolo de la pila coincide con el de la entrada. }
        { Si estamos construyendo el árbol, guardamos el lexema exacto en el nodo hoja }
        if NodoX <> nil then
          NodoX^.Lexema := TokenInfo.Lexema;

        { Avanzamos al siguiente token de la entrada (si no llegamos al final) }
        if X <> pesos then
          ObtenerSiguienteSimbolo(Fuente, Control, TokenInfo);
      end
      else
      begin
        Writeln('Error Sintactico: Se esperaba ', X, ' pero se encontro ', TokenInfo.compLex, ' ("', TokenInfo.Lexema, '")');
        Exito := False;
      end;
    end
    else
    begin
      { Es un No Terminal, buscamos la celda correspondiente en la TAS }
      Celda := TAS[X, TokenInfo.compLex];

      if Celda <> nil then
      begin
        { Tenemos una producción válida. }
        { Primero creamos los nodos hijos y los vinculamos a NodoX (de izquierda a derecha) }
        for i := 1 to Celda^.cant do
        begin
          crearArbol(NodoAux, Celda^.elementos[i], '');
          insertarHijo(NodoX, NodoAux);
          HijosNuevos[i] := NodoAux;
        end;

        { Apilamos los elementos de la producción en ORDEN INVERSO }
        { Para que el símbolo más a la izquierda quede en el tope de la pila }
        for i := Celda^.cant downto 1 do
        begin
          Apilar(Pila, Celda^.elementos[i], HijosNuevos[i]);
        end;
      end
      else
      begin
        { Celda vacía en la TAS -> Error }
        Writeln('Error Sintactico: Falta de produccion en TAS. No Terminal: ', X, ' | Token Actual: ', TokenInfo.compLex);
        Exito := False;
      end;
    end;
  end;

  AnalizarSintaxis := Exito;
end;

end.
