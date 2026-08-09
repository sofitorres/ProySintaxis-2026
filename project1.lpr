program project1;

uses
  Classes, SysUtils, Tipos, analizadorLexico, analizadorSintactico,
  manejoArbol, unitTAS, ManejoPilas, ManejoEstado, Evaluador;

var
  Fuente: FileOfChar;
  ArbolDeriv: arbolDerivacion;
  EstadoPrograma: tEstado;
  NombreArchivo: string;

begin
  DefaultFormatSettings.DecimalSeparator := '.';
  { 1. Configuramos el archivo de código fuente a leer }
  if paramcount>0 then assign(fuente,paramstr(1))
  else
  begin
  Writeln('Ingrese nombre del archivo:');
  Readln(NombreArchivo);
  Assign(Fuente, NombreArchivo);
  end;
  {$I-}
  Reset(Fuente);
  {$I+}

  if IOResult <> 0 then
  begin
    Writeln('Error: No se pudo encontrar o abrir el archivo "', NombreArchivo, '".');
    Writeln('Asegurate de crearlo en la misma carpeta que el ejecutable.');
    Readln;
    Exit;
  end;

  Writeln('INICIANDO ANALISIS SINTACTICO...');

  { 2. Llamamos al Analizador Sintactico (que usa al Lexico por debajo) }
  if AnalizarSintaxis(Fuente, ArbolDeriv) then
  begin
    Writeln('¡Analisis Sintactico EXITOSO!');
    Writeln('');
    Writeln('--- Arbol de Derivacion Generado ---');
    Mostrar_arbol(ArbolDeriv);
    Writeln('------------------------------------');
    Writeln('INICIANDO EJECUCION (EVALUADOR)...');
    Writeln('');

    { 3. Si la sintaxis es correcta, le pasamos el arbol al Evaluador }
    evalPrograma(ArbolDeriv, EstadoPrograma);

    Writeln('');
    Writeln('Ejecucion finalizada.');
  end
  else
  begin
    Writeln('');
    Writeln('El programa se detuvo por errores de sintaxis.');
  end;

  { 4. Limpieza final de memoria y archivos }
  Close(Fuente);
  liberarArbol(ArbolDeriv);

  Writeln('');
  Writeln('Presiona ENTER para salir...');
  Readln;
end.
