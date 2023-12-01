﻿unit Due.Componente.Base.Form.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  PngSpeedButton, Vcl.Menus, Vcl.ExtCtrls, Vcl.Buttons,
  Data.Db, FireDAC.Comp.Client, Prx.Componente.Base.Form.Image.View,
  Vcl.StdCtrls, vcl.Mask,JvSpin, Vcl.CheckLst, JvBaseEdits, Vcl.ComCtrls,
  Prx.Utilitarios.TransportarDadosEntreForm.Interfaces,
  EventBus, Praxio.GrupoEmpresa.Interfaces
  , System.Generics.Collections
  , Prx.Utilitarios.RetornarDadosCallBack.Interfaces
  , Prx.Utilitarios.RetornarDadosCallBack.Types;

type
  TPraxioBaseFormView = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    ///Retrofit!
    /// M�todos abaixo s�o necess�rios por conta do componente.
    /// ao  ser criado os m�todos, s�o criados com estes nomes.

  private
    FDireitoDeAlteracao : Boolean;
    FDireitoDeInclusao : Boolean;
    FDireitoDeExclusao : Boolean;
    procedure CarregarDireitosDoUsuario(aCaption:string);
    procedure ExecutarPosicionamentoDeBotoes;

  public
    FParamEvent : ITransportarDadosEntreFormModel;
    FRetornarDadosDoForm : TRetornarDadosDoForm;
    FCaptionRecarregarDireitosUsuario : String;
    function DireitoDeInclusao: Boolean;
    function DireitoDeAlteracao: Boolean;
    function DireitoDeExclusao: Boolean;
    function MensagemDeConfirmacao(aMsg: string; aBotoes: string = 'SimNao') : Boolean; overload;
    function MensagemDeConfirmacao(aMsg: string; aDefaultSimNao: Boolean) : Boolean; overload;
    procedure MensagemDeErro(aMsg: string); overload;
    procedure MensagemDeErro(aMsg: string; aTag: string); overload;
    procedure MensagemDeInformacao(aMsg: string); overload;
    procedure MensagemDeInformacao(aMsg: string; aTag: string); overload;
    procedure MensagemDeAtencao(aMsg: string); overload;
    procedure MensagemDeAtencao(aMsg: string; aTag: string); overload;
    function MensagemDlg(aMensagem, aTipoDeDialogo, aBotoes: string; aDefaultSimNao: Boolean = True; aFontMensagem: string = 'Times New Roman'; aTempo: Integer = 0): string; overload;
    function MensagemDlg(aMensagem: string; aTipoDeDialogo: string; aBotoes: string; aLink, aDescricaoLink: WideString; aDefaultSimNao: Boolean; aFontMensagem: string; aTempo: Integer): string; overload;

    function Resolve<T>: T;
    function RetornarDadosEntreForms : IRetornarDadosEntreForms;

  end;

implementation

uses
  Prx.Utilitarios.MensagemDlg.Interfaces
 ,Prx.Utilitarios.Log.Interfaces
 ,PRXIMenuInterativo
 ,PRXIBaseDeConhecimentoPorTela
 ,PRXILocalizadorDeMenus
 ,PRXILGPDConfiguracao
 ,PRXIGerenciadorLGPD
 ,PRXIEncerramentoRelatorio
 ,PRXIRdPrintAuxiliar
 ,GlbComum
 ,PRXString
 ,Prx.Utilitarios.MainMenu
 ,Prx.Utilitarios.FormEstiloVisual.Helper
 ,Praxio.Edit.NumEdit
 ,Praxio.Edit.DateEdit
 ,Praxio.Edit.TimeEdit
 ,Praxio.Inscricao
 ,Spring.Container
 ,Prx.Utilitarios.PedeEmpresa
 ,Prx.Componente.FormShowGenerico.Interfaces
 ,Prx.Utilitarios.Botoes
 ,Prx.Utilitarios.ValidacaoCursores.Interfaces
 ,Prx.Utilitarios.Aplicacao.Tools.Interfaces
 ,Prx.Utilitarios.DireitoUsuario.Interfaces;

{$R *.dfm}
{ TPraxioBaseFormView }



