inherited ClientesView: TClientesView
  Left = 319
  Top = 180
  BorderIcons = []
  Caption = 'Clientes'
  ClientHeight = 424
  ClientWidth = 500
  DefaultMonitor = dmDesktop
  Position = poDesigned
  ExplicitWidth = 500
  ExplicitHeight = 424
  PixelsPerInch = 96
  TextHeight = 13
  inherited PainelCentral: TPanel
    Width = 500
    Height = 367
    ExplicitWidth = 498
    ExplicitHeight = 337
    object SpeedButton1: TSpeedButton
      Left = 472
      Top = -1
      Width = 28
      Height = 22
      Cursor = crHandPoint
      Caption = 'X'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton1Click
    end
  end
  inherited PainelBaixo: TPanel
    Top = 367
    Width = 500
    ExplicitTop = 337
    ExplicitWidth = 498
  end
end
