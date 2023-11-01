object BPPaymentCardForm: TBPPaymentCardForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnActivate = PluginModuleActivate
  OnClose = PluginModuleClose
  OnKeyDown = PluginModuleKeyDown
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 18
  object lblOrgApproveDate: TLabel
    Left = 62
    Top = 304
    Width = 73
    Height = 18
    Caption = #50896#44144#47000#51068#51088' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object lblOrgApproveNo: TLabel
    Left = 62
    Top = 329
    Width = 73
    Height = 18
    Caption = #50896#49849#51064#48264#54840' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #49888#50857#52852#46300' '#44208#51228
    Color = 5393480
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 7
    StyleElements = []
    OnMouseMove = panHeaderMouseMove
    object lblPluginVersion: TLabel
      AlignWithMargins = True
      Left = 43
      Top = 5
      Width = 95
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'PLUGIN Ver.1.0.0.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      StyleElements = []
      ExplicitHeight = 13
    end
    object panHeaderToolbar: TPanel
      AlignWithMargins = True
      Left = 765
      Top = 3
      Width = 32
      Height = 32
      Align = alRight
      AutoSize = True
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 0
      StyleElements = []
      object btnClose: TSpeedButton
        Left = 0
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 3
        ImageName = 'Close_W_32px'
        Images = BPDM.imlIcon32
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        StyleElements = []
        OnClick = btnCloseClick
        ExplicitTop = 2
      end
    end
    object panHeaderMenuBar: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 32
      Height = 32
      Align = alLeft
      AutoSize = True
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 1
      StyleElements = []
      object btnMainMenu: TSpeedButton
        Left = 0
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 1
        ImageName = 'Menu_W_32px'
        Images = BPDM.imlIcon32
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        StyleElements = []
        ExplicitTop = 2
      end
    end
  end
  object panRight: TPanel
    Left = 585
    Top = 38
    Width = 215
    Height = 562
    Align = alRight
    BevelOuter = bvNone
    Color = 9857565
    ParentBackground = False
    TabOrder = 6
    StyleElements = [seFont, seBorder]
    object imgLogo: TImage
      Left = 0
      Top = 0
      Width = 215
      Height = 128
      Align = alTop
      AutoSize = True
      Center = True
      Picture.Data = {
        0D546478536D617274496D61676589504E470D0A1A0A0000000D494844520000
        0080000000800806000000C33E61CB000000017352474200AECE1CE900000004
        67414D410000B18F0BFC6105000000097048597300000EC300000EC301C76FA8
        640000071C49444154785EEDDD6B8C13551407F099D65691F88AF24963107CE1
        83CD1605548262A289514113637CA1268A9268243111B6A09108D2352A1F7D26
        8A41C0F049D190A04124F80A4A5757306AD404895F341111E5B1DD65FC9FCE5D
        59CADCB9B79D76B6EBFDFF92B3E7DE666FB7DB7B3A9D4EA7B71E111111111111
        11111111111111111111111111111111118D58BECA0D2995FBC622CD464C435C
        80380D711C825AE7206237E22BC466C49A6221BF13B9210D1540A9A76F9C1778
        4BD0BC0D91A95E48C3E94DC49328849FC3AEBDBA0B008FFA0790962346572FA0
        767108710F8A408AC15A5D8F5E4CFE42A497119CFCF62373B91273343FECDAB1
        DE02E08AE720C9E427DA6FA054DC852DC12AD58E653599A572E52CCF0BBE4193
        8FFC91610031DE66E7D0F22920781A3F38F9234716213BE946C62D001EFD67A3
        00BE4353AE944696B1A6AD804501F43D8AF47CD8D3FA16F178C6F73F58D099FB
        3BBC885AA1BBA7322A0882EBD17C0A31A17AA15E170AE019D58E6453001B90AE
        0D7B91B6E36AA6150BB93DAA4F29E8EE0DF2417F450E06C515C17A1480148B96
        CD3EC0852AEB2CE2E4A7AF6BA2DF87B438EC6975AAAC65530063548EE47BFE46
        D5A49465B3FEBBAAA973AACA5A3605905739525721F78F6A52CAE677E4F6ABA6
        4EECDC09CB9781F47FC502701C0BC0712C00C7B1001CC702701C0BC071368782
        03D58C542CE48FB80ED3EF53BA6AE7A716B7008E6301388E05E0381680E35800
        8E6301388E05E0B8A61F07A074259D1F6E011CC702701C0BC0712C00C7B1001C
        C702701C0BC0713C0E50A3F4C5818C97CD4C477316A28038077132421E2C7F21
        BE477C8E58DF9F1DD8FC44C7285999E33F49C7D72BE9FCB0009465E58359DFF3
        EF47731EC2F4A1CB41B2264F7726F05E1BF003F99454C3E3174CCACB67FAEBC6
        03414D803BF17C4C9EACB8F512C276F2C438C42B877C6F4BD2F1B80DA6CF60B6
        84F305803B7E26D256C415D50B1A731922E9F85EDC961BC36E7A9C2E0035F96B
        1127542F185E3217EB709B623FCEDD6CCE1640F7B6CA79482B11C7562F681F52
        04B2E8662A9C2C80A5E5FD99C00F56A0796278495B91397975D9977DA92CC9E3
        640164BDAC2C6F3B35ECB5A5CBFD8C779F6AB7947305B07847202F8B1684BD58
        0710CF21A6E205DEF187B2817CD67E32425649B525BF5B3B5ED65BDA8730E95A
        BA755FCBE7C7B9E300F87FAE44FA28EC69FD8A9889FFAD1C760FB31C3F6806AE
        E3A8DFC575C8D22D6F23CEAC5EA017397EA8A4F3E3E253C0552AEBC8DA3B3744
        4DBE621A3FD4752A1F01D7DD8359BB094DD30A1F91E39BC9C50290A5EDE3ACC0
        04C9EA5B3AA6F1434D51F9280B5104482F843D2DEDF86671B100E4D87C9C3754
        D6318D1FCAF072CE7F4B35745AFE72D0C5023845E548D834CBA2977162C7D738
        49E548593FE8554D9DD8F1CDE06201C4EE34657CE38E71ECF81AB1EFF40D78DE
        31AAA993E89D421B2E16807CDD8A56107817A9A64EECF81AF1BF1B781DAAA553
        CFDF6A888B05F083CA3A77A8AC631A3F942CB21DE71695754CE31373B1003E53
        59672E5E5B5FAADA514CE387DAA6F251F0372E417A38EC6969C7378B8B05208B
        5F9B6CC404C951BB2836E307BDA3F211D4E4AF439856F28C1CDF4CCE1D0914F8
        9FBE469A18F662C9091E6BF05CDD8B3B21F07DEF62F4EF46C8993F36FFB77CC5
        CEEA88F1F722728838DB0FFAB9898B3BFDD8FB3FE9FCB8B80510CFAA6C3217B1
        1953BD1B93F727DA5B10F2DD49B645FF20226ABC69F2C572D3E4378393058047
        857CB59A9CC2D5AE3665FB73F27675CBB9BA0590C7B06C8AFF083B6D650F6EDC
        9CF9935BFFE817CE1640B133FF0BD2ED08D31B326992AF85BDB558C8FD14765B
        CFDD2D00E0A9E07DA49B112D3FE06241BE756596BA4DA971BA0004EEF00D783A
        902372B6EFF147F91891649F42C617AAB72565CE1780C0D3C12EDCF933D0BC13
        216FD3DA922FD39C8D976BD3315ECE134832BEEE2F7E6E06278F039894B6F54D
        C13D232763C87983E72206BF7B47761AE550B03C623FC4FFFE895C582BE9F87A
        249D1F16C008C7034194080BC0712C00C7D914809C25AB552A57F8ADE2C3A4BB
        5C317DA6510E2CC5B22980DF55D608AE560D4A59E005D7A8A6CE6F2A6BD914C0
        0E957596A01265050C4A11EE7339617469D8D3DAAEB2964D016C5259A7039528
        0B1CCCE4D341EB957A2AA3715FCFC27DFE29BAA6C528E478432CE36BF865E5CA
        E9BE17EC4433954FAB52D3C89233E38A85EA9B5E5AC62DC0C2424E3E27278B28
        D0C8B2DA34F9C2E62940B6138FE1E7DEB04323C05EEC212E52ED58560550ECCC
        CB56E021442A2729502232478F1427E57785DD78765B00C0E6449653912D018B
        A07DC9DC143157D6A793D5FD460EF640E52DCF1711EDB0B0121D264FD1F330F9
        AF875D3BD65B8041F803AB5068E3D144AEEE69D2F0EA47C8A44FA877F245A2B7
        72F1BAFF0C14839C57274703E53CFB31089B539EA97115841C9D95CF36C8E963
        EF61E27F44262222222222222222222222222222222222222222222222A778DE
        BF1AE2E7DD348386DC0000000049454E44AE426082}
      ExplicitWidth = 128
    end
    object btnApprove: TBitBtn
      AlignWithMargins = True
      Left = 5
      Top = 507
      Width = 205
      Height = 50
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      Caption = #44208#51228' '#49849#51064' '#50836#52397
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ImageIndex = 47
      ImageName = 'mastercard_credit_card_32px'
      Images = BPDM.imlIcon32
      ParentFont = False
      TabOrder = 0
      OnClick = btnApproveClick
    end
    object ckbApplyDiscount: TCheckBox
      AlignWithMargins = True
      Left = 30
      Top = 479
      Width = 155
      Height = 25
      Margins.Left = 30
      Margins.Top = 0
      Margins.Right = 30
      Align = alBottom
      Caption = #51593#49884#54624#51064' '#51201#50857
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      StyleElements = [seClient, seBorder]
      OnClick = ckbApplyDiscountClick
    end
    object ckbUseAppCard: TCheckBox
      AlignWithMargins = True
      Left = 30
      Top = 451
      Width = 155
      Height = 25
      Margins.Left = 30
      Margins.Right = 30
      Align = alBottom
      Caption = #50545' '#52852#46300'(OTC) '#44208#51228
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      StyleElements = [seClient, seBorder]
    end
  end
  object edtChargeTotal: TDBNumberEditEh
    Left = 62
    Top = 171
    Width = 200
    Height = 45
    TabStop = False
    ControlLabel.Width = 83
    ControlLabel.Height = 18
    ControlLabel.Caption = #48155#51012' '#44552#50529' ('#50896')'
    ControlLabel.Font.Charset = DEFAULT_CHARSET
    ControlLabel.Font.Color = clWindowText
    ControlLabel.Font.Height = -15
    ControlLabel.Font.Name = 'Pretendard Variable'
    ControlLabel.Font.Style = []
    ControlLabel.ParentFont = False
    ControlLabel.Visible = True
    AutoSize = False
    DecimalPlaces = 0
    DisplayFormat = ',0'
    DynProps = <>
    Enabled = False
    EditButtons = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 8
    Value = 0.000000000000000000
    Visible = True
  end
  object edtUnpaidTotal: TDBNumberEditEh
    Left = 62
    Top = 247
    Width = 200
    Height = 45
    TabStop = False
    ControlLabel.Width = 96
    ControlLabel.Height = 18
    ControlLabel.Caption = #48120#44208#51228' '#44552#50529' ('#50896')'
    ControlLabel.Font.Charset = DEFAULT_CHARSET
    ControlLabel.Font.Color = clWindowText
    ControlLabel.Font.Height = -15
    ControlLabel.Font.Name = 'Pretendard Variable'
    ControlLabel.Font.Style = []
    ControlLabel.ParentFont = False
    ControlLabel.Visible = True
    AutoSize = False
    DecimalPlaces = 0
    DisplayFormat = ',0'
    DynProps = <>
    Enabled = False
    EditButtons = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 9
    Value = 0.000000000000000000
    Visible = True
  end
  object edtInstallMonth: TDBNumberEditEh
    Left = 457
    Top = 248
    Width = 68
    Height = 43
    ControlLabel.Width = 52
    ControlLabel.Height = 18
    ControlLabel.Caption = #54624#48512#50900#49688
    ControlLabel.Font.Charset = DEFAULT_CHARSET
    ControlLabel.Font.Color = clWindowText
    ControlLabel.Font.Height = -15
    ControlLabel.Font.Name = 'Pretendard Variable'
    ControlLabel.Font.Style = []
    ControlLabel.ParentFont = False
    ControlLabel.Visible = True
    ControlLabelLocation.Position = lpAboveRightEh
    DecimalPlaces = 0
    DynProps = <>
    EditButtons = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16744448
    Font.Height = -29
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    MaxValue = 36.000000000000000000
    ParentFont = False
    StyleElements = [seClient, seBorder]
    TabOrder = 1
    Value = 0.000000000000000000
    Visible = True
    OnChange = edtInstallMonthChange
    OnEnter = edtInstallMonthEnter
  end
  object edtPaymentAmt: TDBNumberEditEh
    Left = 325
    Top = 171
    Width = 200
    Height = 43
    ControlLabel.Width = 113
    ControlLabel.Height = 18
    ControlLabel.Caption = #52572#51333' '#44208#51228' '#44552#50529' ('#50896')'
    ControlLabel.Font.Charset = DEFAULT_CHARSET
    ControlLabel.Font.Color = clWindowText
    ControlLabel.Font.Height = -15
    ControlLabel.Font.Name = 'Pretendard Variable'
    ControlLabel.Font.Style = []
    ControlLabel.ParentFont = False
    ControlLabel.Visible = True
    ControlLabelLocation.Position = lpAboveRightEh
    DecimalPlaces = 0
    DisplayFormat = ',0'
    DynProps = <>
    Enabled = False
    EditButtons = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16744448
    Font.Height = -29
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    StyleElements = [seClient, seBorder]
    TabOrder = 0
    Value = 0.000000000000000000
    Visible = True
    OnChange = edtPaymentAmtChange
    OnEnter = edtPaymentAmtEnter
  end
  object edtManualApproveNo: TDBEditEh
    Left = 62
    Top = 429
    Width = 99
    Height = 43
    AutoSize = False
    ControlLabel.Width = 52
    ControlLabel.Height = 18
    ControlLabel.Caption = #49849#51064#48264#54840
    ControlLabel.Font.Charset = DEFAULT_CHARSET
    ControlLabel.Font.Color = clWindowText
    ControlLabel.Font.Height = -15
    ControlLabel.Font.Name = 'Pretendard Variable'
    ControlLabel.Font.Style = []
    ControlLabel.ParentFont = False
    ControlLabel.Visible = True
    DynProps = <>
    EditButtons = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -28
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    MaxLength = 8
    ParentFont = False
    TabOrder = 3
    Visible = True
  end
  object edtManualCardNo: TDBEditEh
    Left = 167
    Top = 429
    Width = 68
    Height = 42
    Alignment = taCenter
    ControlLabel.Width = 118
    ControlLabel.Height = 18
    ControlLabel.Caption = #52852#46300#48264#54840' ('#50526' 4'#51088#47532')'
    ControlLabel.Font.Charset = DEFAULT_CHARSET
    ControlLabel.Font.Color = clWindowText
    ControlLabel.Font.Height = -15
    ControlLabel.Font.Name = 'Pretendard Variable'
    ControlLabel.Font.Style = []
    ControlLabel.ParentFont = False
    ControlLabel.Visible = True
    DynProps = <>
    EditButtons = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -28
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    MaxLength = 4
    ParentFont = False
    TabOrder = 4
    Visible = True
  end
  object cbxManualCardList: TDBComboBoxEh
    Left = 241
    Top = 429
    Width = 284
    Height = 43
    ControlLabel.Width = 65
    ControlLabel.Height = 18
    ControlLabel.Caption = #52852#46300#48156#44553#49324
    ControlLabel.Font.Charset = DEFAULT_CHARSET
    ControlLabel.Font.Color = clWindowText
    ControlLabel.Font.Height = -15
    ControlLabel.Font.Name = 'Pretendard Variable'
    ControlLabel.Font.Style = []
    ControlLabel.ParentFont = False
    ControlLabel.Visible = True
    ControlLabelLocation.Position = lpAboveRightEh
    AutoSize = False
    DynProps = <>
    EditButtons = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -28
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Visible = True
  end
  object ckbManualnput: TCheckBox
    Left = 62
    Top = 368
    Width = 200
    Height = 28
    Caption = #51076#51032' '#46321#47197' ('#49688#44592' '#51077#47141')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = ckbManualnputClick
  end
end
