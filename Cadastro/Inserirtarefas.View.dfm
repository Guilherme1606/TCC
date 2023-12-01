object TInserirTarefas: TTInserirTarefas
  Left = 311
  Top = 200
  BorderIcons = [biSystemMenu]
  Caption = 'Cadastro de Tarefas'
  ClientHeight = 374
  ClientWidth = 498
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 308
    Width = 498
    Height = 66
    Align = alBottom
    Caption = 'Panel1'
    Color = clBackground
    ParentBackground = False
    TabOrder = 0
    ExplicitTop = 328
    object SimpleButton1: TSimpleButton
      Left = 200
      Top = 20
      Width = 85
      Height = 30
      Caption = 'Entrar'
      TabOrder = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TipoAcao = Default
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 498
    Height = 308
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    ExplicitTop = -6
    ExplicitHeight = 328
    object Label1: TLabel
      Left = 32
      Top = 50
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object Label2: TLabel
      Left = 185
      Top = 50
      Width = 31
      Height = 13
      Caption = 'Label2'
    end
    object Label3: TLabel
      Left = 328
      Top = 50
      Width = 31
      Height = 13
      Caption = 'Label3'
    end
    object Label4: TLabel
      Left = 32
      Top = 101
      Width = 31
      Height = 13
      Caption = 'Label4'
    end
    object Label5: TLabel
      Left = 185
      Top = 101
      Width = 31
      Height = 13
      Caption = 'Label5'
    end
    object Label6: TLabel
      Left = 328
      Top = 101
      Width = 31
      Height = 13
      Caption = 'Label6'
    end
    object Edit1: TEdit
      Left = 32
      Top = 69
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Edit1'
    end
    object Edit2: TEdit
      Left = 185
      Top = 69
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Edit2'
    end
    object Edit3: TEdit
      Left = 328
      Top = 69
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Edit3'
    end
    object Edit4: TEdit
      Left = 32
      Top = 120
      Width = 121
      Height = 21
      TabOrder = 3
      Text = 'Edit4'
    end
    object Edit5: TEdit
      Left = 185
      Top = 120
      Width = 121
      Height = 21
      TabOrder = 4
      Text = 'Edit5'
    end
    object Edit6: TEdit
      Left = 328
      Top = 120
      Width = 121
      Height = 21
      TabOrder = 5
      Text = 'Edit6'
    end
  end
end
