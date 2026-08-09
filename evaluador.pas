unit Evaluador;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Tipos, manejoArbol, ManejoEstado;

procedure evalPrograma(var nodo: arbolDerivacion; var estado: tEstado);

implementation

{ --- DECLARACIONES FORWARD --- }
{ Esto evita los errores de "identificador no encontrado" por referencias cruzadas }
procedure evalVariable(var nodo: arbolDerivacion; var estado: tEstado); forward;
procedure evalCuerpoVar(var nodo: arbolDerivacion; var estado: tEstado); forward;
procedure evalTipo(var nodo: arbolDerivacion; var estado: tEstado; var tipo: TPrincipalTipo); forward;
procedure evalCuerpoVarFact(var nodo: arbolDerivacion; var estado: tEstado); forward;
procedure evalCuerpo(var nodo: arbolDerivacion; var estado: tEstado); forward;
procedure evalAsignacion(var nodo: arbolDerivacion; var estado: tEstado); forward;
procedure evalEscribir(var nodo: arbolDerivacion; var estado: tEstado); forward;
procedure evalEscritura(var nodo: arbolDerivacion; var estado: tEstado); forward;
procedure evalEscrituraFact(var nodo: arbolDerivacion; var estado: tEstado); forward;
procedure evalCondicional(var nodo: arbolDerivacion; var estado: tEstado); forward;
procedure evalCondFact(var nodo: arbolDerivacion; var estado: tEstado; condicionIf: boolean); forward;
procedure evalCondicion(var nodo: arbolDerivacion; var estado: tEstado; var resultado: boolean); forward;
procedure evalCondFactorizada(var nodo: arbolDerivacion; var estado: tEstado; aux: boolean; var resultado: boolean); forward;
procedure evalCondicion2(var nodo: arbolDerivacion; var estado: tEstado; var resultado: boolean); forward;
procedure evalCond2Fact(var nodo: arbolDerivacion; var estado: tEstado; aux: boolean; var resultado: boolean); forward;
procedure evalCiclica(var nodo: arbolDerivacion; var estado: tEstado); forward;
procedure evalLeer(var nodo: arbolDerivacion; var estado: tEstado); forward;
procedure evalOpA(var nodo: arbolDerivacion; var estado: tEstado; var resultado: tResultado); forward;
procedure evalOpAFact(var nodo: arbolDerivacion; var estado: tEstado; izq: tResultado; var resultado: tResultado); forward;
procedure evalOpA2(var nodo: arbolDerivacion; var estado: tEstado; var resultado: tResultado); forward;
procedure evalOpA2Fact(var nodo: arbolDerivacion; var estado: tEstado; izq: tResultado; var resultado: tResultado); forward;
procedure evalOpA3(var nodo: arbolDerivacion; var estado: tEstado; var resultado: tResultado); forward;
procedure evalOpA3Fact(var nodo: arbolDerivacion; var estado: tEstado; izq: tResultado; var resultado: tResultado); forward;
procedure evalOpA4(var nodo: arbolDerivacion; var estado: tEstado; var resultado: tResultado); forward;
procedure evalExpRelacional(var nodo: arbolDerivacion; var estado: tEstado; var resultado: boolean); forward;

{ --- IMPLEMENTACIONES --- }

procedure evalPrograma(var nodo: arbolDerivacion; var estado: tEstado);
begin
  InicializarEstado(estado);
  evalVariable(nodo^.Hijos[4], estado);
  evalCuerpo(nodo^.Hijos[6], estado);
end;

procedure evalVariable(var nodo: arbolDerivacion; var estado: tEstado);
begin
  if nodo^.cant > 0 then
  begin
    evalCuerpoVar(nodo^.Hijos[2], estado);
  end;
end;

procedure evalCuerpoVar(var nodo: arbolDerivacion; var estado: tEstado);
var
  tipo: TPrincipalTipo;
begin
  evalTipo(nodo^.Hijos[3], estado, tipo);
  RegistrarVariable(estado, nodo^.Hijos[1]^.Lexema, tipo);
  evalCuerpoVarFact(nodo^.Hijos[4], estado);
end;

