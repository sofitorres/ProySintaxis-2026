unit UnitTAS;

interface

uses crt, Tipos;

Procedure InicializarTAS(var TAS: TipoTAS);
Procedure CargarTAS(var TAS: TipoTAS);

implementation

{ --- Inicializar TAS en nil --- }
Procedure InicializarTAS(var TAS: TipoTAS);
var
  i, j: SimboloGramatical;
begin
  for i := vPrograma to vOpRel do          //cada fila de la tas
    for j := tTingui to pesos do           //cada columna de la tas
      TAS[i, j] := nil;
end;

Procedure Poner(var TAS: TipoTAS; Fila, Col: SimboloGramatical; Produccion: Array of SimboloGramatical);    //Se colocan las producciones en elementos y la cantidad de las mismas en cant, produccion es un array que contiene cada produccion en esa fil y col
var k: Integer;
begin
  New(TAS[Fila, Col]);
  TAS[Fila, Col]^.cant := Length(Produccion);
  for k := 0 to High(Produccion) do
    TAS[Fila, Col]^.elementos[k + 1] := Produccion[k];
end;

{ --- Carga de la Tabla segun tu archivo TAS.xlsx --- }
Procedure CargarTAS(var TAS: TipoTAS);
begin
  { Reglas extraidas del CSV }
  Poner(TAS, vPrograma, tTingui, [tTingui, tCad, tPyC, vVariable, tLlaveAbre, vCuerpo, tLlaveCierra, tPunto]);

  Poner(TAS, vTipos, tReal, [tReal]);
  Poner(TAS, vTipos, tString, [tString]);

  Poner(TAS, vVariable, tVar, [tVar, vCuerpoVar]);
  Poner(TAS, vVariable, tLlaveAbre, []); { Epsilon }

  Poner(TAS, vCuerpoVar, tId, [tId, tDosP, vTipos, vCuerpoVarFact]);

  Poner(TAS, vCuerpoVarFact, tId, [vCuerpoVar]);
  Poner(TAS, vCuerpoVarFact, tLlaveAbre, []); { Epsilon }

  Poner(TAS, vCuerpo, tId, [vAsignacion, tPyC, vCuerpo]);
  Poner(TAS, vCuerpo, tIf, [vCondicional, tPyC, vCuerpo]);
  Poner(TAS, vCuerpo, tWrite, [vEscribir, tPyC, vCuerpo]);
  Poner(TAS, vCuerpo, tRead, [vLeer, tPyC, vCuerpo]);
  Poner(TAS, vCuerpo, tWhile, [vCiclica, tPyC, vCuerpo]);
  Poner(TAS, vCuerpo, tLlaveCierra, []); { Epsilon }
  Poner(TAS, vCuerpo, tId, [vAsignacion, tPyC, vCuerpo]);
  Poner(TAS, vCuerpo, tIf, [vCondicional, tPyC, vCuerpo]);
  Poner(TAS, vCuerpo, tWhile, [vCiclica, tPyC, vCuerpo]);
  Poner(TAS, vCuerpo, tWrite, [vEscribir, tPyC, vCuerpo]);
  Poner(TAS, vCuerpo, tRead, [vLeer, tPyC, vCuerpo]);
  Poner(TAS, vCuerpo, tLlaveCierra, []);

  Poner(TAS, vAsignacion, tId, [tId, tAsig, vOpA]);

  Poner(TAS, vEscribir, tWrite, [tWrite, tParAbre, vEscritura, tParCierra]);

  Poner(TAS, vEscritura, tId, [vOpA, vEscrituraFact]);
  Poner(TAS, vEscritura, tSqrt, [vOpA, vEscrituraFact]);
  Poner(TAS, vEscritura, tLargo, [vOpA, vEscrituraFact]);
  Poner(TAS, vEscritura, tSubcad, [vOpA, vEscrituraFact]);
  Poner(TAS, vEscritura, tBusca, [vOpA, vEscrituraFact]);
  Poner(TAS, vEscritura, tCad, [vOpA, vEscrituraFact]);
  Poner(TAS, vEscritura, tCreal, [vOpA, vEscrituraFact]);
  Poner(TAS, vEscritura, tParAbre, [vOpA, vEscrituraFact]);
  Poner(TAS, vEscritura, tMenos, [vOpA, vEscrituraFact]);

  Poner(TAS, vEscrituraFact, tParCierra, []); { Epsilon }
  Poner(TAS, vEscrituraFact, tComa, [tComa, vEscritura]);

  Poner(TAS, vCondicional, tIf, [tIf, vCondicion, tThen, tLlaveAbre, vCuerpo, tLlaveCierra, vCondFact]);
  Poner(TAS, vCondicional, tParCierra, []); { Epsilon }

  Poner(TAS, vCondFact, tElse, [tElse, tLlaveAbre, vCuerpo, tLlaveCierra]);
  Poner(TAS, vCondFact, tPyC, []); { Epsilon }

  Poner(TAS, vCondicion, tId, [vCondicion2, vCondFactorizada]);
  Poner(TAS, vCondicion, tSqrt, [vCondicion2, vCondFactorizada]);
  Poner(TAS, vCondicion, tNot, [vCondicion2, vCondFactorizada]);
  Poner(TAS, vCondicion, tLargo, [vCondicion2, vCondFactorizada]);
  Poner(TAS, vCondicion, tSubcad, [vCondicion2, vCondFactorizada]);
  Poner(TAS, vCondicion, tBusca, [vCondicion2, vCondFactorizada]);
  Poner(TAS, vCondicion, tCad, [vCondicion2, vCondFactorizada]);
  Poner(TAS, vCondicion, tCreal, [vCondicion2, vCondFactorizada]);
  Poner(TAS, vCondicion, tParAbre, [vCondicion2, vCondFactorizada]);
  Poner(TAS, vCondicion, tCorcheteAbre, [vCondicion2, vCondFactorizada]);
  Poner(TAS, vCondicion, tMenos, [vCondicion2, vCondFactorizada]);

  Poner(TAS, vCondFactorizada, tThen, []); { Epsilon }
  Poner(TAS, vCondFactorizada, tDo, []); { Epsilon }
  Poner(TAS, vCondFactorizada, tOr, [tOr, vCondicion]);
  Poner(TAS, vCondFactorizada, tCorcheteCierra, []); { Epsilon }

  Poner(TAS, vCondicion2, tId, [vCondicion3, vCond2Fact]);
  Poner(TAS, vCondicion2, tSqrt, [vCondicion3, vCond2Fact]);
  Poner(TAS, vCondicion2, tNot, [vCondicion3, vCond2Fact]);
  Poner(TAS, vCondicion2, tLargo, [vCondicion3, vCond2Fact]);
  Poner(TAS, vCondicion2, tSubcad, [vCondicion3, vCond2Fact]);
  Poner(TAS, vCondicion2, tBusca, [vCondicion3, vCond2Fact]);
  Poner(TAS, vCondicion2, tCad, [vCondicion3, vCond2Fact]);
  Poner(TAS, vCondicion2, tCreal, [vCondicion3, vCond2Fact]);
  Poner(TAS, vCondicion2, tParAbre, [vCondicion3, vCond2Fact]);
  Poner(TAS, vCondicion2, tCorcheteAbre, [vCondicion3, vCond2Fact]);
  Poner(TAS, vCondicion2, tMenos, [vCondicion3, vCond2Fact]);

  Poner(TAS, vCond2Fact, tThen, []); { Epsilon }
  Poner(TAS, vCond2Fact, tDo, []); { Epsilon }
  Poner(TAS, vCond2Fact, tAnd, [tAnd, vCondicion2]);
  Poner(TAS, vCond2Fact, tOr, []); { Epsilon }
  Poner(TAS, vCond2Fact, tCorcheteCierra, []); { Epsilon }

  Poner(TAS, vCondicion3, tId, [vOpA, vOpRel, vOpA]);
  Poner(TAS, vCondicion3, tSqrt, [vOpA, vOpRel, vOpA]);
  Poner(TAS, vCondicion3, tNot, [tNot, vCondicion3]);
  Poner(TAS, vCondicion3, tLargo, [vOpA, vOpRel, vOpA]);
  Poner(TAS, vCondicion3, tSubcad, [vOpA, vOpRel, vOpA]);
  Poner(TAS, vCondicion3, tBusca, [vOpA, vOpRel, vOpA]);
  Poner(TAS, vCondicion3, tCad, [vOpA, vOpRel, vOpA]);
  Poner(TAS, vCondicion3, tCreal, [vOpA, vOpRel, vOpA]);
  Poner(TAS, vCondicion3, tParAbre, [vOpA, vOpRel, vOpA]);
  Poner(TAS, vCondicion3, tCorcheteAbre, [tCorcheteAbre, vCondicion, tCorcheteCierra]);
  Poner(TAS, vCondicion3, tMenos, [vOpA, vOpRel, vOpA]);

  Poner(TAS, vCiclica, tWhile, [tWhile, vCondicion, tDo, tLlaveAbre, vCuerpo, tLlaveCierra]);

  Poner(TAS, vLeer, tRead, [tRead, tParAbre, vOpA, tComa, tId, tParCierra]);

  Poner(TAS, vOpA, tId, [vOpA2, vOpAFact]);
  Poner(TAS, vOpA, tSqrt, [vOpA2, vOpAFact]);
  Poner(TAS, vOpA, tLargo, [vOpA2, vOpAFact]);
  Poner(TAS, vOpA, tSubcad, [vOpA2, vOpAFact]);
  Poner(TAS, vOpA, tBusca, [vOpA2, vOpAFact]);
  Poner(TAS, vOpA, tCad, [vOpA2, vOpAFact]);
  Poner(TAS, vOpA, tCreal, [vOpA2, vOpAFact]);
  Poner(TAS, vOpA, tParAbre, [vOpA2, vOpAFact]);
  Poner(TAS, vOpA, tMenos, [vOpA2, vOpAFact]);

  { -- Producciones de OpAFact para todos los Siguientes (OpR y signos) -- }
  Poner(TAS, vOpAFact, tMayor, []); { Epsilon }
  Poner(TAS, vOpAFact, tMenor, []); { Epsilon }
  Poner(TAS, vOpAFact, tIgual, []); { Epsilon }
  Poner(TAS, vOpAFact, tMayorIgual, []); { Epsilon }
  Poner(TAS, vOpAFact, tMenorIgual, []); { Epsilon }
  Poner(TAS, vOpAFact, tDistinto, []); { Epsilon }
  Poner(TAS, vOpAFact, tParCierra, []); { Epsilon }
  Poner(TAS, vOpAFact, tCorcheteCierra, []); { Epsilon }
  Poner(TAS, vOpAFact, tComa, []); { Epsilon }
  Poner(TAS, vOpAFact, tPyC, []); { Epsilon }
  Poner(TAS, vOpAFact, tMas, [tMas, vOpA]);
  Poner(TAS, vOpAFact, tMenos, [tMenos, vOpA]);
  Poner(TAS, vOpAFact, tDo, []);
  Poner(TAS, vOpAFact, tThen, []);
  Poner(TAS, vOpAFact, tAnd, []);
  Poner(TAS, vOpAFact, tOr, []);


  Poner(TAS, vOpA2, tId, [vOpA3, vOpA2Fact]);
  Poner(TAS, vOpA2, tSqrt, [vOpA3, vOpA2Fact]);
  Poner(TAS, vOpA2, tLargo, [vOpA3, vOpA2Fact]);
  Poner(TAS, vOpA2, tSubcad, [vOpA3, vOpA2Fact]);
  Poner(TAS, vOpA2, tBusca, [vOpA3, vOpA2Fact]);
  Poner(TAS, vOpA2, tCad, [vOpA3, vOpA2Fact]);
  Poner(TAS, vOpA2, tCreal, [vOpA3, vOpA2Fact]);
  Poner(TAS, vOpA2, tParAbre, [vOpA3, vOpA2Fact]);
  Poner(TAS, vOpA2, tMenos, [vOpA3, vOpA2Fact]);


  Poner(TAS, vOpA2Fact, tMayor, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tMenor, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tIgual, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tMayorIgual, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tMenorIgual, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tDistinto, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tParCierra, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tCorcheteCierra, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tComa, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tPyC, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tPor, [tPor, vOpA2]);
  Poner(TAS, vOpA2Fact, tMas, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tMenos, []); { Epsilon }
  Poner(TAS, vOpA2Fact, tDiv, [tDiv, vOpA2]);
  Poner(TAS, vOpA2Fact, tDo, []);
  Poner(TAS, vOpA2Fact, tThen, []);
  Poner(TAS, vOpA2Fact, tAnd, []);
  Poner(TAS, vOpA2Fact, tOr, []);

  Poner(TAS, vOpA3, tId, [vOpA4, vOpA3Fact]);
  Poner(TAS, vOpA3, tSqrt, [tSqrt, tParAbre, vOpA, tParCierra]);
  Poner(TAS, vOpA3, tLargo, [vOpA4, vOpA3Fact]);
  Poner(TAS, vOpA3, tSubcad, [vOpA4, vOpA3Fact]);
  Poner(TAS, vOpA3, tBusca, [vOpA4, vOpA3Fact]);
  Poner(TAS, vOpA3, tCad, [vOpA4, vOpA3Fact]);
  Poner(TAS, vOpA3, tCreal, [vOpA4, vOpA3Fact]);
  Poner(TAS, vOpA3, tParAbre, [vOpA4, vOpA3Fact]);
  Poner(TAS, vOpA3, tMenos, [vOpA4, vOpA3Fact]);

  Poner(TAS, vOpA3Fact, tMayor, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tMenor, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tIgual, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tMayorIgual, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tMenorIgual, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tDistinto, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tParCierra, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tComa, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tPyC, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tPor, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tMas, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tMenos, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tDiv, []); { Epsilon }
  Poner(TAS, vOpA3Fact, tPotencia, [tPotencia, vOpA4]);
  Poner(TAS, vOpA3Fact, tDo, []);
  Poner(TAS, vOpA3Fact, tThen, []);
  Poner(TAS, vOpA3Fact, tAnd, []);
  Poner(TAS, vOpA3Fact, tOr, []);

  Poner(TAS, vOpA4, tId, [tId]);
  Poner(TAS, vOpA4, tLargo, [tLargo, tParAbre, vOpA, tParCierra]);
  Poner(TAS, vOpA4, tSubcad, [tSubcad, tParAbre, vOpA, tComa, vOpA, tComa, vOpA, tParCierra]);
  Poner(TAS, vOpA4, tBusca, [tBusca, tParAbre, vOpA, tComa, vOpA, tParCierra]);
  Poner(TAS, vOpA4, tCad, [tCad]);
  Poner(TAS, vOpA4, tCreal, [tCreal]);
  Poner(TAS, vOpA4, tParAbre, [tParAbre, vOpA, tParCierra]);
  Poner(TAS, vOpA4, tMenos, [tMenos, vOpA4]);

  { --- Producciones para Operadores Relacionales (Generico) --- }
  { Como el CSV usa 'OpR' como placeholder, cargamos todos los operadores reales aqui }
  Poner(TAS, vOpRel, tMayor, [tMayor]);
  Poner(TAS, vOpRel, tMenor, [tMenor]);
  Poner(TAS, vOpRel, tIgual, [tIgual]);
  Poner(TAS, vOpRel, tMayorIgual, [tMayorIgual]);
  Poner(TAS, vOpRel, tMenorIgual, [tMenorIgual]);
  Poner(TAS, vOpRel, tDistinto, [tDistinto]);
end;

end.
