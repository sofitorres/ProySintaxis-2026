unit Tipos;

interface

Const
  Elemmax=10;
  MaxSim=200;

type
  SimboloGramatical = (
    { --- TERMINALES --- }
    tTingui, tVar, tId, tIf, tThen, tElse,
    tWrite, tRead, tWhile, tDo,
    tReal, tString, tSqrt, tLargo, tSubcad, tBusca, tCad, tCreal,

    { Operadores Logicos }
    tAnd, tNot, tOr,

    { Puntuacion }
    tParAbre, tParCierra,       { ( ) }
    tLlaveAbre, tLlaveCierra,   { { } }
    tCorcheteAbre, tCorcheteCierra, { [ ] }
    tDosP, tComa, tPyC, tPunto, { : , ; . }
    tAsig,                      { <- }

    { Aritmetica }
    tPor, tMas, tMenos, tDiv, tPotencia, { * + - / ^ }

    { Relacionales }
    tMayor, tMenor, tIgual, tMayorIgual, tMenorIgual, tDistinto,

    pesos, { Fin de archivo }

    { --- NO TERMINALES --- }
    vPrograma, vTipos, vVariable, vCuerpoVar, vCuerpoVarFact,
    vCuerpo, vAsignacion, vEscribir, vEscritura, vEscrituraFact,
    vCondicional, vCondFact, vCondicion, vCondFactorizada,
    vCondicion2, vCond2Fact, vCondicion3, vCiclica, vLeer,
    vOpA, vOpAFact, vOpA2, vOpA2Fact, vOpA3, vOpA3Fact, vOpA4,
    vOpRel
  );

  TPrincipalTipo = (tpReal, tpString);

  tResultado = record
    case tipo: TPrincipalTipo of
      tpReal: (valorReal: Real);
      tpString: (valorString: string[100]);
  end;

  TVariableMemoria = record
    nombre: string;
    tipo: TPrincipalTipo;
    valor: tResultado;
    inicializada: Boolean;
  end;
  { DEFINIMOS EL TOKEN AQUI PARA TODOS }
  TElemTS = record
    compLex: SimboloGramatical;
    Lexema: string;
  end;
  tEstado = record
    variables: array[1..MaxSim] of TVariableMemoria;
    cant: 0..MaxSim;
  end;

  // Tu estructura "tEstado" debería mapear un ID (string) a un tResultado

  PunteroCelda = ^CeldaTAS;
  CeldaTAS = record
    cant: Integer;
    elementos: array[1..Elemmax] of SimboloGramatical;
  end;



  TipoTAS = array[vPrograma..vOpRel, tTingui..pesos] of PunteroCelda;

implementation

end.