procedure evalTipo(var nodo: arbolDerivacion; var estado: tEstado; var tipo: TPrincipalTipo);
begin
  case nodo^.Hijos[1]^.simbolo of
    tReal: tipo := tpReal;
    tString: tipo := tpString;
  end;
end;

procedure evalCuerpoVarFact(var nodo: arbolDerivacion; var estado: tEstado);
begin
  if nodo^.cant > 0 then
  begin
    evalCuerpoVar(nodo^.Hijos[1], estado);
  end;
end;

procedure evalCuerpo(var nodo: arbolDerivacion; var estado: tEstado);
begin
  if nodo^.cant > 0 then
  begin
    case nodo^.Hijos[1]^.simbolo of
      vAsignacion: evalAsignacion(nodo^.Hijos[1], estado);
      vCondicional: evalCondicional(nodo^.Hijos[1], estado);
      vCiclica: evalCiclica(nodo^.Hijos[1], estado);
      vEscribir: evalEscribir(nodo^.Hijos[1], estado);
      vLeer: evalLeer(nodo^.Hijos[1], estado);
    end;
    { La recursividad para seguir evaluando el resto del cuerpo }
    if nodo^.cant >= 3 then
      evalCuerpo(nodo^.Hijos[3], estado);
  end;
end;

procedure evalAsignacion(var nodo: arbolDerivacion; var estado: tEstado);
var
  resultado: tResultado;
begin
  evalOpA(nodo^.Hijos[3], estado, resultado);
  AsignarValorVariable(estado, nodo^.Hijos[1]^.lexema, resultado);
end;

procedure evalEscribir(var nodo: arbolDerivacion; var estado: tEstado);
begin
  evalEscritura(nodo^.Hijos[3], estado);
  Writeln; { Salto de linea al terminar el write }
end;

procedure evalEscritura(var nodo: arbolDerivacion; var estado: tEstado);
var
  resultado: tResultado;
begin
  evalOpA(nodo^.Hijos[1], estado, resultado);
  if resultado.tipo = tpReal then
    Write(resultado.valorReal:0:2)
  else
    Write(resultado.valorString);

  evalEscrituraFact(nodo^.Hijos[2], estado);
end;

procedure evalEscrituraFact(var nodo: arbolDerivacion; var estado: tEstado);
begin
  if nodo^.cant > 0 then
  begin
    evalEscritura(nodo^.Hijos[2], estado);
  end;
end;

procedure evalCondicional(var nodo: arbolDerivacion; var estado: tEstado);
var
  resultadoCondicion: boolean;
begin
  evalCondicion(nodo^.Hijos[2], estado, resultadoCondicion);
  if resultadoCondicion then
  begin
    evalCuerpo(nodo^.Hijos[5], estado);
  end;
  evalCondFact(nodo^.Hijos[7], estado, resultadoCondicion);
end;

procedure evalCondFact(var nodo: arbolDerivacion; var estado: tEstado; condicionIf: boolean);
begin
  if nodo^.cant > 0 then
  begin
    if not condicionIf then
    begin
      evalCuerpo(nodo^.Hijos[3], estado);
    end;
  end;
end;

procedure evalCondicion(var nodo: arbolDerivacion; var estado: tEstado; var resultado: boolean);
var
  aux: boolean;
begin
  evalCondicion2(nodo^.Hijos[1], estado, aux);
  evalCondFactorizada(nodo^.Hijos[2], estado, aux, resultado);
end;

procedure evalCondFactorizada(var nodo: arbolDerivacion; var estado: tEstado; aux: boolean; var resultado: boolean);
var
  resDerecha: boolean;
begin
  if nodo^.cant > 0 then
  begin
    evalCondicion(nodo^.Hijos[2], estado, resDerecha);
    resultado := aux or resDerecha;
  end
  else
  begin
    resultado := aux;
  end;
end;

procedure evalCondicion2(var nodo: arbolDerivacion; var estado: tEstado; var resultado: boolean);
var
  aux: boolean;
begin
  evalExpRelacional(nodo^.Hijos[1], estado, aux);
  evalCond2Fact(nodo^.Hijos[2], estado, aux, resultado);
end;

