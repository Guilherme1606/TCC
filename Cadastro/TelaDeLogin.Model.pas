unit TelaDeLogin.Model;

interface

uses
  TelaDeLogin.Interfaces,
  Due.Utilitarios.Base.Model;

type
  TTelaDeLoginModel = class(TBaseModel,
    ITelaDeLoginModel)
  private
    FID: integer;
    FUsuario: String;
    FNome_Completo: String;
    FEmail: String;
    FSenha: String;
    FStatus: String;
    FPermissao: String;
    FNovoRegistro: Boolean;

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
  public
    property ID: integer read GetID write SetID;
    property Usuario: String read GetUsuario write SetUsuario;
    property Nome_Completo: String read GetNome_Completo write SetNome_Completo;
    property Email: String read GetEmail write SetEmail;
    property Senha: String read GetSenha write SetSenha;
    property Status: String read GetStatus write SetStatus;
    property Permissao: String read GetPermissao write SetPermissao;
    property NovoRegistro: Boolean read GetNovoRegistro write SetNovoRegistro;

  end;

implementation

{ TMovimentacaoTelaDeLoginModel }

function TTelaDeLoginModel.GetEmail: String;
begin
  result := FEmail;
end;

function TTelaDeLoginModel.GetID: integer;
begin
  result := FID;
end;

function TTelaDeLoginModel.GetNome_Completo: String;
begin
  result := FNome_Completo;
end;

function TTelaDeLoginModel.GetNovoRegistro: Boolean;
begin
  result := FNovoRegistro;
end;

function TTelaDeLoginModel.GetPermissao: String;
begin
  result := FPermissao;
end;

function TTelaDeLoginModel.GetSenha: String;
begin
  result := FSenha;
end;

function TTelaDeLoginModel.GetStatus: String;
begin
  result := FStatus;
end;

function TTelaDeLoginModel.GetUsuario: String;
begin
  result := FUsuario;
end;

procedure TTelaDeLoginModel.SetEmail(const Value: String);
begin
  FEmail := Value;
end;

procedure TTelaDeLoginModel.SetID(const Value: integer);
begin
  FID := Value;
end;

procedure TTelaDeLoginModel.SetNome_Completo(const Value: String);
begin
  FNome_Completo := Value;
end;

procedure TTelaDeLoginModel.SetNovoRegistro(const Value: Boolean);
begin
  FNovoRegistro := Value;
end;

procedure TTelaDeLoginModel.SetPermissao(const Value: String);
begin
  FPermissao := Value;
end;

procedure TTelaDeLoginModel.SetSenha(const Value: String);
begin
  FSenha := Value;
end;

procedure TTelaDeLoginModel.SetStatus(const Value: String);
begin
  FStatus := Value;
end;

procedure TTelaDeLoginModel.SetUsuario(const Value: String);
begin
  FUsuario := Value;
end;

end.
