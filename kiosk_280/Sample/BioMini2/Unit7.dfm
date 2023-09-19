object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Form7'
  ClientHeight = 311
  ClientWidth = 908
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 336
    Top = 158
    Width = 257
    Height = 133
    Caption = #51648#47928#44160#49353
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -67
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 158
    Width = 305
    Height = 133
    Caption = #51648#47928#46321#47197
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -67
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 624
    Top = 8
    Width = 273
    Height = 283
    TabOrder = 2
  end
  object Button3: TButton
    Left = 79
    Top = 8
    Width = 282
    Height = 81
    Caption = 'DB Load'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -67
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = Button3Click
  end
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
  object MySQL: TMySQLUniProvider
    Left = 38
    Top = 17
  end
  object Query: TUniQuery
    Connection = Connection
    Left = 32
    Top = 24
  end
end