function TPraxioBaseFormView.RetornarDadosEntreForms: IRetornarDadosEntreForms;
begin
  Result := vcRetornarDadosEntreForms;
end;

function TPraxioBaseFormView.RetornarDadosEventBus: ITransportarDadosEntreFormModel;
begin
  Result :=  vcTransportarDadosEntreFormModel;
end;


procedure TPraxioBaseFormView.CarregarDireitosDoUsuario(aCaption: string);
begin
  vcDireitoUsuarioModel := Resolve<IDireitoUsuarioModel>;
  vcDireitoUsuarioUseCase := Resolve<IDireitoUsuarioUseCase>;

  vcDireitoUsuarioModel.Usuario := vcUsuario;
  vcDireitoUsuarioModel.sistema := vcSistema;
  vcDireitoUsuarioModel.NomeCaption := aCaption;

  vcDireitoUsuarioModel := vcDireitoUsuarioUseCase.RetonarDireitoUsuario(vcDireitoUsuarioModel);


  FDireitoDeExclusao  := vcDireitoUsuarioUseCase.RetornarDireitoExclusao;
  FDireitoDeAlteracao := vcDireitoUsuarioUseCase.RetornarDireitoAlterar;
  FDireitoDeInclusao  := vcDireitoUsuarioUseCase.RetornarDireitoIncluir;
end;

function TPraxioBaseFormView.ConfirmarExclusao: Boolean;
begin
  result := MensagemDeConfirmacao('Deseja realmente excluir o registro ?');
end;

procedure TPraxioBaseFormView.EventPost(const AEvent: IInterface;
  const AContext: string = '');
begin
  GlobalEventBus.Post(AEvent);
end;

function TPraxioBaseFormView.DireitoDeAlteracao: Boolean;
begin
  Result := FDireitoDeAlteracao;
end;

function TPraxioBaseFormView.DireitoDeExclusao: Boolean;
begin
  Result := FDireitoDeExclusao;
end;

function TPraxioBaseFormView.DireitoDeInclusao: Boolean;
begin
  Result := FDireitoDeInclusao;
end;

procedure TPraxioBaseFormView.FormClose(Sender: TObject; var Action: TCloseAction);
 procedure FecharDataSet;
  var
    vComponent: TComponent;
  begin

    for var vIndex := 0 to Self.ComponentCount - 1 do
    begin

      vComponent := Self.Components[vIndex];

      if vComponent is TDataSet then
        TDataSet(vComponent).Close;

      if vComponent is TFDQuery then
        TFDQuery(vComponent).Close;

    end;

  end;

begin

  if Assigned(FRetornarDadosDoForm) then
    FRetornarDadosDoForm(vcRetornarDadosEntreForms);

  if LocalizadorAtivo then
    vcLocalizadorDeMenus.FecharTela;

  if (FFecharDataSetAutomatico or vcAplicacaoToolsService.VerificarDataSets) then
    FecharDataSet;

  vcEncerramentoARR.RemoverObjetoEventoDeEncerramentoARR(Self);

  if assigned(vcMenuInterativo) then
  begin
    vcMenuInterativo.ExibirVisualizacao;
    vcMenuInterativo.ExisteFormAberto(false);
  end;

  if FCaptionRecarregarDireitosUsuario <> EmptyStr then
   CarregarDireitosDoUsuario(FCaptionRecarregarDireitosUsuario);
end;

procedure TPraxioBaseFormView.FormCreate(Sender: TObject);
begin
  {TODO -oRetrofit -cAcoplamento : Falta resolver depend�ncia de Praxio.Acesso}
  inherited;
  FEfetuarVerificacaoDataSet := False;
  FFecharDataSetAutomatico := False;
  FSeNaoExistirAtribuirMenuSaida := True;
  Self.Scaled := False;
  FCaptionRecarregarDireitosUsuario := EmptyStr;

  FAtivarLocalizadorTela := True;
  if Self.WindowState <> TWindowState.wsMaximized then
    Self.Position := poMainFormCenter;

