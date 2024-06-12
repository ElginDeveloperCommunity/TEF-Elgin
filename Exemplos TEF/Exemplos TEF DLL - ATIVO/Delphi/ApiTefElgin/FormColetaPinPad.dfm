object frmColetaPinpad: TfrmColetaPinpad
  Left = 0
  Top = 0
  Caption = 'frmColetaPinpad'
  ClientHeight = 415
  ClientWidth = 782
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 273
    Height = 393
    Caption = 'Coleta'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 35
      Width = 54
      Height = 13
      Caption = 'Tipo Coleta'
    end
    object cmbTipoColeta: TComboBox
      Left = 128
      Top = 32
      Width = 113
      Height = 21
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 0
      Text = 'tipoColeta'
      Items.Strings = (
        'RG'
        'CPF'
        'CNPJ'
        'Telefone')
    end
    object rdbNotConfirm: TRadioButton
      Left = 16
      Top = 72
      Width = 122
      Height = 17
      Caption = 'Confirma'#231#227'o Indireta'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = rdbNotConfirmClick
    end
    object rdbConfirm: TRadioButton
      Left = 144
      Top = 72
      Width = 113
      Height = 17
      Caption = 'Confirma'#231#227'o Direta'
      TabOrder = 2
      OnClick = rdbConfirmClick
    end
    object btnRealizaColeta: TButton
      Left = 16
      Top = 120
      Width = 225
      Height = 49
      Caption = 'Realizar Coleta PinPad'
      TabOrder = 3
      OnClick = btnRealizaColetaClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 296
    Top = 8
    Width = 478
    Height = 393
    Caption = 'Logs'
    TabOrder = 1
    object memoLogs: TMemo
      Left = 16
      Top = 24
      Width = 449
      Height = 345
      Lines.Strings = (
        'memoLogs')
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
