unit Due.Utilitarios.Base.UseCase;

interface

uses
   Spring.Container,
   Due.Utilitarios.Base.Types;

type
  TBaseUseCase = class(TInterfacedObject)
  private
    procedure SetOrigemTransacao(const Value: TEnumOrigemTransacao);
    function GetOrigemTransacao : TEnumOrigemTransacao;
  public
    FOrigemTransacao: TEnumOrigemTransacao;
    function Resolve<T>: T;
    property OrigemTransacao : TEnumOrigemTransacao
       read GetOrigemTransacao write SetOrigemTransacao;

  end;

implementation

{ TBaseUseCase }

function TBaseUseCase.Resolve<T>: T;
begin
  result := GlobalContainer.Resolve<T>;
end;

procedure TBaseUseCase.SetOrigemTransacao(const Value: TEnumOrigemTransacao);
begin
  FOrigemTransacao := Value;
end;

function TBaseUseCase.GetOrigemTransacao : TEnumOrigemTransacao;
begin
  result :=  FOrigemTransacao;
end;

end.