end;
procedure TPraxioBaseFormView.FormDestroy(Sender: TObject);
begin
  inherited;

  if (FEfetuarVerificacaoDataSet ) and (Assigned(vcValidacaoCursoresService))then
    vcValidacaoCursoresService.ValidacaoFinal(Self);

    if Assigned(vcAplicacaoToolsService) then
    begin
      if vcAplicacaoToolsService.VerificarDataSets then
       vcValidacaoCursoresService.ValidacaoFinal(Self);
    end;
end;

procedure TPraxioBaseFormView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  FPressionouSetaParaBaixo := Key = Vk_Down;

  {Ctrl + Shift + P}
  {TODO -oRetrofit -cNecess�o deixar aqui porem precisa incluir o inherited nos forms  : FormKeyDow}
//Hoje esta na BgmAtivaCalculadora.
//  if ((ssCtrl in Shift) and (ssShift in Shift) and (Key = 80)) then
//    vcAplicacaoToolsService.PrintScreenTelaAtiva;

end;

procedure TPraxioBaseFormView.FormKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  vAbandonaExit := False;
  vEsc := False;
  if Key = #13 then
  begin
    Key := #0;
    self.Perform(WM_NextDlgCtl, 0, 0);
  end;
  if vPassaFoco and (Key = #27) then
  begin
    Key := #0;
    vEsc := True;
    self.Perform(WM_NextDlgCtl, 1, 0);
  end;
end;

procedure TPraxioBaseFormView.FormShow(Sender: TObject);
begin
  inherited;
  if Assigned(vcFormShowGenericoService) then
    vcFormShowGenericoService.FormShowGenerico(Self);

  AdicionarMenuItemSaida;

  CarregarDireitosDoUsuario(self.Caption);

  if Assigned(vcLGPD) and (not FLGPDTelaDocada) then
  begin
    vcLGPD.AplicarLGPD(Self, MenuLGPD, RetornaLGPDCompartilhaPermissoes, RetornaLGPDFormulariosExternos);
  end;

  if LocalizadorAtivo then
    vcLocalizadorDeMenus.AdicionarMenuItem(TForm(Self));

  if Assigned(vcBaseDeConhecimentoPorTela) then
    vcBaseDeConhecimentoPorTela.AdicionarMenuItemBaseConhecimento(TForm(Self));

  if (FEfetuarVerificacaoDataSet ) and (Assigned(vcValidacaoCursoresService))
     or (vcAplicacaoToolsService.VerificarDataSets)  and (Assigned(vcValidacaoCursoresService))then
    vcValidacaoCursoresService.ValidacaoInicial(Self);

  if Assigned(vcEncerramentoARR) then
    vcEncerramentoARR.AssociarObjetoAoEventoDeEncerramentoARR(Self);

   PopularComponenteListaEmpresa;

  if assigned(vcMenuInterativo) then
  begin
    vcMenuInterativo.OcultarVisualizacao;
    vcMenuInterativo.ExisteFormAberto(true);
  end;

  TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      vcRdPrintAuxiliar.RdPrintConfiguracoesIni(Self,Self.Caption);
    end);

  AplicarEsitloVisual;
  ExecutarPosicionamentoDeBotoes;

  FRetornarDadosDoForm := nil;
  AtualizarCallBackModel := PopuparDadosCallBackForm;



end;

function TPraxioBaseFormView.GetIdTela: string;
begin

  if (Self.FId.IsEmpty) and (csDesigning in ComponentState) then
  begin
    FId := TGuid.NewGuid.ToString;
    FId := Copy(Self.IdTela, 2, (Length(Self.IdTela) - 2));
  end;

  result := FId;

end;

function TPraxioBaseFormView.GravarLog(aUsuario, aDescricao: string): Boolean;
begin
  result := vcLog.GravarLog(aUsuario, aDescricao);
end;

function TPraxioBaseFormView.GravarLog(aDescricao: string): Boolean;
begin
  result := vcLog.GravarLog(aDescricao);
end;

procedure TPraxioBaseFormView.LimparComponentes;
begin
  for var vIndex := 0 to Self.ComponentCount - 1 do
    TratarComponentes(Components[vIndex]);
end;

procedure TPraxioBaseFormView.TratarComponentes(
  aComponent: TComponent);
var
  vSubIndex: Integer;
  vPedeEmpresa :IPedeEmpresa;
  vPedeFilialGaragem : IPedeFilialGaragem;
  vPedeGaragem : IPedeGaragem;
