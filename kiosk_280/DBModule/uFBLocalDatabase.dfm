object FBDataModule: TFBDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 212
  Width = 512
  object FDManager: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 48
    Top = 40
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=D:\Project Source\XGolf\kiosk\Bin\Data\XGOLF_KIOSK.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=127.0.0.1'
      'Port=3050'
      'CharacterSet=UTF8'
      'DriverID=FB')
    LoginPrompt = False
    Left = 152
    Top = 40
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    VendorLib = 'D:\Project Source\XGolf\kiosk\Bin\fbclient.dll'
    Left = 312
    Top = 56
  end
  object FDQuery: TFDQuery
    Connection = FDConnection
    Left = 144
    Top = 104
  end
end