procedure evalCond2Fact(var nodo: arbolDerivacion; var estado: tEstado; aux: boolean; var resultado: boolean);
var
  resDerecha: boolean;
begin
  if nodo^.cant > 0 then
  begin
    evalCondicion2(nodo^.Hijos[2], estado, resDerecha);
    resultado := aux and resDerecha;
  end
  else
  begin
    resultado := aux;
  end;
end;

{ --- AGREGADO: Ciclo While --- }
procedure evalCiclica(var nodo: arbolDerivacion; var estado: tEstado);
var
  condicion: boolean;
begin
  evalCondicion(nodo^.Hijos[2], estado, condicion);
  while condicion do
  begin
    evalCuerpo(nodo^.Hijos[5], estado);
    evalCondicion(nodo^.Hijos[2], estado, condicion); { Reevaluar condicion }
  end;
end;

{ --- AGREGADO: Evaluacion de Expresiones Relacionales (<, >, ==, etc) --- }
procedure evalExpRelacional(var nodo: arbolDerivacion; var estado: tEstado; var resultado: boolean);
var
  izq, der: tResultado;
  op: SimboloGramatical;
begin
  { nodo^.hijos[1] es OpA, nodo^.hijos[2] es OpRel, nodo^.hijos[3] es OpA }
  evalOpA(nodo^.Hijos[1], estado, izq);
  evalOpA(nodo^.Hijos[3], estado, der);

  op := nodo^.Hijos[2]^.Hijos[1]^.simbolo; { Obtener el simbolo exacto del operador relacional }

  if (izq.tipo = tpReal) and (der.tipo = tpReal) then
  begin
    case op of
      tMayor: resultado := izq.valorReal > der.valorReal;
      tMenor: resultado := izq.valorReal < der.valorReal;
      tIgual: resultado := izq.valorReal = der.valorReal;
      tMayorIgual: resultado := izq.valorReal >= der.valorReal;
      tMenorIgual: resultado := izq.valorReal <= der.valorReal;
      tDistinto: resultado := izq.valorReal <> der.valorReal;
    end;
  end
  else if (izq.tipo = tpString) and (der.tipo = tpString) then
  begin
    case op of
      tIgual: resultado := izq.valorString = der.valorString;
      tDistinto: resultado := izq.valorString <> der.valorString;
      else Writeln('Error Semantico: Operador relacional no valido para Strings.');
    end;
  end
  else
  begin
    Writeln('Error Semantico: No se pueden comparar tipos distintos.');
    resultado := false;
  end;
end;

procedure evalLeer(var nodo: arbolDerivacion; var estado: tEstado);
var
  resultado: tResultado;
  nombreVariable: string;
  valorIngresado: string;
  valorFinal: tResultado;
  i: integer;
  encontrado: boolean;
begin
  evalOpA(nodo^.Hijos[3], estado, resultado);
  if resultado.tipo = tpString then
    write(resultado.valorString)
  else
    write(resultado.valorReal:0:2);

  nombreVariable := LowerCase(nodo^.Hijos[5]^.Lexema);
  readln(valorIngresado);

  i := 1;
  encontrado := false;
  while (i <= estado.cant) and (not encontrado) do
  begin
    if estado.variables[i].nombre = nombreVariable then
    begin
      encontrado := true;
      if estado.variables[i].tipo = tpReal then
      begin
        valorFinal.tipo := tpReal;
        valorFinal.valorReal := StrToFloatDef(valorIngresado, 0.0);
      end
      else
      begin
        valorFinal.tipo := tpString;
        valorFinal.valorString := valorIngresado;
      end;
      AsignarValorVariable(estado, nombreVariable, valorFinal);
    end;
    inc(i);
  end;

  if not encontrado then
    writeln('Error Semantico: La variable "', nombreVariable, '" no ha sido declarada.');
end;

procedure evalOpA(var nodo: arbolDerivacion; var estado: tEstado; var resultado: tResultado);
var resIzq: tResultado;
begin
  evalOpA2(nodo^.Hijos[1], estado, resIzq);
  evalOpAFact(nodo^.Hijos[2], estado, resIzq, resultado);
end;

