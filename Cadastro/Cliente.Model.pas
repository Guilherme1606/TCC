unit Cliente.Model;

interface

uses
  Cliente.Interfaces,
  Due.Utilitarios.Base.Model;

type
  TClientesModel = class(TBaseModel, IClientesModel)
  private
    FCPF: String;
    FNome_Completo: String;
    FEndereco: String;
    FNumero: Integer;
    FBairro: String;
    FCep: Integer;
    FMunicipio: String;
    FUF: String;
    FContato: String;
    FNovoRegistro: Boolean;

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
  public
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

implementation

{ TClientesModel }

function TClientesModel.GetBairro: String;
begin
  result := FBairro;
end;

function TClientesModel.GetCep: Integer;
begin
  result := FCep;
end;

function TClientesModel.GetContato: String;
begin
  result := FContato;
end;

function TClientesModel.GetCPF: String;
begin
  result := FCPF;
end;

function TClientesModel.GetEndereco: String;
begin
  result := FEndereco;
end;

function TClientesModel.GetMunicipio: String;
begin
  result := FMunicipio;
end;

function TClientesModel.GetNome_Completo: String;
begin
  result := FNome_Completo;
end;

function TClientesModel.GetNovoRegistro: Boolean;
begin
  result := FNovoRegistro;
end;

function TClientesModel.GetNumero: Integer;
begin
  result := FNumero;
end;

function TClientesModel.GetUF: String;
begin
  result := FUF;
end;

procedure TClientesModel.SetBairro(const Value: String);
begin
  FBairro := Value
end;

procedure TClientesModel.SetCep(const Value: Integer);
begin
  FCep := Value
end;

procedure TClientesModel.SetContato(const Value: String);
begin
  FContato := Value
end;

procedure TClientesModel.SetCPF(const Value: String);
begin
  FCPF := Value
end;

procedure TClientesModel.SetEndereco(const Value: String);
begin
  FEndereco := Value
end;

procedure TClientesModel.SetMunicipio(const Value: String);
begin
  FMunicipio := Value
end;

procedure TClientesModel.SetNome_Completo(const Value: String);
begin
  FNome_Completo := Value
end;

procedure TClientesModel.SetNovoRegistro(const Value: Boolean);
begin
  FNovoRegistro := Value
end;

procedure TClientesModel.SetNumero(const Value: Integer);
begin
  FNumero := Value
end;

procedure TClientesModel.SetUF(const Value: String);
begin
  FUF := Value
end;

end.
