unit Inserirtarefa.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
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
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Vcl.Mask,
  Vcl.Grids,
  XDBGrids,
  JvExMask,
  JvToolEdit,
  Praxio.Edit.CustomDateEdit,
  Praxio.Edit.DateEdit,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Contrato.Interfaces,
  TelaDeLogin.Interfaces;

type
  TInserirTarefa = class(TFormularioBase)
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    SpeedButton2: TSpeedButton;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GridContratos: TXDBGrid;
    Panel3: TPanel;
    Label1: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    TabSheet2: TTabSheet;
    LabelUsuario: TLabel;
    EdtNomeAnalista: TComboBox;
    EdtContrato: TComboBox;
    Label2: TLabel;
    EdtStatus: TComboBox;
    Label3: TLabel;
    ConsultaContratos: TFDMemTable;
    DataSource1: TDataSource;
    SpeedButton4: TSpeedButton;
    ConsultaContratosID_CONTRATO: TIntegerField;
    ConsultaContratosCPF: TStringField;
    ConsultaContratosSERVICO: TStringField;
    ConsultaContratosINICIO: TStringField;
    ConsultaContratosENTREGA: TStringField;
    ConsultaContratosVALOR: TFloatField;
    ConsultaContratosSTATUS: TStringField;
    ConsultaContratosUSUARIO_RESPONSAVEL: TStringField;
    ConsultaContratosUSUARIO: TStringField;
    EdtConsulta: TEdit;
    ConsultaContratosUSU: TStringField;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FContratosUseCase: IContratosUseCase;
    FContratosModel  : IContratosModel;
    FTelaDeLoginUseCase: ITelaDeLoginUseCase;
    FTelaDeLoginModel: ITelaDeLoginModel;
  public
    { Public declarations }
  end;

var
  InserirTarefa: TInserirTarefa;

implementation

{$R *.dfm}

procedure TInserirTarefa.FormCreate(Sender: TObject);
begin
  FContratosUseCase   := Resolve<IContratosUseCase>;
  FContratosModel     := Resolve<IContratosModel>;
  FTelaDeLoginUseCase := Resolve<ITelaDeLoginUseCase>;
  FTelaDeLoginModel   := Resolve<ITelaDeLoginModel>;
end;

procedure TInserirTarefa.FormShow(Sender: TObject);
begin
 SpeedButton6Click(sender);
end;

procedure TInserirTarefa.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  close;
end;

procedure TInserirTarefa.SpeedButton2Click(Sender: TObject);
begin
  FContratosModel.Status := EdtStatus.text;
  FContratosModel.Usuario_Responsavel := EdtNomeAnalista.ItemIndex+1;
  FContratosModel.ID_Contrato := strtoint(EdtContrato.text);
  FContratosModel.NovoRegistro := false;
  var resultado := FContratosUseCase.Gravar(FContratosModel);
  if resultado.Valido then
    showmessage(resultado.Mensagem)
  else
    showmessage(resultado.Mensagem);
   SpeedButton6Click(sender);
end;

procedure TInserirTarefa.SpeedButton5Click(Sender: TObject);
begin
  ConsultaContratos.open;
  ConsultaContratos.EmptyDataSet;

  if EdtConsulta.Text = '' then
    SpeedButton6Click(sender)
  else
  FContratosModel.ID_Contrato := strtoint(EdtConsulta.Text);

  ConsultaContratos.CopyDataSet(FContratosUseCase.BuscaContratos(FContratosModel));
  GridContratos.Gradient.Active := True;
end;

procedure TInserirTarefa.SpeedButton6Click(Sender: TObject);
begin
  ConsultaContratos.open;
  ConsultaContratos.EmptyDataSet;
  ConsultaContratos.CopyDataSet(FTelaDeLoginUseCase.RetornaUsuarios);
  GridContratos.Gradient.Active := True;
  EdtNomeAnalista.clear;
  ConsultaContratos.First;
  while not ConsultaContratos.Eof do
  begin
    EdtNomeAnalista.Items.Add(ConsultaContratos.FieldByName('USUARIO').AsString);
    ConsultaContratos.Next;
  end;


  ConsultaContratos.open;
  ConsultaContratos.EmptyDataSet;
  ConsultaContratos.CopyDataSet(FContratosUseCase.RetornaContratos);
  GridContratos.Gradient.Active := True;
  EdtContrato.clear;
  ConsultaContratos.First;
  while not ConsultaContratos.Eof do
  begin
    EdtContrato.Items.Add(ConsultaContratos.FieldByName('ID_CONTRATO').AsString);
    ConsultaContratos.Next;
  end;

end;

end.
