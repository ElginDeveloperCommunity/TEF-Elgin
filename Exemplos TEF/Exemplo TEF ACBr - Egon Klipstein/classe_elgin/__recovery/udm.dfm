object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 330
  Width = 503
  object tblconf: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 32
    Top = 32
    object tblconfIMPRESSORAPortaNome: TStringField
      FieldName = 'IMPRESSORAPortaNome'
      Size = 100
    end
    object tblconfIMPRESSORAModelo: TIntegerField
      FieldName = 'IMPRESSORAModelo'
    end
    object tblconfIMPRESSORAAvanco: TIntegerField
      FieldName = 'IMPRESSORAAvanco'
    end
    object tblconfELGIN_ComprovanteCliente: TIntegerField
      FieldName = 'ELGIN_ComprovanteCliente'
    end
    object tblconfELGIN_ComprovanteLoja: TIntegerField
      FieldName = 'ELGIN_ComprovanteLoja'
    end
    object tblconfELGIN_SalvarLOG: TBooleanField
      FieldName = 'ELGIN_SalvarLOG'
    end
    object tblconfELGIN_ImpressaoReduzida: TBooleanField
      FieldName = 'ELGIN_ImpressaoReduzida'
    end
    object tblconfELGIN_ComprovanteSimplificado: TBooleanField
      FieldName = 'ELGIN_ComprovanteSimplificado'
    end
  end
  object tbltef: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 32
    Top = 104
    object tbltefdh: TDateTimeField
      FieldName = 'dh'
    end
    object tbltefforma: TStringField
      FieldName = 'forma'
      Size = 30
    end
    object tbltefNSU: TStringField
      FieldName = 'NSU'
      Size = 30
    end
    object tbltefvalor: TFloatField
      FieldName = 'valor'
    end
    object tbltefRede_Adquirente: TStringField
      FieldName = 'Rede_Adquirente'
      Size = 30
    end
    object tbltefPagamento_Cartao: TStringField
      FieldName = 'Pagamento_Cartao'
      Size = 30
    end
    object tbltefPagamento_Tipo: TStringField
      FieldName = 'Pagamento_Tipo'
      Size = 30
    end
    object tbltefCodigo_de_Autorizacao: TStringField
      FieldName = 'Codigo_de_Autorizacao'
      Size = 30
    end
    object tbltefDocumento_numero: TStringField
      FieldName = 'Documento_numero'
      Size = 30
    end
  end
  object dtstef: TDataSource
    AutoEdit = False
    DataSet = tbltef
    Left = 80
    Top = 106
  end
end
