program Projeto_Sistema_Arquitetura;

uses
  Vcl.Forms,
  Spring.Container,
  Menu_Principal in 'Menu_Principal.pas' {TMenu_Principal},
  FormularioBase.View in 'Utilitarios\FormularioBase.View.pas' {FormularioBase},
  Inserirtarefa.View in 'Cadastro\Inserirtarefa.View.pas' {InserirTarefa},
  Due.Funcoes.Utilitarios in 'Utilitarios\Due.Funcoes.Utilitarios.pas',
  Relatorio.View in 'Movimentacoes\Relatorio.View.pas' {Relatorios},
  Graficos.View in 'Movimentacoes\Graficos.View.pas' {Graficos},
  TelaDeLogin.Interfaces in 'Cadastro\TelaDeLogin.Interfaces.pas',
  Due.Utilitarios.Base.Types in 'Utilitarios\Due.Utilitarios.Base.Types.pas',
  TelaDeLogin.Model in 'Cadastro\TelaDeLogin.Model.pas',
  Due.Utilitarios.Base.Model in 'Utilitarios\Due.Utilitarios.Base.Model.pas',
  TelaDeLogin.UseCase in 'Cadastro\TelaDeLogin.UseCase.pas',
  DueIConexao in 'Utilitarios\DueIConexao.pas',
  TelaDeLogin.Register in 'Cadastro\TelaDeLogin.Register.pas',
  Due.Utilitarios.Base.Repository in 'Utilitarios\Due.Utilitarios.Base.Repository.pas',
  Due.Utilitarios.Base.UseCase in 'Utilitarios\Due.Utilitarios.Base.UseCase.pas',
  TelaDeLogin.Repository in 'Cadastro\TelaDeLogin.Repository.pas',
  Due.Register in 'Due.Register.pas',
  TelaDeLogin.View in 'Cadastro\TelaDeLogin.View.pas' {TTelaDeLoginView},
  DueQueryAuxiliar in 'Utilitarios\DueQueryAuxiliar.pas',
  DueDMControle in 'Utilitarios\DueDMControle.pas' {DataModule1: TDataModule},
  DueConexao in 'Utilitarios\DueConexao.pas',
  Cliente.View in 'Cadastro\Cliente.View.pas' {ClientesView},
  Cliente.Model in 'Cadastro\Cliente.Model.pas',
  Cliente.Interfaces in 'Cadastro\Cliente.Interfaces.pas',
  Cliente.UseCase in 'Cadastro\Cliente.UseCase.pas',
  Cliente.Repository in 'Cadastro\Cliente.Repository.pas',
  Cliente.Register in 'Cadastro\Cliente.Register.pas',
  Contrato.Model in 'Cadastro\Contrato.Model.pas',
  Contrato.Interfaces in 'Cadastro\Contrato.Interfaces.pas',
  Contrato.UseCase in 'Cadastro\Contrato.UseCase.pas',
  Contrato.Repository in 'Cadastro\Contrato.Repository.pas',
  Contrato.Register in 'Cadastro\Contrato.Register.pas',
  Due.Utilitarios.Incremento in 'Utilitarios\Due.Utilitarios.Incremento.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Due.Register.RegisterTypes( GlobalContainer );
  Application.CreateForm(TTTelaDeLoginView, TTelaDeLoginView);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
