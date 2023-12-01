unit TelaDeLogin.Register;

interface

uses
  Spring.container;

procedure RegisterTypes(Const container: TContainer);

implementation

uses
  TelaDeLogin.Repository,
  TelaDeLogin.UseCase,
  TelaDeLogin.Model,
  DueConexao;

procedure RegisterTypes(Const container: TContainer);
begin
  container.RegisterType<TTelaDeLoginRepository>;
  container.RegisterType<TTelaDeLoginUseCase>;
  container.RegisterType<TTelaDeLoginModel>;
  container.RegisterType<TConexao>;
  container.Build;
end;

end.
