unit Cliente.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.StrUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  FormularioBase.View,
  Vcl.ExtCtrls,
  JvExControls,
  JvXPCore,
  JvXPButtons,
  Praxio.Botoes.SimpleButton,
  Vcl.Grids,
  XDBGrids,
  Praxio.XGrid,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Buttons,
  Vcl.Mask,
  JvExMask,
  JvToolEdit,
  Praxio.Edit.CustomDateEdit,
  Praxio.Edit.DateEdit,
  Cliente.Interfaces,
  Contrato.Interfaces,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Praxio.Edit.Edit, Praxio.Edit.NumEdit;

type
  TClientesView = class(TFormularioBase)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel1: TPanel;
    EdtNomeCliente: TEdit;
    EdtEndereco: TEdit;
    EdtNumero: TEdit;
    EdtBairro: TEdit;
    EdtCEP: TMaskEdit;
    LabelUsuario: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EdtUF: TEdit;
    Label7: TLabel;
    EdtMunicipio: TEdit;
    Label8: TLabel;
    EdtContato: TMaskEdit;
    Label10: TLabel;
    EdtInicio: TDateEdit;
    Label12: TLabel;
    EdtValor: TNumEdit;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    GridClientes: TXDBGrid;
    EdtEntrega: TDateEdit;
    Panel2: TPanel;
    EdtCPFConsulta: TMaskEdit;
    Label11: TLabel;
    SpeedButton2: TSpeedButton;
    BotaoRecarregar: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    EdtCPFContrato: TComboBox;
    EdtCPFCadastro: TMaskEdit;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    TipodeServico: TListView;
    DataSource1: TDataSource;
    ConsultaClientes: TFDMemTable;
    ConsultaClientesCPF: TStringField;
    ConsultaClientesNOME_COMPLETO: TStringField;
    ConsultaClientesENDERECO: TStringField;
    ConsultaClientesNUMERO: TIntegerField;
    ConsultaClientesBAIRRO: TStringField;
    ConsultaClientesCEP: TIntegerField;
    ConsultaClientesMUNICIPIO: TStringField;
    ConsultaClientesUF: TStringField;
    ConsultaClientesCONTATO: TStringField;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure BotaoRecarregarClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    //function ValidaCPF(Numero: String; pMostrarMensagem: Boolean = true): Boolean;
    FClientesUseCase : IClientesUseCase;
    FClientesModel   : IClientesModel;
    FContratosUseCase: IContratosUseCase;
    FContratosModel  : IContratosModel;
    procedure consultacpf(aCPF:String);
  public

  end;

var
  ClientesView: TClientesView;

implementation

{$R *.dfm}

procedure TClientesView.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    ComboBox1.Visible := false;
    FClientesModel.NovoRegistro := true;
  end
  else
  begin
    ComboBox1.Visible := true;
    FClientesModel.NovoRegistro := false;
  end;
end;

procedure TClientesView.consultacpf(aCPF:String);
begin
  ConsultaClientes.open;
  ConsultaClientes.EmptyDataSet;
  var LimpaCPF     :=  StringReplace(aCPF, '.', '', [rfReplaceAll]);
  FClientesModel.CPF := StringReplace(LimpaCPF, '-', '', [rfReplaceAll]);
  ConsultaClientes.CopyDataSet(FClientesUseCase.BuscaClientes(FClientesModel));
  GridClientes.Gradient.Active := True;
end;

procedure TClientesView.FormCreate(Sender: TObject);
begin
  FClientesUseCase:= Resolve<IClientesUseCase>;
  FClientesModel  := Resolve<IClientesModel>;
  FContratosUseCase:= Resolve<IContratosUseCase>;
  FContratosModel  := Resolve<IContratosModel>;
end;

procedure TClientesView.FormShow(Sender: TObject);
begin
  BotaoRecarregarClick(sender);
end;

procedure TClientesView.SpeedButton1Click(Sender: TObject);
begin
  close;
end;

procedure TClientesView.SpeedButton2Click(Sender: TObject);
begin
  consultacpf(EdtCPFConsulta.Text);
end;

