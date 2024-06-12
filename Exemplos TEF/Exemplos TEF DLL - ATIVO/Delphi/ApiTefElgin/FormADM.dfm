object frmAdm: TfrmAdm
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
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 284
    Top = 365
    Width = 89
    Height = 57
    Caption = 'Prosseguir'
    TabOrder = 0
    Visible = False
    OnClick = btnOkClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 16
    Width = 365
    Height = 81
    Caption = 'Opera'#231#245'es'
    TabOrder = 1
    object btnIniciarOperacao: TButton
      Left = 144
      Top = 15
      Width = 201
      Height = 49
      Caption = 'Iniciar Opera'#231#227'o'
      TabOrder = 0
      OnClick = btnIniciarOperacaoClick
    end
  end
  object Logs: TGroupBox
    Left = 392
    Top = 16
    Width = 438
    Height = 406
    Caption = 'Logs'
    TabOrder = 2
    object memoLogs: TMemo
      Left = 2
      Top = 15
      Width = 434
      Height = 389
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 103
    Width = 365
    Height = 178
    Caption = 'Processamento'
    TabOrder = 3
    object lblOperador: TLabel
      Left = 2
      Top = 15
      Width = 361
      Height = 16
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 4
    end
    object listOperador: TListBox
      Left = 2
      Top = 52
      Width = 361
      Height = 124
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      Visible = False
    end
    object txtOperador: TEdit
      Left = 2
      Top = 31
      Width = 361
      Height = 21
      Align = alTop
      TabOrder = 1
      Visible = False
      OnKeyPress = txtOperadorKeyPress
    end
  end
  object btnCanc: TButton
    Left = 192
    Top = 365
    Width = 86
    Height = 57
    Caption = 'Cancelar'
    TabOrder = 4
    Visible = False
    OnClick = btnCancClick
  end
end
