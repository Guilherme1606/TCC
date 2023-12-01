unit TelaDeLogin.UseCase;

interface
uses
  Due.Utilitarios.Base.UseCase,
  Due.Utilitarios.Base.Types,
  TelaDeLogin.Interfaces,
  DueIConexao,
  Due.Utilitarios.Base.Model,
  Vcl.Dialogs,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TTelaDeLoginUseCase = class(TBaseUseCase, ITelaDeLoginUseCase)
  private
    FRepository: ITelaDeLoginRepository;
    FConexao: IConexao;
  public
    function Gravar(aModel: ITelaDeLoginModel): TValidacao;
    function Excluir(aModel: ITelaDeLoginModel): TValidacao;
    constructor Create(aRepository: ITelaDeLoginRepository;
      aConexao: IConexao);
    function ValidaUsuarioLogin(aModel: ITelaDeLoginModel):TValidacao;
    function RetornaUsuarios: TFDDataSet;
    function BuscaUsuarios(aModel: ITelaDeLoginModel): TFDDataSet;
  end;
implementation

{ TTelaDeLoginUseCase }
function TTelaDeLoginUseCase.BuscaUsuarios(
  aModel: ITelaDeLoginModel): TFDDataSet;
begin
  Result := FRepository.BuscaUsuarios(aModel);
end;

constructor TTelaDeLoginUseCase.Create(
  aRepository: ITelaDeLoginRepository; aConexao: IConexao);
begin
  FRepository := aRepository;
  FConexao := aConexao;
end;

function TTelaDeLoginUseCase.Excluir(
  aModel: ITelaDeLoginModel): TValidacao;
begin
  result := FRepository.Excluir(aModel);
end;

function TTelaDeLoginUseCase.Gravar(
  aModel: ITelaDeLoginModel): TValidacao;
begin
  FConexao.StartTransaction(FOrigemTransacao);
  If aModel.NovoRegistro Then
    result := FRepository.Inserir(aModel)
  Else
    result := FRepository.Atualizar(aModel);
end;

function TTelaDeLoginUseCase.RetornaUsuarios: TFDDataSet;
begin
  result := FRepository.RetornaUsuarios;
end;

function TTelaDeLoginUseCase.ValidaUsuarioLogin(
  aModel: ITelaDeLoginModel): TValidacao;
begin
  result := FRepository.ValidaUsuarioLogin(aModel);
end;

end.
