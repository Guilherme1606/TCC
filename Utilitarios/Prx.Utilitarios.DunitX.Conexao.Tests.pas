unit Prx.Utilitarios.DunitX.Conexao.Tests;

interface

uses System.Classes
    ,System.SysUtils
    ,dmControle;

function InicializarConexaoTest(aModulo:string) : Boolean;
procedure FinalizarConexao ;

implementation

uses
     PRXIConexao,
     GlbComum,
     Prx.Utilitarios.Aplicacao.Service,
     Prx.Utilitarios.Aplicacao.Interfaces,
     Prx.Utilitarios.Criptografia,
     BgmConexao,
     Spring.container;

{ TConexaoTests }

function InicializarConexaoTest(aModulo:string): Boolean;
begin


  vcUsuario := ParamStr(1);

  if Assigned(dm) then
  begin
   writeln('Problema durante a conexão com o Banco de dados!');
   Result := False;
   Exit;
  end;

  dm := Tdm.Create(nil);

  if Not Assigned(vcAplicacao) then
    TAplicacao.Inicializar;

  vcSistema := aModulo;

  var vGlobusIni :=  Concat(ExtractFileDrive(ParamStr(0)),'\Globus\GLOBUS.INI');
  if Not ParamStr(2).IsEmpty then
    vGlobusIni := concat(ParamStr(2),'\GLOBUS.INI');

  vcAplicacao.GlobusIni(vGlobusIni);

  result := false;

  Result := BgmConexao.Conectar;

  if not Result then
  begin
   writeln('Não foi possivel realizar conexão com o Banco de dados!');
  end;

end;

procedure FinalizarConexao;
begin

 if Assigned(dm) then
   FreeAndNil(dm);

end;

end.
