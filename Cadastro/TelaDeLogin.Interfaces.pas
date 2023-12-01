unit TelaDeLogin.Interfaces;

interface

uses
  Due.Utilitarios.Base.Types,
  system.generics.Collections,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  ITelaDeLoginModel = interface
    ['{348D5DCF-AB08-4F13-864F-8C8D36FC6390}']
    function GetID: integer;
    function GetUsuario: String;
    function GetNome_Completo: String;
    function GetEmail: String;
    function GetSenha: String;
    function GetStatus: String;
    function GetPermissao: String;
    function GetNovoRegistro: Boolean;

    procedure SetID(const Value: integer);
    procedure SetUsuario(const Value: String);
    procedure SetNome_Completo(const Value: String);
    procedure SetEmail(const Value: String);
    procedure SetSenha(const Value: String);
    procedure SetStatus(const Value: String);
    procedure SetPermissao(const Value: String);
    procedure SetNovoRegistro(const Value: Boolean);

    property ID: integer read GetID write SetID;
    property Usuario: String read GetUsuario write SetUsuario;
    property Nome_Completo: String read GetNome_Completo write SetNome_Completo;
    property Email: String read GetEmail write SetEmail;
    property Senha: String read GetSenha write SetSenha;
    property Status: String read GetStatus write SetStatus;
    property Permissao: String read GetPermissao write SetPermissao;
    property NovoRegistro: Boolean read GetNovoRegistro write SetNovoRegistro;
  end;

  ITelaDeLoginUseCase = interface
    ['{BB207074-CA6A-40D4-8A37-FB535949EDBB}']
    function Gravar(aModel: ITelaDeLoginModel): TValidacao;
    function Excluir(aModel: ITelaDeLoginModel): TValidacao;
    function ValidaUsuarioLogin(aModel: ITelaDeLoginModel):TValidacao;
    function RetornaUsuarios: TFDDataSet;
    function BuscaUsuarios(aModel: ITelaDeLoginModel): TFDDataSet;
  end;

  ITelaDeLoginRepository = interface
    ['{6D479101-2536-47DC-8A87-74360BAF3479}']
    function Atualizar(aModel: ITelaDeLoginModel): TValidacao;
    function Inserir(aModel: ITelaDeLoginModel): TValidacao;
    function Excluir(aModel: ITelaDeLoginModel): TValidacao;
    function ValidaUsuarioLogin(aModel: ITelaDeLoginModel):TValidacao;
    function RetornaUsuarios: TFDDataSet;
    function BuscaUsuarios(aModel: ITelaDeLoginModel): TFDDataSet;
  end;

implementation

end.
