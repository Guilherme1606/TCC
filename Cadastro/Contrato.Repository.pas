unit Contrato.Repository;

interface
uses
  Due.Utilitarios.Base.Repository,
  Due.Utilitarios.Base.Types,
  Contrato.Interfaces,
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
  TContratosRepository = class(TBaseRepository, IContratosRepository)
  private

  public
    function Atualizar(aModel: IContratosModel): TValidacao;
    function Inserir(aModel: IContratosModel): TValidacao;
    function RetornaContratos: TFDDataSet;
    function BuscaContratos(aModel: IContratosModel): TFDDataSet;

  end;
implementation

{ TContratosRepository }

function TContratosRepository.Atualizar(aModel: IContratosModel): TValidacao;
var
  FQry : TFDQuery;
  procedure RealizaAtualizacao;
  begin
    FQry :=  TFDQuery.Create(nil);
    FQry.ConnectionName :=  'DbBGM';
    FQry.SQL.Add('UPDATE  TB_CADASTRO_CONTRATO SET STATUS  = :P_Status,');
    FQry.SQL.Add('USUARIO_RESPONSAVEL = :P_Usuario WHERE ID_Contrato = :P_ID');
    FQry.ParamByName('P_ID').Asinteger := aModel.ID_Contrato;
    FQry.ParamByName('P_Status').AsString := aModel.Status;
    FQry.ParamByName('P_Usuario').Asinteger := aModel.Usuario_Responsavel;
    FQry.ExecSQL;
    FreeAndNil(FQry);
  end;
begin
  try
    RealizaAtualizacao;
    result.Valido := true;
    result.Mensagem := 'Contrato: ' + inttostr(amodel.ID_Contrato) + ' atualizado com sucesso';
  except
    On E: Exception Do
    Begin
      result.Mensagem := E.Message;
      result.Valido := False;
    End;
  end;

end;

function TContratosRepository.BuscaContratos(
  aModel: IContratosModel): TFDDataSet;
var
  FQry : TFDQuery;
begin
  FQry :=  TFDQuery.Create(nil);
  FQry.ConnectionName :=  'DbBGM';
  FQry.SQL.Add('SELECT CONTRATO.*,                          ');
  FQry.SQL.Add('     USU.USUARIO AS  USU                    ');
  FQry.SQL.Add('FROM TB_CADASTRO_CONTRATO       CONTRATO    ');
  FQry.SQL.Add('LEFT JOIN TB_CADASTRO_USUARIO   USU         ');
  FQry.SQL.Add('ON CONTRATO.USUARIO_RESPONSAVEL = USU.ID    ');
  FQry.SQL.Add('WHERE ID_CONTRATO = :P_ID                   ');
  FQry.ParamByName('P_ID').Asinteger := aModel.ID_Contrato;
  FQry.open;
  result := FQry;
end;

function TContratosRepository.Inserir(aModel: IContratosModel): TValidacao;
var
  FQry : TFDQuery;
  procedure RealizaInclusao;
  begin
    FQry :=  TFDQuery.Create(nil);
    FQry.ConnectionName :=  'DbBGM';
    FQry.SQL.Add('INSERT INTO TB_CADASTRO_CONTRATO(ID_CONTRATO,CPF,Servico,Inicio,Entrega,Valor)');
    FQry.SQL.Add('VALUES(IDENTIFICADOR_CONTRATO.NEXTVAL,:P_CPF,:P_Servico,:P_Inicio,:P_Entrega,:P_Valor)');
    FQry.ParamByName('P_CPF').AsString := aModel.CPF;
    FQry.ParamByName('P_Servico').AsString := aModel.Servico;
    FQry.ParamByName('P_Inicio').AsDateTime := aModel.Inicio;
    FQry.ParamByName('P_Entrega').AsDateTime := aModel.Entrega;
    FQry.ParamByName('P_Valor').value := aModel.Valor;
    FQry.ExecSQL;
    FreeAndNil(FQry);
  end;
begin
  try
    RealizaInclusao;
    result.Valido := true;
    result.Mensagem := 'Contrato para o CPF: ' + amodel.CPF + ' cadastrado com sucesso';
  except
    On E: Exception Do
    Begin
      result.Mensagem := E.Message;
      result.Valido := False;
    End;
  end;

end;

function TContratosRepository.RetornaContratos: TFDDataSet;
var
  FQry : TFDQuery;
begin
  FQry :=  TFDQuery.Create(nil);
  FQry.ConnectionName :=  'DbBGM';
  FQry.SQL.Add('SELECT CONTRATO.*,                          ');
  FQry.SQL.Add('     USU.USUARIO AS USU                     ');
  FQry.SQL.Add('FROM TB_CADASTRO_CONTRATO       CONTRATO    ');
  FQry.SQL.Add('LEFT JOIN TB_CADASTRO_USUARIO   USU         ');
  FQry.SQL.Add('ON CONTRATO.USUARIO_RESPONSAVEL = USU.ID    ');
  FQry.open;
  result := FQry;
end;

end.
