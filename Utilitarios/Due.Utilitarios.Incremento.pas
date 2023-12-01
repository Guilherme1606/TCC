{$I \Globus\Sistemas\Globus.inc}
unit Due.Utilitarios.Incremento;

interface

function IncInt(var pVlr: Integer; pIncremento: Integer = 1): Integer;


function DecInt(var pVlr: Integer; pDecremento: Integer = 1): Integer;

function IncDbl(pValor: Double; pIncremento: Double): Double;

procedure IncD(var pValor: Double; pIncremento: Integer = 1);
  

implementation

function IncInt(var pVlr: Integer; pIncremento: Integer = 1): Integer; { Incrementa uma variável de tipo inteiro e devolve o valor atualizado }
begin
  Inc(pVlr, pIncremento);
  Result := pVlr;
end;

function DecInt(var pVlr: Integer; pDecremento: Integer = 1): Integer; { Decrementa uma variável de tipo inteiro e devolve o valor atualizado }
begin
  Dec(pVlr, pDecremento);
  Result := pVlr;
end;

function IncDbl(pValor: Double; pIncremento: Double): Double;
begin

  Result := (pValor + pIncremento);

end;

procedure IncD(var pValor: Double; pIncremento: Integer = 1);
begin

  pValor := pValor + pIncremento;

end;

end.
