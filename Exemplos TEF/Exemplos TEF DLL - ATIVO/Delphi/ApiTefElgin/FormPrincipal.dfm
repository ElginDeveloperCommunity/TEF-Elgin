object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'API TEF Elgin'
  ClientHeight = 203
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 12
    Top = 167
    Width = 252
    Height = 25
    Caption = 'Carrega fun'#231#245'es'
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 16
    Width = 261
    Height = 145
    Caption = 'Configura'#231#227'o'
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 47
      Width = 142
      Height = 13
      Caption = 'Selecione o tipo de opera'#231#227'o.'
    end
    object ComboBox2: TComboBox
      Left = 16
      Top = 82
      Width = 225
      Height = 21
      TabOrder = 0
      Text = 'Opera'#231#227'o'
      Items.Strings = (
        'Opera'#231#245'es TEF'
        'Opera'#231#245'es Administrativas'
        'Opera'#231#245'es Coleta PinPad')
    end
  end
end