procedure evalOpAFact(var nodo: arbolDerivacion; var estado: tEstado; izq: tResultado; var resultado: tResultado);
var resDer, resAcum: tResultado;
begin
  if nodo^.cant = 0 then
    resultado := izq
  else
  begin
    if izq.tipo <> tpReal then
      writeln('Error Semantico: No se pueden realizar operaciones aritmeticas sobre Strings.')
    else
    begin
      if nodo^.Hijos[1]^.simbolo = tMas then
      begin
        evalOpA(nodo^.Hijos[2], estado, resDer);
        if resDer.tipo <> tpReal then writeln('Error Semantico: El operando derecho debe ser Real.')
        else
        begin
          resAcum.tipo := tpReal;
          resAcum.valorReal := izq.valorReal + resDer.valorReal;
          resultado := resAcum;
        end;
      end
      else if nodo^.Hijos[1]^.simbolo = tMenos then
      begin
        evalOpA(nodo^.Hijos[2], estado, resDer);
        if resDer.tipo <> tpReal then writeln('Error Semantico: El operando derecho debe ser Real.')
        else
        begin
          resAcum.tipo := tpReal;
          resAcum.valorReal := izq.valorReal - resDer.valorReal;
          resultado := resAcum;
        end;
      end;
    end;
  end;
end;

procedure evalOpA2(var nodo: arbolDerivacion; var estado: tEstado; var resultado: tResultado);
var resIzq: tResultado;
begin
  evalOpA3(nodo^.Hijos[1], estado, resIzq);
  evalOpA2Fact(nodo^.Hijos[2], estado, resIzq, resultado);
end;

procedure evalOpA2Fact(var nodo: arbolDerivacion; var estado: tEstado; izq: tResultado; var resultado: tResultado);
var resDer, resAcum: tResultado;
begin
  if nodo^.cant = 0 then
    resultado := izq
  else
  begin
    if izq.tipo <> tpReal then
      writeln('Error Semantico: No se pueden multiplicar o dividir cadenas.')
    else
    begin
      if nodo^.Hijos[1]^.simbolo = tPor then
      begin
        evalOpA2(nodo^.Hijos[2], estado, resDer);
        if resDer.tipo <> tpReal then writeln('Error Semantico: Operando derecho debe ser Real.')
        else
        begin
          resAcum.tipo := tpReal;
          resAcum.valorReal := izq.valorReal * resDer.valorReal;
          resultado := resAcum;
        end;
      end
      else if nodo^.Hijos[1]^.simbolo = tDiv then
      begin
        evalOpA2(nodo^.Hijos[2], estado, resDer);
        if resDer.tipo <> tpReal then writeln('Error Semantico: Operando derecho debe ser Real.')
        else if resDer.valorReal = 0.0 then writeln('Error: Division por cero.')
        else
        begin
          resAcum.tipo := tpReal;
          resAcum.valorReal := izq.valorReal / resDer.valorReal;
          resultado := resAcum;
        end;
      end;
    end;
  end;
end;

procedure evalOpA3(var nodo: arbolDerivacion; var estado: tEstado; var resultado: tResultado);
var resIzq, resInterno, resFinal: tResultado;
begin
  if nodo^.Hijos[1]^.simbolo = tSqrt then
  begin
    evalOpA(nodo^.Hijos[3], estado, resInterno);
    if resInterno.tipo <> tpReal then writeln('Error Semantico: Argumento de sqrt debe ser Real.')
    else if resInterno.valorReal < 0.0 then writeln('Error: Raiz de numero negativo.')
    else
    begin
      resFinal.tipo := tpReal;
      resFinal.valorReal := Sqrt(resInterno.valorReal);
      resultado := resFinal;
    end;
  end
  else
  begin
    evalOpA4(nodo^.Hijos[1], estado, resIzq);
    evalOpA3Fact(nodo^.Hijos[2], estado, resIzq, resultado);
  end;
end;

