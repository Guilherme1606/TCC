unit Contrato.Register;

interface

uses
  Spring.container;

procedure RegisterTypes(Const container: TContainer);

implementation

uses
  Contrato.Repository,
  Contrato.UseCase,
  Contrato.Model;

procedure RegisterTypes(Const container: TContainer);
begin
  container.RegisterType<TContratosRepository>;
  container.RegisterType<TContratosUseCase>;
  container.RegisterType<TContratosModel>;
  container.Build;
end;

end.
