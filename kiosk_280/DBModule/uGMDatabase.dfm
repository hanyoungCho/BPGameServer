object GMDatabase: TGMDatabase
  Left = 0
  Top = 0
  ClientHeight = 231
  ClientWidth = 682
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Connection: TUniConnection
    ProviderName = 'MySQL'
    Port = 3306
    Database = 'gmsoftgolf'
    Username = 'jangheejin'
    Server = '192.168.0.75'
    LoginPrompt = False
    Left = 32
    Top = 17
    EncryptedPassword = '87FF87FF87FF87FF87FF'
  end
  object Query1: TUniQuery
    Connection = Connection
    Left = 32
    Top = 80
  end
  object Query2: TUniQuery
    Connection = Connection
    Left = 82
    Top = 81
  end
  object Query3: TUniQuery
    Connection = Connection
    Left = 130
    Top = 81
  end
  object MySQL: TMySQLUniProvider
    Left = 86
    Top = 17
  end
end
