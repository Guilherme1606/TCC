unit DueIConexao;

interface

uses
    FireDac.Comp.Client
  , FireDac.Stan.Option
  , FireDac.Stan.Intf
  , FireDac.Stan.Error
  , FireDAC.Moni.FlatFile
  , Due.Utilitarios.Base.Types;

type
  {$M+}
  IConexao = interface
    ['{24B1EAA9-A31D-42B3-BAA1-FEA749A1B69B}']
    procedure AtivarTrancing(var aFDMoniFlatFileClientLink : TFDMoniFlatFileClientLink);
    procedure DesativarTrancing(var aFDMoniFlatFileClientLink : TFDMoniFlatFileClientLink);
    function Conectar(var ADatabase: TFDConnection): Boolean; overload;
    function Conectar(var ADatabase: TFDConnection; pMsgCustomizada: string): Boolean; overload;
    function ReconectaBanco(AUsuario, ASenha: string): Boolean;
    procedure PopularParametroConexao(var ADatabase: TFDConnection);
    procedure PopulaPametroConexaoManual(var ADatabase: TFDConnection; pUsuario, pSenha, pServidor: string);
    function DatabaseName: string;
    function Database: TFDConnection;
    function InTransaction: Boolean;
    procedure StartTransaction; overload;
    procedure StartTransaction(var aValue :TEnumOrigemTransacao) ; overload;
    procedure Rollback(var aValue :TEnumOrigemTransacao); overload;
    procedure Commit(var aValue :TEnumOrigemTransacao); overload;
    procedure Rollback; overload;
    procedure Commit; overload;
  end;

var
  vcConexao: IConexao;

implementation

end.

