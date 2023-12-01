unit Due.Funcoes.Utilitarios;

interface

uses
  System.Classes,
  Vcl.Forms,
  System.SysUtils;

procedure AbrirTela(aForm: TFormClass);

implementation

procedure AbrirTela(aForm: TFormClass);
var
  form: TForm;
begin

  form := aForm.Create(Application);
  try
    form.ShowModal;
  finally
    form.Free;
  end;
end;

end.
