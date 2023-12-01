unit Contrato.Model;

interface
uses
  Contrato.Interfaces,
  Due.Utilitarios.Base.Model;

type
  TContratosModel = class(TBaseModel, IContratosModel)
  private
    FID_Contrato: Integer;
    FCPF: String;
    FServico: String;
    FInicio: TDateTime;
    FEntrega: TDateTime;
    FStatus: String;
    FUsuario_Responsavel: Integer;
    FValor: Currency;
    FNovoRegistro: Boolean;

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
  public
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
implementation

{ TContratosModel }

function TContratosModel.GetCPF: String;
begin
  result := FCPF;
end;

function TContratosModel.GetEntrega: TDateTime;
begin
  result := FEntrega;
end;

function TContratosModel.GetID_Contrato: Integer;
begin
  result := FID_Contrato;
end;

function TContratosModel.GetInicio: TDateTime;
begin
  result := FInicio;
end;

function TContratosModel.GetNovoRegistro: Boolean;
begin
  result := FNovoRegistro;
end;

function TContratosModel.GetServico: String;
begin
  result := FServico;
end;

function TContratosModel.GetStatus: String;
begin
  result := FStatus;
end;

function TContratosModel.GetUsuario_Responsavel: Integer;
begin
  result := FUsuario_Responsavel;
end;

function TContratosModel.GetValor: Currency;
begin
  result := FValor;
end;

procedure TContratosModel.SetCPF(const Value: String);
begin
  FCPF := Value;
end;

procedure TContratosModel.SetEntrega(const Value: TDateTime);
begin
  FEntrega := Value;
end;

procedure TContratosModel.SetID_Contrato(const Value: Integer);
begin
  FID_Contrato := Value;
end;

procedure TContratosModel.SetInicio(const Value: TDateTime);
begin
  FInicio := Value;
end;

procedure TContratosModel.SetNovoRegistro(const Value: Boolean);
begin
  FNovoRegistro := Value;
end;

procedure TContratosModel.SetServico(const Value: String);
begin
  FServico := Value;
end;

procedure TContratosModel.SetStatus(const Value: String);
begin
  FStatus := Value;
end;

procedure TContratosModel.SetUsuario_Responsavel(const Value: Integer);
begin
  FUsuario_Responsavel := Value;
end;

procedure TContratosModel.SetValor(const Value: Currency);
begin
  FValor := Value;
end;

end.
