unit Menu_Principal;

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
  Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,
  Vcl.Buttons;

type
  TTMenu_Principal = class(TForm)
    PainelTopo: TPanel;
    PainelEsquerdo: TPanel;
    PainelCadastro: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Panel5: TPanel;
    Image4: TImage;
    Panel6: TPanel;
    Image7: TImage;
    Image5: TImage;
    Shape1: TShape;
    procedure Panel1Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure PainelCadastroClick(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TMenu_Principal: TTMenu_Principal;

implementation
uses
  Inserirtarefa.View,
  Cliente.View,
  Due.Funcoes.Utilitarios,
  Relatorio.View,
  Graficos.View;
{$R *.dfm}

procedure TTMenu_Principal.Image2Click(Sender: TObject);
begin
  AbrirTela(TClientesView);
end;

procedure TTMenu_Principal.Image3Click(Sender: TObject);
begin
  AbrirTela(TRelatorios);
end;

procedure TTMenu_Principal.Image4Click(Sender: TObject);
begin
  AbrirTela(TInserirTarefa);
end;

procedure TTMenu_Principal.Image5Click(Sender: TObject);
begin
  AbrirTela(TGraficos)
end;

procedure TTMenu_Principal.PainelCadastroClick(Sender: TObject);
begin
  AbrirTela(TRelatorios);
end;

procedure TTMenu_Principal.Panel1Click(Sender: TObject);
begin
  AbrirTela(TInserirTarefa);
end;

procedure TTMenu_Principal.Panel2Click(Sender: TObject);
begin
  AbrirTela(TGraficos)
end;

procedure TTMenu_Principal.Panel4Click(Sender: TObject);
begin
  AbrirTela(TClientesView);
end;

procedure TTMenu_Principal.SpeedButton1Click(Sender: TObject);
begin
  close;
end;

end.