procedure evalOpA3Fact(var nodo: arbolDerivacion; var estado: tEstado; izq: tResultado; var resultado: tResultado);
var resDer, resAcum: tResultado;
begin
  if nodo^.cant = 0 then
    resultado := izq
  else
  begin
    if izq.tipo <> tpReal then writeln('Error Semantico: Base de potencia debe ser Real.')
    else
    begin
      evalOpA4(nodo^.Hijos[2], estado, resDer);
      if resDer.tipo <> tpReal then writeln('Error Semantico: Exponente debe ser Real.')
      else if (izq.valorReal < 0.0) and (Frac(resDer.valorReal) <> 0.0) then writeln('Error: Resultado imaginario.')
      else
      begin
        resAcum.tipo := tpReal;
        if resDer.valorReal = 0.0 then resAcum.valorReal := 1.0
        else if (izq.valorReal = 0.0) and (resDer.valorReal > 0.0) then resAcum.valorReal := 0.0
        else
        begin
          resAcum.valorReal := Exp(resDer.valorReal * Ln(Abs(izq.valorReal)));
          if (izq.valorReal < 0.0) and (Odd(Round(resDer.valorReal))) then resAcum.valorReal := -resAcum.valorReal;
        end;
        resultado := resAcum;
      end;
    end;
  end;
end;

procedure evalOpA4(var nodo: arbolDerivacion; var estado: tEstado; var resultado: tResultado);
var
  resAux, resPos, resCant, resTexto, resBuscar: tResultado;
  nombreVar: string;
  i: integer;
  encontrado: boolean;
begin
  case nodo^.Hijos[1]^.simbolo of
    tParAbre: evalOpA(nodo^.Hijos[2], estado, resultado);
    tId:
      begin
        nombreVar := LowerCase(nodo^.Hijos[1]^.Lexema);
        i := 1; encontrado := false;
        while (i <= estado.cant) and (not encontrado) do
        begin
          if estado.variables[i].nombre = nombreVar then
          begin
            encontrado := true;
            resultado := estado.variables[i].valor;
          end;
          inc(i);
        end;
        if not encontrado then writeln('Error Semantico: La variable "', nombreVar, '" no esta declarada.');
      end;
    tMenos:
      begin
        evalOpA4(nodo^.Hijos[2], estado, resAux);
        if resAux.tipo <> tpReal then writeln('Error Semantico: "-" unario solo para numeros.')
        else
        begin
          resultado.tipo := tpReal;
          resultado.valorReal := -resAux.valorReal;
        end;
      end;
    tCreal:
      begin
        resultado.tipo := tpReal;
        resultado.valorReal := StrToFloatDef(nodo^.Hijos[1]^.Lexema, 0.0);
      end;
    tCad:
      begin
        resultado.tipo := tpString;
        { Quitamos comillas para un output mas limpio si es necesario, aca lo dejo igual }
        resultado.valorString := nodo^.Hijos[1]^.Lexema;
      end;
    tLargo:
      begin
        evalOpA(nodo^.Hijos[3], estado, resAux);
        if resAux.tipo <> tpString then writeln('Error Semantico: largo() espera un String.')
        else
        begin
          resultado.tipo := tpReal;
          resultado.valorReal := Length(resAux.valorString);
        end;
      end;
    tBusca:
      begin
        evalOpA(nodo^.Hijos[3], estado, resBuscar);
        evalOpA(nodo^.Hijos[5], estado, resTexto);
        if (resBuscar.tipo <> tpString) or (resTexto.tipo <> tpString) then writeln('Error Semantico: busca() requiere Strings.')
        else
        begin
          resultado.tipo := tpReal;
          resultado.valorReal := Pos(resBuscar.valorString, resTexto.valorString);
        end;
      end;
    tSubcad:
      begin
        evalOpA(nodo^.Hijos[3], estado, resTexto);
        evalOpA(nodo^.Hijos[5], estado, resPos);
        evalOpA(nodo^.Hijos[7], estado, resCant);
        if (resTexto.tipo <> tpString) or (resPos.tipo <> tpReal) or (resCant.tipo <> tpReal) then writeln('Error Semantico: Parametros incorrectos en subcad().')
        else
        begin
          resultado.tipo := tpString;
          resultado.valorString := Copy(resTexto.valorString, Round(resPos.valorReal), Round(resCant.valorReal));
        end;
      end;
    else writeln('Error en el evaluador: Nodo OpA4 desconocido.');
  end;
end;

end.
