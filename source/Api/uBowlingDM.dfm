object BowlingDM: TBowlingDM
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 581
  Width = 882
  PixelsPerInch = 144
  object ConnectionDB: TUniConnection
    ProviderName = 'MySQL'
    Port = 3306
    Database = 'bowling'
    Username = 'bowling'
    Server = 'localhost'
    LoginPrompt = False
    Left = 180
    Top = 26
    EncryptedPassword = '9DFF90FF88FF93FF96FF91FF98FFCEFFCDFFCCFFDEFF'
  end
  object MySQL: TMySQLUniProvider
    Left = 69
    Top = 26
  end
  object UniConnection1: TUniConnection
    Left = 192
    Top = 300
  end
end