begin

  vAbandonaExit := True;
  vPassaFoco := False;

  if Supports(aComponent,
              IPedeEmpresa,
              vPedeEmpresa) then
  begin
    vPedeEmpresa.LimpaEmpresa;
    exit;
  end;

  if Supports(aComponent,
              IPedeFilialGaragem,
              vPedeFilialGaragem) then
  begin
    vPedeFilialGaragem.LimpaFilial;
    exit;
  end;

  if Supports(aComponent,
              IPedeGaragem,
              vPedeGaragem) then
  begin
    vPedeGaragem.LimparGaragem;
    exit;
  end;

  if aComponent is TEdit then
    TEdit(aComponent).Clear
  else
  if (aComponent is TNumEdit) then
    TNumEdit(aComponent).Clear
  else
  if (aComponent is TDateEdit) then
    TDateEdit(aComponent).Clear
  else
  if (aComponent is TMaskEdit) then
    TMaskEdit(aComponent).Clear
  else
  if (aComponent is TTimeEdit) then
    TTimeEdit(aComponent).Clear
  else
  if (aComponent is TComboBox) then
    TComboBox(aComponent).ItemIndex := -1
  else
  if (aComponent is TJvSpinEdit) then
    TJvSpinEdit(aComponent).Value := 0
  else
  if (aComponent is TCheckListBox) then
    for vSubIndex := 0 to TCheckListBox(aComponent).Items.Count - 1 do
      TCheckListBox(Components[vSubIndex]).Checked[vSubIndex] := False
  else
  if (aComponent is TCheckBox) then
    TCheckBox(aComponent).Checked := False
  else
  if (aComponent is TJvCalcEdit) then
    TJvCalcEdit(aComponent).Value := 0
  else
  if (aComponent is TListBox) then
    TListBox(aComponent).Clear
  else
  if (aComponent is TPraxioInscricao) then
    TPraxioInscricao(aComponent).Clear
  else
  if (aComponent is TTreeView) then
    TTreeView(aComponent).Items.Clear
  else
  if (aComponent is TMemo) then
    TMemo(aComponent).Clear
  else if (aComponent is TCustomMaskEdit) then
    TCustomMaskEdit(aComponent).Clear;

  vAbandonaExit := False;
  vPassaFoco := True;

end;

function TPraxioBaseFormView.LocalizadorAtivo: Boolean;
begin
  result := ( FAtivarLocalizadorTela ) And
            Assigned(vcLocalizadorDeMenus) and (vcSistema<>'GRP');
end;

procedure TPraxioBaseFormView.MensagemDeAtencao(aMsg: string);
begin
  vcMensagem.MensagemDeAtencao(aMsg);
end;

procedure TPraxioBaseFormView.MensagemDeAtencao(aMsg, aTag: string);
begin
  vcMensagem.MensagemDeAtencao(aMsg,aTag);
end;

function TPraxioBaseFormView.MensagemDeConfirmacao(aMsg: string;
  aDefaultSimNao: Boolean): Boolean;
begin
  result := vcMensagem.MensagemDeConfirmacao(aMsg, aDefaultSimNao);
end;

function TPraxioBaseFormView.MensagemDeConfirmacao(aMsg,
  aBotoes: string): Boolean;
begin
  result := vcMensagem.MensagemDeConfirmacao(aMsg, aBotoes);
end;

procedure TPraxioBaseFormView.MensagemDeErro(aMsg, aTag: string);
begin
  vcMensagem.MensagemDeErro(aMsg,aTag);
end;

procedure TPraxioBaseFormView.MensagemDeErro(aMsg: string);
begin
  vcMensagem.MensagemDeErro(aMsg);
end;

procedure TPraxioBaseFormView.MensagemDeInformacao(aMsg, aTag: string);
begin
  vcMensagem.MensagemDeInformacao(aMsg,aTag);
end;

function TPraxioBaseFormView.MensagemDlg(aMensagem, aTipoDeDialogo,
  aBotoes: string; aLink, aDescricaoLink: WideString; aDefaultSimNao: Boolean;
  aFontMensagem: string; aTempo: Integer): string;
