unit Contrato.Interfaces;

interface
uses
  Due.Utilitarios.Base.Types,
  system.generics.Collections,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  IContratosModel = interface
    ['{7CB1A6C5-A6A5-429D-B028-46B627CDB84C}']
    function GetID_Contrato: Integer;
    function GetCPF: String;
    function GetServico: String;
    function GetInicio: TDateTime;
    function GetEntrega: TDateTime;
    function GetValor: Currency;
    function GetStatus: String;
    function GetUsuario_Responsavel: Integer;
    function GetNovoRegistro: Boolean;

    procedure SetID_Contrato(Const Value:Integer);
    procedure SetCPF(const Value: String);
    procedure SetServico(const Value: String);
    procedure SetInicio(const Value: TDateTime);
    procedure SetEntrega(const Value: TDateTime);
    procedure SetValor(const Value: Currency);
    procedure SetStatus(const Value: String);
    procedure SetUsuario_Responsavel(const Value: Integer);
    procedure SetNovoRegistro(const Value: Boolean);

    property ID_Contrato: Integer read getID_Contrato write SetID_Contrato;
    property CPF: String read GetCPF write SetCPF;
    property Servico: String read GetServico write SetServico;
    property Inicio : TDateTime read GetInicio write SetInicio;
    property Entrega: TDateTime read GetEntrega write SetEntrega;
    property Valor: Currency read GetValor write SetValor;
    property Status: String read GetStatus write SetStatus;
    property Usuario_Responsavel: Integer read GetUsuario_Responsavel write SetUsuario_Responsavel;
    property NovoRegistro: Boolean read GetNovoRegistro write SetNovoRegistro;
  end;

  IContratosUseCase = interface
    ['{02224097-6016-43F6-BB68-4C44E6112DB8}']
    function Gravar(aModel: IContratosModel): TValidacao;
    function RetornaContratos: TFDDataSet;
    function BuscaContratos(aModel: IContratosModel): TFDDataSet;
  end;

  IContratosRepository = interface
    ['{05FAB3F7-647E-4F44-81F2-54A69830A9BD}']
    function Atualizar(aModel: IContratosModel): TValidacao;
    function Inserir(aModel: IContratosModel): TValidacao;
    function RetornaContratos: TFDDataSet;
    function BuscaContratos(aModel: IContratosModel): TFDDataSet;
  end;
implementation

end.
