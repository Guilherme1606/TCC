unit Due.Utilitarios.Base.Repository;

interface

Uses
  Spring.Container;

type
  TBaseRepository = class(TInterfacedObject)
  private
  public
    function Resolve<T>: T;
  end;

implementation

{ TBaseRepository }

function TBaseRepository.Resolve<T>: T;
begin
  result := GlobalContainer.Resolve<T>;
end;

end.
