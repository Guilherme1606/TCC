unit Graficos.View;

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
  Vcl.Buttons,
  VclTee.TeeGDIPlus,
  Data.DB,
  VCLTee.TeEngine,
  VCLTee.Series,
  VCLTee.TeeProcs,
  VCLTee.Chart,
  VCLTee.DBChart,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  contrato.Interfaces;

type
  TGraficos = class(TFormularioBase)
    DBChart1: TDBChart;
    Series1: TPieSeries;
    ConsultaContrato: TFDMemTable;
    ConsultaContratoID_CONTRATO: TIntegerField;
    ConsultaContratoCPF: TStringField;
    ConsultaContratoSERVICO: TStringField;
    ConsultaContratoINICIO: TStringField;
    ConsultaContratoENTREGA: TStringField;
    ConsultaContratoVALOR: TFloatField;
    ConsultaContratoSTATUS: TStringField;
    ConsultaContratoUSUARIO_RESPONSAVEL: TStringField;
    ConsultaContratoUSUARIO: TStringField;
    ConsultaContratoUSU: TStringField;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FContratosUseCase   : IContratosUseCase;
  public
    { Public declarations }
  end;

var
  Graficos: TGraficos;

implementation

{$R *.dfm}

procedure TGraficos.FormShow(Sender: TObject);

begin
  FContratosUseCase   := Resolve<IContratosUseCase>;
  ConsultaContrato.open;
  ConsultaContrato.EmptyDataSet;
  ConsultaContrato.CopyDataSet(FContratosUseCase.RetornaContratos);


  Series1.Addpie(ConsultaContrato.Fields[0].AsInteger,'Total de Contratos',$00D75840);
  Series1.Addpie(ConsultaContrato.Fields[0].value,'Cliente',clgray);
  Series1.Addpie(strtofloat(ConsultaContrato.Fields[5].value),'Valor',CLGreen);
end;

procedure TGraficos.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  close;
end;

end.
