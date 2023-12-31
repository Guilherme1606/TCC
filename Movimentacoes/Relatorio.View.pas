unit Relatorio.View;

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
  Vcl.StdCtrls,
  Vcl.Buttons,
  RDprint,
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
  Due.Utilitarios.Incremento,
  Contrato.Interfaces;

type
  TRelatorios = class(TFormularioBase)
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Painel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    SpeedButton2: TSpeedButton;
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
    RDprint1: TRDprint;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FContratosUseCase   :IContratosUseCase;
  public
    procedure ImpressaRelatorioContrato;
  end;

var
  Relatorios: TRelatorios;

implementation

{$R *.dfm}

procedure TRelatorios.FormCreate(Sender: TObject);
begin
  inherited;
  FContratosUseCase   := Resolve<IContratosUseCase>;
  ConsultaContrato.open;
  ConsultaContrato.EmptyDataSet;
  ConsultaContrato.CopyDataSet(FContratosUseCase.RetornaContratos);
end;

procedure TRelatorios.ImpressaRelatorioContrato;
var
  vTotalReg, iRecNO, vLinha : integer;
 procedure Cabecalho;
 Begin
   vLinha := 0;

   with RdPrint1 do
   Begin
     Imp (IncInt(vLinha),001,'Relatório de contrato ');
     Imp (IncInt(vLinha),001,'ID CONTRATO      CPF              SERVICO                  INICIO                 ENTREGA               VALOR                STATUS');
     Imp (IncInt(vLinha),001,'-------------------------------------------------------------------------------------------------------------------------------------');
   End;
 End;

 procedure Detalhe;
  Begin
    If Not ConsultaContrato.Active Then
      ConsultaContrato.Active := True;

    with RdPrint1,ConsultaContrato do
    Begin
      Imp (IncInt(vLinha),001,inttostr(ConsultaContrato.FieldByName('ID_CONTRATO').AsInteger));
      Imp (       vLinha ,018,ConsultaContrato.FieldByName('CPF').AsString);
      Imp (       vLinha ,035,ConsultaContrato.FieldByName('SERVICO').AsString);
      Imp (       vLinha ,060,ConsultaContrato.FieldByName('INICIO').AsString);
      Imp (       vLinha ,083,ConsultaContrato.FieldByName('ENTREGA').AsString);
      Imp (       vLinha ,105,inttostr(ConsultaContrato.FieldByName('VALOR').AsInteger));
      Imp (       vLinha ,125,ConsultaContrato.FieldByName('STATUS').AsString);
    End;
  End;
begin


  If Not ConsultaContrato.Active Then
    ConsultaContrato.Active := True;

  with RDprint1,ConsultaContrato do
  Begin
    OpcoesPreview.Preview             := True;
    RDPrint1.TamanhoQteColunas        := 170;
    RDPrint1.TamanhoQteLinhas         := 66;
    RdPrint1.TamanhoQteLPP            := Seis;
    RDPrint1.FonteTamanhoPadrao       := S20cpp;
    iRecNO             := 0;
    vTotalReg := ConsultaContrato.RecordCount;
      Abrir;
      ConsultaContrato.First;
      Cabecalho;
      While Not ConsultaContrato.Eof do
      Begin
        Inc(iRecNO);
        If vLinha+1>RDPrint1.TamanhoQteLinhas-3 Then
        Begin
          NovaPagina;
          Cabecalho;
        End;
        Detalhe;
        ConsultaContrato.Next;
        If ConsultaContrato.Eof Then
        Begin
          If vLinha+1>RDPrint1.TamanhoQteLinhas-3 Then
          Begin
            NovaPagina;
            Cabecalho;
          End;
        End;
      Fechar;
    End;
  End;
end;

procedure TRelatorios.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  close;
end;


procedure TRelatorios.SpeedButton5Click(Sender: TObject);
begin
  try
   ImpressaRelatorioContrato;
  except

  end;
end;

end.