begin
 result := vcMensagem.MensagemDlg(aMensagem,aTipoDeDialogo,aBotoes,aLink,aDescricaoLink,
   aDefaultSimNao
  ,aFontMensagem,aTempo);
end;

function TPraxioBaseFormView.MensagemDlg(aMensagem, aTipoDeDialogo,
  aBotoes: string; aDefaultSimNao: Boolean; aFontMensagem: string;
  aTempo: Integer): string;
begin
  Result := vcMensagem.MensagemDlg(aMensagem,aTipoDeDialogo,aBotoes,aDefaultSimNao,aFontMensagem,aTempo);
end;

procedure TPraxioBaseFormView.MenuLGPD(Sender: TObject);
begin
  if Assigned(vcGerenciadorLGPD) then
  begin
    vcGerenciadorLGPD.Abrir(Self, RetornaLGPDCompartilhaPermissoes, RetornaLGPDFormulariosExternos);
  end;
end;

procedure TPraxioBaseFormView.MnFrmBaseSaidaClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TPraxioBaseFormView.MensagemDeInformacao(aMsg: string);
begin
  vcMensagem.MensagemDeInformacao(aMsg);
end;

procedure TPraxioBaseFormView.OperacaoRealizadaComErro(aMensagem: string);
begin

  if MensagemDeConfirmacao('Problemas durante a operação, Deseja ver o erro ?')then
    MensagemDeErro(aMensagem);

end;

procedure TPraxioBaseFormView.OperacaoRealizadaComSucesso;
begin
  MensagemDeInformacao('Operação realizada com sucesso.');
end;

procedure TPraxioBaseFormView.PopularComponenteListaEmpresa;
var
  vListaEmpresa : IListaEmpresa;
  vListaFilial : IListaFilial;
begin

  for var vIndex := 0 to Self.ComponentCount - 1 do
  begin

    if Supports(Components[vIndex],
                IListaEmpresa,
                vListaEmpresa) then
    begin
      vListaEmpresa.Sistema := vcSistema;
      vListaEmpresa.Usuario := vcUsuario;
      vListaEmpresa.ConnectionName := vcDatabase.Name;
    end;

    if Supports(Components[vIndex],
                IListaFilial,
                vListaFilial) then
      vListaFilial.ConnectionName := vcDatabase.Name;
  end;

end;

procedure TPraxioBaseFormView.PopularPedeEmpresa(aComponente: IPedeEmpresa);
begin
  Prx.Utilitarios.PedeEmpresa.PopularPedeEmpresa(aComponente);
end;

procedure TPraxioBaseFormView.PopularPedeFilialAssociada(
  aEmpresa: IPedeEmpresa; aFilial: IPedeFilialGaragem);
begin
  Prx.Utilitarios.PedeEmpresa.PopularPedeFilialAssociada(aEmpresa,aFilial);
end;

procedure TPraxioBaseFormView.PopularPedeFilialAssociada(
   aEmpresa: IPedeEmpresa; aFilial: IPedeFilialGaragem;
  aCodigoFilial: Integer);
begin
  Prx.Utilitarios.PedeEmpresa.PopularPedeFilialAssociada(aEmpresa,aFilial,aCodigoFilial);
end;

procedure TPraxioBaseFormView.PopularPedeGaragem(
   aFilial: IPedeFilialGaragem; aGaragem: IPedeGaragem);
begin
  Prx.Utilitarios.PedeEmpresa.PopularPedeGaragem(aFilial, aGaragem );
end;

procedure TPraxioBaseFormView.PopuparDadosCallBackForm(aModel: IRetornarDadosEntreForms);
begin
  vcRetornarDadosEntreForms := Resolve<IRetornarDadosEntreForms>;
  vcRetornarDadosEntreForms := aModel;
end;


procedure TPraxioBaseFormView.PosicionarBotoes(
  aPanel: TPanel;
  aMudaTamanhoDoPainel,
  aMudaTamanhoDosBotoes: Boolean);
begin
  Prx.Utilitarios.Botoes
    .PosicionarBotoes(
       aPanel,
       aMudaTamanhoDoPainel,
       aMudaTamanhoDosBotoes);
