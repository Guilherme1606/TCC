unit TelaDeLogin.Repository;

interface

uses
  Due.Utilitarios.Base.Repository,
  Due.Utilitarios.Base.Types,
  TelaDeLogin.Interfaces,
  System.generics.collections,
  System.SysUtils,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  IdHashMessageDigest,
  FireDAC.DApt,
  Data.DB,
  DueDMControle;

type
  TTelaDeLoginRepository = class(TBaseRepository, ITelaDeLoginRepository)
    function CriptografaSenha(const value: string): string;
  public
    function Atualizar(aModel: ITelaDeLoginModel): TValidacao;
    function Inserir(aModel: ITelaDeLoginModel): TValidacao;
    function Excluir(aModel: ITelaDeLoginModel): TValidacao;
    function ValidaUsuarioLogin(aModel: ITelaDeLoginModel):TValidacao;
    function RetornaUsuarios: TFDDataSet;
    function BuscaUsuarios(aModel: ITelaDeLoginModel): TFDDataSet;
  end;

implementation

{ TTelaDeLoginRepository }

function TTelaDeLoginRepository.Atualizar(
  aModel: ITelaDeLoginModel): TValidacao;
  procedure RealizaAtualizacao;
  var
    FQry : TFDQuery;
  begin
    FQry :=  TFDQuery.Create(nil);
    FQry.ConnectionName :=  'DbBGM';
    FQry.SQL.Add('UPDATE TB_CADASTRO_USUARIO SET NOME_COMPLETO = :PNOME,EMAIL = :P_EMAIL,');
    FQry.SQL.Add('SENHA = :P_SENHA, STATUS = :P_STATUS,PERMISSAO = :P_PERMISSAO WHERE ID = :P_ID');
    FQry.ParamByName('P_ID').AsInteger        := aModel.ID;
    FQry.ParamByName('PNOME').AsString       := aModel.Nome_Completo;
    FQry.ParamByName('P_EMAIL').AsString     := aModel.Email;
    FQry.ParamByName('P_SENHA').AsString     := aModel.Senha;
    FQry.ParamByName('STATUS').AsString      := aModel.Status;
    FQry.ParamByName('P_PERMISSAO').AsString := aModel.Permissao;
    FQry.ExecSQL;
  end;
begin
  try
    RealizaAtualizacao;
    result.Valido := true;
    result.Mensagem := 'Usu�rio: ' + aModel.Usuario + ' atualizado com sucesso';
  except
    On E: Exception Do
    Begin
      result.Mensagem := E.Message;
      result.Valido := False;
    End;
  end;

end;
function TTelaDeLoginRepository.BuscaUsuarios(
  aModel: ITelaDeLoginModel): TFDDataSet;
var
  FQry : TFDQuery;
begin
  FQry :=  TFDQuery.Create(nil);
  FQry.ConnectionName :=  'DbBGM';
  FQry.SQL.Add('SELECT NOME_COMPLETO FROM TB_CADASTRO_USUARIO WHERE ID = :P_ID');
  FQry.ParamByName('P_ID').AsInteger := aModel.ID;
  FQry.open;
  result := FQry;
end;

function TTelaDeLoginRepository.CriptografaSenha(const value: string): string;
var
  xMD5: TIdHashMessageDigest5;
begin
  xMD5 := TIdHashMessageDigest5.create;
  try
    result := LowerCase(xMD5.HashStringAsHex(value));
  finally
    xMD5.Free;
  end;
end;

function TTelaDeLoginRepository.Excluir(aModel: ITelaDeLoginModel): TValidacao;
var
  FQry : TFDQuery;
  procedure RealizaExclusao;
  begin
    FQry :=  TFDQuery.Create(nil);
    FQry.ConnectionName :=  'DbBGM';
    FQry.SQL.Add('UPDATE  TB_CADASTRO_USUARIO SET STATUS = ''DESLIGADO'' WHERE ID = :P_ID');
    FQry.ParamByName('P_ID').AsInteger := aModel.ID;
    FQry.ExecSQL;
    FreeAndNil(FQry);
  end;
begin
  try
    RealizaExclusao;
    result.Valido := true;
    result.Mensagem := 'Usu�rio: ' + aModel.Usuario + ' Desligado com sucesso';
  except
    On E: Exception Do
    Begin
      result.Mensagem := E.Message;
      result.Valido := False;
    End;
  end;
end;

function TTelaDeLoginRepository.Inserir(aModel: ITelaDeLoginModel): TValidacao;
var
  FQry : TFDQuery;
  procedure RealizaInclusao;
  begin
    FQry :=  TFDQuery.Create(nil);
    FQry.ConnectionName :=  'DbBGM';
    FQry.SQL.Add('INSERT INTO TB_CADASTRO_USUARIO(ID,USUARIO,NOME_COMPLETO,EMAIL,SENHA)');
    FQry.SQL.Add('VALUES(IDENTIFICADOR.nextval,:P_USUARIO,:P_NOMECOMPLETO,:P_EMAIL,:P_SENHA)');
    FQry.ParamByName('P_USUARIO').AsString := aModel.Usuario;
    FQry.ParamByName('P_NOMECOMPLETO').AsString := aModel.Nome_Completo;
    FQry.ParamByName('P_EMAIL').AsString := aModel.Email;
    FQry.ParamByName('P_SENHA').AsString := CriptografaSenha(aModel.Senha);
    FQry.ExecSQL;
    FreeAndNil(FQry);
  end;
begin
  try
    RealizaInclusao;
    result.Valido := true;
    result.Mensagem := 'Usu�rio: ' + amodel.Usuario + ' cadastrado com sucesso';
  except
    On E: Exception Do
    Begin
      result.Mensagem := E.Message;
      result.Valido := False;
    End;
  end;
end;

function TTelaDeLoginRepository.RetornaUsuarios: TFDDataSet;
var
  FQry : TFDQuery;
begin
  FQry :=  TFDQuery.Create(nil);
  FQry.ConnectionName :=  'DbBGM';
  FQry.SQL.Add('SELECT USUARIO FROM TB_CADASTRO_USUARIO WHERE STATUS <> ''DESLIGADO''');
  FQry.open;
  result := FQry;
end;

function TTelaDeLoginRepository.ValidaUsuarioLogin(
  aModel: ITelaDeLoginModel): TValidacao;
var
  FQry : TFDQuery;
begin
  result.Valido := false;
  FQry :=  TFDQuery.Create(nil);
  FQry.ConnectionName :=  'DbBGM';
  FQry.SQL.Add('SELECT USUARIO,SENHA        ');
  FQry.SQL.Add('FROM   TB_CADASTRO_USUARIO  ');
  FQry.SQL.Add('WHERE  USUARIO = :P_USUARIO');
  FQry.ParamByName('P_USUARIO').AsString := aModel.Usuario;
  FQry.open;

  if FQry.IsEmpty then
  begin
    result.Mensagem := 'Usu�rio n�o cadastrado';
    exit;
  end;

  var criptografasenha :=  CriptografaSenha(aModel.Senha);
  if FQry.FieldByName('SENHA').AsString = criptografasenha then
    result.Valido := true
  else
    result.Mensagem := 'Senha Incorreta';

  FreeAndNil(FQry);
end;

end.
