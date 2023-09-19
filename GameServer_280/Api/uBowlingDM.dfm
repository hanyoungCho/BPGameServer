object BowlingDM: TBowlingDM
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 387
  Width = 588
  PixelsPerInch = 96
  object ConnectionDB: TUniConnection
    ProviderName = 'MySQL'
    Port = 3306
    Database = 'bowling'
    Username = 'bowling'
    Server = 'localhost'
    LoginPrompt = False
    Left = 120
    Top = 17
    EncryptedPassword = '9DFF90FF88FF93FF96FF91FF98FFCEFFCDFFCCFFDEFF'
  end
  object MySQL: TMySQLUniProvider
    Left = 46
    Top = 17
  end
  object UniConnection1: TUniConnection
    Left = 128
    Top = 200
  end
end
