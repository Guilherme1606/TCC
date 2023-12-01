unit FormularioBase.View;

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
  Vcl.Buttons,
  Spring.Container;

type
  TFormularioBase = class(TForm)
    PainelCentral: TPanel;
    PainelBaixo: TPanel;
  private
    { Private declarations }
  public
    function Resolve<T>: T;
  end;

var
  FormularioBase: TFormularioBase;

implementation

{$R *.dfm}

{ TFormularioBase }

function TFormularioBase.Resolve<T>: T;
begin
  Result := GlobalContainer.Resolve<T>;
end;

end.