procedure TClientesView.BotaoRecarregarClick(Sender: TObject);
begin
  ConsultaClientes.open;
  ConsultaClientes.EmptyDataSet;
  ConsultaClientes.CopyDataSet(FClientesUseCase.RetornaClientes);
  GridClientes.Gradient.Active := True;

  ConsultaClientes.First;
  while not ConsultaClientes.Eof do
  begin
    EdtCPFContrato.Items.Add(ConsultaClientes.FieldByName('CPF').AsString);
    ComboBox1.Items.Add(ConsultaClientes.FieldByName('CPF').AsString);
    ConsultaClientes.Next;
  end;
end;

procedure TClientesView.SpeedButton4Click(Sender: TObject);
begin
  var LimpaCPF     :=  StringReplace(inputbox('Ol� usu�rio ','Digite o CPF que deseja excluir sem pontua��o','' ), '.', '', [rfReplaceAll]);
  FClientesModel.CPF := StringReplace(LimpaCPF, '-', '', [rfReplaceAll]);

  ConsultaClientes.First;
  while not ConsultaClientes.Eof do
  begin
    if ConsultaClientes.FieldByName('CPF').AsString = FClientesModel.CPF then
    begin
      var resultado := FClientesUseCase.Excluir(FClientesModel);

      if resultado.Valido then
        showmessage(resultado.Mensagem)
      else
        showmessage(resultado.Mensagem);
       BotaoRecarregarClick(sender);
       exit;
    end;

    ConsultaClientes.next;
  end;
  showmessage('CPF n�o encontrado');

end;

procedure TClientesView.SpeedButton6Click(Sender: TObject);
begin
  var LimpaCPF     :=  StringReplace(EdtCPFCadastro.text, '.', '', [rfReplaceAll]);
  LimpaCPF         :=    StringReplace(LimpaCPF, '-', '', [rfReplaceAll]);
  FClientesModel.CPF           := Ifthen(FClientesModel.NovoRegistro,LimpaCPF,ComboBox1.text );
  FClientesModel.Nome_Completo := EdtNomeCliente.text;
  FClientesModel.Endereco      := EdtEndereco.text;
  FClientesModel.Numero        := strtoint(EdtNumero.text);
  FClientesModel.Bairro        := EdtBairro.text;
  FClientesModel.Cep           := strtoint(StringReplace(EdtCEP.text, '-', '', [rfReplaceAll]));
  FClientesModel.Municipio     := EdtMunicipio.text;
  FClientesModel.UF            := EdtUF.text;
  FClientesModel.Contato       := StringReplace(EdtContato.text, '-', '', [rfReplaceAll]);;
  var resultado := FClientesUseCase.Gravar(FClientesModel);
  if resultado.Valido then
    showmessage(resultado.Mensagem)
  else
    showmessage(resultado.Mensagem);

  EdtCPFCadastro.clear;
  EdtNomeCliente.clear;
  EdtEndereco.clear;
  EdtNumero.clear;
  EdtBairro.clear;
  EdtCEP.clear;
  EdtMunicipio.clear;
  EdtUF.clear;
  EdtContato.clear;
  BotaoRecarregarClick(sender);
  CheckBox1.SetFocus;
end;

procedure TClientesView.SpeedButton7Click(Sender: TObject);
begin
  //rotina de inclus�o de contrato

  FContratosModel.CPF     := EdtCPFContrato.text;
  FContratosModel.Servico :='';
  For var i := 0 to pred(TipodeServico.Items.Count) do
  begin
    if TipodeServico.Items.Item[i].Checked then
    FContratosModel.Servico := FContratosModel.Servico + TipodeServico.Items.Item[i].Caption+ ' ' ;
  end;
  FContratosModel.NovoRegistro := true;
  FContratosModel.Inicio  :=  EdtInicio.Date;
  FContratosModel.Entrega :=  EdtEntrega.Date;
  FContratosModel.Valor   :=  EdtValor.Value;
  var resultado := FContratosUseCase.Gravar(FContratosModel);
  if resultado.Valido then
    showmessage(resultado.Mensagem)
  else
    showmessage(resultado.Mensagem);

  EdtCPFContrato.clear;
  EdtInicio.clear;
  EdtEntrega.clear;
  EdtValor.clear;
  BotaoRecarregarClick(sender);
end;

end.
