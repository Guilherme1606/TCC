unit DueConexao;

interface
  uses
  System.StrUtils,
  System.SysUtils,
  FireDac.Comp.Client,
  FireDAC.Phys.Oracle,
  FireDac.Stan.Def,
  FireDAC.VCLUI.Wait,
  FireDac.Stan.Async,
  FireDac.Stan.Option,
  FireDac.Stan.Param,
  FireDAC.Moni.FlatFile,
  DueIConexao,
  DueDMControle,
  Due.Utilitarios.Base.Types,
  Vcl.Dialogs;
type
  TConexao = class(TInterfacedObject, IConexao)
    private
      vcDatabase: TFDConnection;
    public

      procedure AtivarTrancing(var aFDMoniFlatFileClientLink : TFDMoniFlatFileClientLink);
      procedure DesativarTrancing(var aFDMoniFlatFileClientLink : TFDMoniFlatFileClientLink);
      function Conectar(var ADatabase: TFDConnection): Boolean; overload;
      function Conectar(var ADatabase: TFDConnection; pMsgCustomizada: string): Boolean; overload;
      function ReconectaBanco(AUsuario, ASenha: string): Boolean;
      procedure PopulaPametroConexaoManual(var ADatabase: TFDConnection; pUsuario, pSenha, pServidor: string);
      procedure PopularParametroConexao(var ADatabase: TFDConnection);
      function DatabaseName: string;
      function Database: TFDConnection;
      function InTransaction: Boolean;
      procedure Rollback; overload;
      procedure StartTransaction; overload;
      procedure Commit;overload;
      procedure StartTransaction(var aValue :TEnumOrigemTransacao) ; overload;
      procedure Rollback(var aValue :TEnumOrigemTransacao); overload;
      procedure Commit(var aValue :TEnumOrigemTransacao);overload;
      class function New: IConexao;
      constructor create;
  end;
implementation

{ TConexao }

uses
  Prx.Utilitarios.FDconnection,
  Ctr.Cadastro.Usuario.Model;

{ TConexao }

procedure TConexao.AtivarTrancing(var aFDMoniFlatFileClientLink: TFDMoniFlatFileClientLink);
begin

  aFDMoniFlatFileClientLink.FileName := GetCurrentDir + '\FireDac_' +
     FormatDateTime('yyyymmddhhnnss', now) + '.Log';

  aFDMoniFlatFileClientLink.Tracing := True;

end;

procedure TConexao.Commit;
begin

  if vcDatabase.InTransaction then
    vcDatabase.Commit;

end;

procedure TConexao.Commit(var aValue: TEnumOrigemTransacao);
begin

  if not vcDatabase.InTransaction then
    exit;

  if aValue = otLocal then
    vcDatabase.Commit;

end;

function TConexao.Conectar(var aDatabase: TFDConnection;
  pMsgCustomizada: string): Boolean;
begin
  result := Prx.Utilitarios.FDconnection.Conectar(aDatabase,pMsgCustomizada);
end;

constructor TConexao.create;
begin
  vcDatabase := TFDConnection.Create(nil);
  vcDatabase.DriverName := 'ORA';
  vcDatabase.LoginPrompt := false;
  vcDatabase.Params.UserName :=  'BBTT230209';
  vcDatabase.Params.Password :=  'BBTT230209';
  vcDatabase.Params.Database :=  'ORA11G64';
  vcDatabase.Open;
  vcDatabase.Connected := true;
end;

function TConexao.Conectar(var aDatabase: TFDConnection): Boolean;
begin
  result := Prx.Utilitarios.FDconnection.Conectar(aDatabase);
end;

function TConexao.Database: TFDConnection;
begin
  Result := vcDatabase;
end;

function TConexao.DatabaseName: string;
begin
  Result := 'teste';
end;

procedure TConexao.DesativarTrancing(var aFDMoniFlatFileClientLink: TFDMoniFlatFileClientLink);
begin
  aFDMoniFlatFileClientLink.Tracing := false;
end;



function TConexao.InTransaction: Boolean;
begin
  Result := vcDatabase.InTransaction;
end;

class function TConexao.New: IConexao;
begin
  result := Self.Create;
end;

procedure TConexao.PopulaPametroConexaoManual(var aDatabase: TFDConnection;
  pUsuario,
  pSenha,
  pServidor: string);
begin
 Prx.Utilitarios.FDconnection.PopulaPametroConexaoManual(aDatabase, pUsuario, pSenha, pServidor);
end;

procedure TConexao.PopularParametroConexao(var aDatabase: TFDConnection);
begin
  Prx.Utilitarios.FDconnection.PopularParametroConexao( aDatabase );
end;

function TConexao.ReconectaBanco(AUsuario, ASenha: string): Boolean;
begin
  result := Prx.Utilitarios.FDconnection
    .ReconectaBanco(AUsuario, ASenha);
end;

procedure TConexao.Rollback(var aValue: TEnumOrigemTransacao);
begin

  if not vcDatabase.InTransaction then
    exit;

  if aValue = otLocal then
    vcDatabase.Rollback;

end;

procedure TConexao.Rollback;
begin

  if vcDatabase.InTransaction then
    vcDatabase.Rollback;

end;

procedure TConexao.StartTransaction;
begin

  if vcDatabase.InTransaction then
    vcDatabase.Rollback;

  vcDatabase.StartTransaction;

end;

procedure TConexao.StartTransaction(var aValue: TEnumOrigemTransacao);
begin


  try

  aValue := otLocal;


    if vcDatabase.InTransaction then
     aValue := otExterno
  else
    vcDatabase.StartTransaction;
  except
    On E: Exception Do
    Begin
      showmessage(E.Message);
    End;
  end;

end;

end.