end;

procedure TPraxioBaseFormView.ExecutarPosicionamentoDeBotoes;
begin

  var pnl := Self.FindComponent('PnlBotoes');

  if not Assigned(pnl) then exit;

  PosicionarBotoes(TPanel(pnl), False, False);

end;

procedure TPraxioBaseFormView.PraxioBaseFormViewClose(Sender: TObject; var Action: TCloseAction);
begin
 self.FormClose(Sender, Action);
end;

procedure TPraxioBaseFormView.PraxioBaseFormViewCreate(Sender: TObject);
begin
  self.FormCreate(Sender);
end;

procedure TPraxioBaseFormView.PraxioBaseFormViewDestroy(Sender: TObject);
begin
  self.FormDestroy(Sender);
end;

procedure TPraxioBaseFormView.PraxioBaseFormViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  self.FormKeyDown(Sender, Key, Shift);
end;

procedure TPraxioBaseFormView.PraxioBaseFormViewKeyPress(Sender: TObject; var Key: Char);
begin
  self.FormKeyPress(Sender, Key);
end;

procedure TPraxioBaseFormView.PraxioBaseFormViewShow(Sender: TObject);
begin
  self.FormShow(Sender);
end;

function TPraxioBaseFormView.PressionouEsc: Boolean;
begin
  result := ((GetKeyState(VK_ESCAPE) and $1000000) <> 0);
end;

function TPraxioBaseFormView.PressionouSetaParaBaixo: Boolean;
begin
  result := FPressionouSetaParaBaixo;
  FPressionouSetaParaBaixo := false;
end;

function TPraxioBaseFormView.PressionouShiftTab: Boolean;
begin
  Result := ((GetKeyState(VK_SHIFT) and $1000000) <> 0) and (vTab);
end;

function TPraxioBaseFormView.PressionouShiftTabOuEsc: Boolean;
begin
  Result:= PressionouShiftTab or PressionouEsc;
end;

function TPraxioBaseFormView.Resolve<T>: T;
begin
  Result := GlobalContainer.Resolve<T>;
end;

function TPraxioBaseFormView.RetornaLGPDCompartilhaPermissoes: Boolean;
begin
  Result := False;
end;

function TPraxioBaseFormView.RetornaLGPDFormulariosExternos: TArray<TPair<TForm, string>>;
begin
  Result := nil;
end;

procedure TPraxioBaseFormView.SetIdTela(const Value: string);
begin
  FId := Value;
end;

function TPraxioBaseFormView.ValidarComponenteParaPesquisa(
  aSender: TObject): Boolean;
begin
  Result:= (aSender is TPngSpeedButton) or (aSender is TSpeedButton);
end;

procedure TPraxioBaseFormView.AdicionarMenuItemSaida;
var
  vMainMenu: TObject;
  vMenuItem: TMenuItem;

  function RetornarMainMenu: TMainMenu;
  var
    vIndex: Integer;
  begin

    Result := nil;

    for vIndex := 0 to Self.ComponentCount - 1 do
      if Components[vIndex] is TMainMenu then
      begin
        Result := TMainMenu(Components[vIndex]);
        Break;
      end;

  end;

  function ExisteMenuSaida: Boolean;
  var
    vIndex: Integer;
  begin
    Result := False;
    for vIndex := 0 to TMainMenu(vMainMenu).Items.Count - 1 do
    begin

      if Uppercase(RemoveAcentos(Trim(TMainMenu(vMainMenu).Items[vIndex]
        .Caption))) = '&SAIDA' then
      begin
        Result := True;
        Break;
      end;

    end;

  end;

begin

  if not FSeNaoExistirAtribuirMenuSaida then
    Exit;

  vMainMenu := RetornarMainMenu;

  if vMainMenu = nil then
    Exit;

  if ExisteMenuSaida then
    Exit;

  vMenuItem := TMenuItem.Create(TMainMenu(vMainMenu));
  vMenuItem.Caption := '&Saída';
  vMenuItem.OnClick := MnFrmBaseSaidaClick;
  TMainMenu(vMainMenu).Items.Insert(TMainMenu(vMainMenu).Items.Count,
    vMenuItem);

end;
end.
