unit Cliente.View;

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
  Vcl.Grids,
  XDBGrids,
  Praxio.XGrid,
  Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Buttons;

type
  TClientesView = class(TFormularioBase)
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientesView: TClientesView;

implementation

{$R *.dfm}

procedure TClientesView.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  close;
end;

end.
