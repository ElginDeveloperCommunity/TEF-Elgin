object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Fun'#231#245'es Administrativas'
  ClientHeight = 430
  ClientWidth = 838
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnProsseguir: TButton
    Left = 284
    Top = 365
    Width = 89
    Height = 57
    Caption = 'Prosseguir'
    TabOrder = 0
    Visible = False
    OnClick = btnProsseguirClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 16
    Width = 365
    Height = 81
    Caption = 'Opera'#231#245'es'
    TabOrder = 1
    object btnCancelarVenda: TButton
      Left = 16
      Top = 15
      Width = 129
      Height = 50
      Caption = 'Cancelamento de venda'
      TabOrder = 0
      OnClick = btnCancelarVendaClick
    end
    object btnReimpressao: TButton
      Left = 160
      Top = 16
      Width = 75
      Height = 49
      Caption = 'Reimpress'#227'o'
      TabOrder = 1
      OnClick = btnReimpressaoClick
    end
  end
  object Logs: TGroupBox
    Left = 392
    Top = 16
    Width = 438
    Height = 406
    Caption = 'Logs'
    TabOrder = 2
    object memoLog: TMemo
      Left = 2
      Top = 15
      Width = 434
      Height = 389
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 0
      ExplicitWidth = 421
      ExplicitHeight = 413
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 103
    Width = 365
    Height = 178
    Caption = 'Processamento'
    TabOrder = 3
    object Label1: TLabel
      Left = 2
      Top = 15
      Width = 361
      Height = 20
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 3
      ExplicitTop = 18
      ExplicitWidth = 78
    end
    object ListBox1: TListBox
      Left = 2
      Top = 56
      Width = 361
      Height = 120
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      Visible = False
      ExplicitTop = 35
      ExplicitHeight = 97
    end
    object Edit1: TEdit
      Left = 2
      Top = 35
      Width = 361
      Height = 21
      Align = alTop
      TabOrder = 1
      Visible = False
      ExplicitLeft = 3
    end
  end
  object btnCancelar: TButton
    Left = 192
    Top = 365
    Width = 86
    Height = 57
    Caption = 'Cancelar'
    TabOrder = 4
    Visible = False
    OnClick = btnCancelarClick
  end
  object btnVoltar: TButton
    Left = 104
    Top = 365
    Width = 82
    Height = 57
    Caption = 'Voltar'
    TabOrder = 5
    Visible = False
    OnClick = btnVoltarClick
  end
end
