unit Cliente.Interfaces;

interface
uses
  Due.Utilitarios.Base.Types,
  system.generics.Collections,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  IClientesModel = interface
    ['{45669E18-DD97-4602-B935-D493E5DBF9D4}']
    function GetCPF: String;
    function GetNome_Completo: String;
    function GetEndereco: String;
    function GetNumero: Integer;
    function GetBairro: String;
    function GetCep: Integer;
    function GetMunicipio: String;
    function GetUF: String;
    function GetContato: String;
    function GetNovoRegistro: Boolean;

    procedure SetCPF(const Value: String);
    procedure SetNome_Completo(const Value: String);
    procedure SetEndereco(const Value: String);
    procedure SetNumero(const Value: Integer);
    procedure SetBairro(const Value: String);
    procedure SetCep(Const Value: Integer);
    procedure SetMunicipio(const Value: String);
    procedure SetUF(const Value: String);
    procedure SetContato(const Value: String);
    procedure SetNovoRegistro(const Value: Boolean);

    property CPF: String read GetCPF write SetCPF;
    property Nome_Completo: String read GetNome_Completo write SetNome_Completo;
    property Endereco: String read GetEndereco write SetEndereco;
    property Numero: Integer read GetNumero write SetNumero;
    property Bairro: String read GetBairro write SetBairro;
    property Cep: Integer read GetCep write SetCep;
    property Municipio: String read GetMunicipio write SetMunicipio;
    property UF: String read GetUF write SetUF;
    property Contato: String read GetContato write SetContato;
    property NovoRegistro: Boolean read GetNovoRegistro write SetNovoRegistro;
  end;

  IClientesUseCase = interface
    ['{CF5E9BDE-E8FB-45C2-A19A-80DE7EE9B724}']
    function Gravar(aModel: IClientesModel): TValidacao;
    function Excluir(aModel: IClientesModel): TValidacao;
    function RetornaClientes: TFDDataSet;
    function BuscaClientes(aModel: IClientesModel): TFDDataSet;
  end;

  IClientesRepository = interface
    ['{76B7FCA6-8555-4BC1-B81C-016D38A3B049}']
    function Atualizar(aModel: IClientesModel): TValidacao;
    function Inserir(aModel: IClientesModel): TValidacao;
    function Excluir(aModel: IClientesModel): TValidacao;
    function RetornaClientes: TFDDataSet;
    function BuscaClientes(aModel: IClientesModel): TFDDataSet;
  end;
implementation

end.
