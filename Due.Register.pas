unit Due.Register;

interface

uses
  Spring.Container;

procedure RegisterTypes(const Container : TContainer);

implementation

uses
  TelaDeLogin.Register,
  Cliente.Register,
  Contrato.Register;

procedure RegisterTypes(const Container : TContainer);
begin
  TelaDeLogin.Register.RegisterTypes(Container);
  Cliente.Register.RegisterTypes(Container);
  Contrato.Register.RegisterTypes(Container);
  Container.Build;
end;

end.
