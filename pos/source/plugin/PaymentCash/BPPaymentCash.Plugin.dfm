object BPPaymentCashForm: TBPPaymentCashForm
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
    Caption = #54788#44552'/'#54788#44552#50689#49688#51613' '#44208#51228
    Color = 5393480
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
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
    TabOrder = 0
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
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000800000
        00800806000000C33E61CB000000017352474200AECE1CE90000000467414D41
        0000B18F0BFC6105000000097048597300000EC300000EC301C76FA86400000F
        9B4944415478DAED5D09901BC515ED9656D262832F7030A71D3009841058AD31
        184862082942282E4308F715204002C56D690DC1107B571B6C0C24841B1F5C26
        180CE4A6028480C1604B3267B842CC7D99D398786776D579DF2383D8D574F768
        248D4633AFAAAB55D29FDFBFBB9F66FAF8FD87B3108106F7DA8010DE222440C0
        111220E008091070840408384202041C2101028E90000147488080232440C011
        1220E0083C01BA7346A2C0D8787CDC05693BA4D1489B218D406A2D8AF5207D84
        F41AD28B48CF203DC1045B926E8FF7785D07370824013A733D8338E307E0E341
        487B23AD53A12A13E96EA4859C45EE4E255BFEE775DD9C225004E8CA1A1BA1C6
        1DF87838B3FEE1D5C44AA4AB18E7B3D26DB177BCAEAB2E024180AEBC3114B7EB
        8BF1F124F6E56DBD56C01385CD40C34E4F25E39F7A5D77159A9E005D39E33064
        339036AE73D1EF239D924EC6EFF4BA0D64685A02A0E30723BB0CE9048F4D992D
        183BAD23195FE5759B94435312009D3F0619FDF3925EDB52C4E34887E06EF09A
        D786F447D311009DFF6D64F7216DE4B52DFDF01ED21E20C1B35E1B528AA62200
        3A7F5B640F207DCDE1A57D488F21FD03298756798509FE166B695969FDDA3B98
        09310A9F487F1BD244A409485187E5D0A0706790E0DF5EB7D55A340D01D0F99B
        33AB139D0CF69623CD44BA0B9DF296A3F2F2E60890E267F8F84BA4CD1D5C4A83
        C37694F7BAB72D66A1290880CE1F84EC51A4ED352F7917690AAA3F379D8CF556
        A1FC93914D45DA50F392C7D0F27BA6DBE29F7BD15EA56816025C89EC544DF1EB
        986093D3EDF18FAA6AC332B39515C475F878A4AE1DB80B9C54CF762A07DF1300
        9D4FAB7AB768881A4867A1D1AFACB13DD4A957202534C40F843D77D7BE95ECE1
        6B0274E57A86A00ACF33F5889F6EB587A2B1FF581FBB8CFD90DD863448218AF1
        001F8BC790672B863E27807111B25F29C4E89F7F003AFFAF75B66D5F640B90E2
        0AD16ED896AAA76DA5F02D013A73C6C630FE65A6DEC93B1D0DFC5B2F6C2C3E0E
        AE5188610ACA37C15DE05D2F6CF42D0134FFFDD7A3F34FF4D8CE9B911DA11283
        9D1D1A7A68E09A437A10F2CBAB619F2F098039782BE6E06F32F996EE3BA8DDB7
        30D5AAEA68DFB1AD4B606B542C67F229E2679CF191A9646CB5AD9E9C41338CD2
        7D8D6548F370DD0D291763087F122067FC14D97C85D869F897FCCE6B5B8BF69E
        82ECF70A311AA4DE2ED17130B23BCAFC44A4C9A02B67E031E278C3C9AF04B80B
        D9811291FF70C1B74EB5BB5FE4A9A2CDFF45364622321F0438CCEEC74C6EF57A
        8245E86E66B7FC4C2B8B2740C77D4EECF21D0132592321385B818FEB4AC4A6A0
        213ABDB6B51420C0B9C87E231159CD041B9A6E8F1B121D4F22FB8EA2A869BCD0
        77616ADC3A051DBB7C470034C244640F4A44686307A3EAB827A36A5BBBADBD03
        DA11946D20ED06BB1749EA3E07D9311AC5DD2A9838B623993055827E24C099C8
        2E9588FC138DB8BBD776DAD84E9DBB8B44E41CD83E5372FD39C82ED12C6E3E2F
        882353E3127D32213F12601EB2A324229D68C4295EDB6963FBAF919D2F11990D
        DB8F975C3F89598E2EBAC0C0307EAE4CC08F04A05DBF091291FD51E97BBDB6D3
        C67655073E0ADB77B5BD3E6B8C458F3D8C8FA31C142BDD6FF02301C8AD6A3389
        C836A8F0F35EDB59D6F6BCF14D0CF464B6BD0EDB95BE050EB79F3F46DA027ACB
        AE87F891009F211B6CF73B6762582A99F8C46B3BCB219333860AAB43ECB00A1D
        B5AE8EAEAE3C7929156EC5C7FD34C42F83DE33CBFDE04702D0DCDE76241DED8D
        B59C379EF7395059376472222A98295B9BE84347B5386C8FAB909DAC1013E8E9
        CDD26DF137FBFFD07404E02CD6924A362601A62D132DD182299B9AF58200B10A
        DA6421B20314626507C77E2480F411000C43451BF211D0953587332E3E9488AC
        84ED439CEACDE47B6242F057F0715389D8FBBDD1BE51176CFFD505223F12C0BF
        8340CB65FD6989C872D8FEF50A751F87EC4685D804E85F5CFA851F09A09A0692
        F3C73D5EDB69633B0DD864B63D02DBBFEB42FFAB4CEEA13C6089DC8F04502D04
        4D43252FF0DA4E1BDBA722BB502272336C3F4A535D39FDDDC8CE9388DC09FD07
        977EE14702A836551E4225277A6DA78DEDAAA5E07361FB0C17FA7F8CECCF1291
        17A07FEBD22FFC4880EF217B4821B6112ADA5067F461370DD0E8161D9188ED0A
        BB1FADB88CBC398A09F1B644E413E81F56FA85EF083075B18824E2268DF2650B
        26E7A1A2BA9B267501087006B25912914F315B1F29DB0E5621935B1D132C22BB
        7EC03A839200305CD4BBB160D48854D2DE950B36D17AFA24898A3718135BA435
        B643EB814C0ED334C6C9815536405B80CEF9899B72BA979AAD85889085A919B0
        CED090040026C1D085129BC8C9F266858E93A143E5915B17687A07D3F1F13B74
        F4D997D30382F15725221FA28CF54BBF6854025C05436D8F7A65968A888898E4
        5CB1BE4407ADB96F093DB285979A23933346A001E934B0ECC4F28A82E09B4E69
        8FB98A3886BEA280577F91883C83F6D8AEF48B4625C0C79108DB60F20E71DB25
        5DD845F3D9B442CF3C5458C783A666809DB3911DAB109B093BCFA94259AA36B9
        17E5EC5FFA45A31280B0378CFD9BDD8F9DCB7A87F342811C21072BF4FC1C7AAE
        F5A202683B3A3AAE3A94429EBC5BBA7561EBCE19D10263B41C2C1B675C88722E
        2EFDA2910920F5922DDA361D5987862E29996A81A2F307B9AEAB3677945E3B9A
        E5D102D23C8598F3A5600F0940182D8BABD3FDE4E7D1425F0B0D7A36D1D0B597
        5397E94A81362397751AA4AA0E87BE2198D8A62399F8CC557979633D4C219F63
        F2CDA0D77BA37D631C6F06794C804BD169672BEC3B04D9ED9AFA286CDBD5B534
        18F690BD19249D7D7DE96C47ABBCA70467BDE61C7C3C5A213A0B659DD5FFCB5A
        1360090A1DEFA6825A8D90336E4076BCA6F85CFC5BCEAC7A8088BC311C7AC9A3
        F738CD4BAE46DB9CE2A6CCCE9CE09C99B4FEAF7A84D0E2108D33DEE8FF43AD09
        60A0509D4009AE013BE9D0649BA638AD244E8E44C48D937770B75854DC8BA729
        2B8D457483532D0159BE0F12561C5B1873FEF5D07D97333DC25D837E28EB3554
        6B027C8E8255A3F4AA00765270A82798DE78602DC8458ACE0FCE71BA77502C8F
        1678689A39C66199132A0D12D59DC5689FAFD90D9DA659D71520DB3620DB8A72
        3FD69A008B51D1092EAE7704D84A77001AED3B0D1347F857312D457A114FD6B7
        0BDC3A751B11E6102ED64421F906D24ECCF247A07D7BA761E268F16A77B4C973
        32A1E94F0B1E31CDD111C6DE2AF409C1A27C24B30260ED85B40FD25807651E83
        F26C6707B52640DD37653259737BC1C59F987C44EC05F08FE79889C494310235
        368E747139DAFF0C99402D09908F703661725BFD5FA88001D928DCF668495477
        4C506BD0F8645F9D5884686FBAC3D076B7DBB1D39D9CF143538A3078B522C053
        48FB941B75D61365822A788159BC203A52E312AB55825D5963247A6409B3DE5A
        E2060BF0C83A3AA531C8AC0601E899B97683813A7E36E62637A4DA2ADFD7AE26
        8A8115286AB893C1613540E43F1B7F823F68D999ED69659C5320AB892ECBBD84
        73DE916AD38B8DE09A00A860C33B9574E756450B2C36151FE979A875F2C60528
        BE70069D7979BA4D2F62071E59513CB268A076B88B7269944FA78BE73AB92810
        04F8B22EE670C6041D91A205980DAAACFE0346B77BCE71F7D37F654C67BE27C6
        05275F01DD05A4FEA0311605A6A470731F38BD385004588B2B5E127CD54A9336
        9A68C3E60748C32A54453E07F723DD219858D8914C387EECA17DC9499496B29D
        CE5AE811733DD25C3711C3024980525CF2A4E0BD7D261DC9DE995963199A6353
        67E06EF1C55633DDCA69E9981AFD25668DEAF38C4516A7932D55713B2B126122
        D28E485B312BEAF9D0E2CFB41E41CE9EF4CA3ADACD5BC40B7D8B74C3C0C81078
        02041D4D4580AE5CCF067DBD7D1F9E3F7E90EB7F4650D03404C0487A1D8CA469
        2F806E9567A8965B4358681E020C0C1D7B25087151BA3DFEBED7B679D41EB498
        34B3FF51B0FE680A02C0463AEE448B50FDDDAFC8A994A648339CBE12C6AF287A
        07511C805F20ADABEA9F662100CDA3556FDFB8B65060A74E19176FC8E011EEDB
        C01CC598388D594BDF5FEC86363C01BA96F6B4B2083F9D59A15F7760D6D9394C
        B1D87C561057A7156BE85D5963086A41CF7D99FF1DA651E287E964E20937B67A
        513FA57EEBCDA8B49E4147CF07BC9BA0A109507CD3D73DC5862907DA183948E6
        3CA11938FA38E898E3C4365A1F300B662C2A62BD0566A061392D16D13F8BD608
        288803EDCFDF04BD0FD7B27E1A6DE8AA7F3C23402667B60A266823695B856836
        C2F96E93DBCA8752877DE4F32F7B2700C5D6DFA3121BA19B3A689C44C4F64047
        B5EAA761A33F0900BD3448D10DE74E2F7B9A65A347D54927E2DAEB6B64A36D2C
        826AD54FC346DF1220CBF4DFED6BEB5D0C3D34CD936DEC6C856B5FAECCC69EB1
        68A2972422EF41F786E5AFAD4EFDD436FA9700E4ACD0AA296EEB5D0C3DB41B26
        7931136F4D272B3B74A971DEDE845D65CBAE56FD54080A016CBD8B55710331D2
        4E60A45D9173CAF4AC998870217B36DBC6F5AB56FD54F033016880D4AE296EEB
        5D0C3DB4072E7B7750E58F00756CDF15D03DB296F553DAE86302A8E2FE97C2D6
        BB58E340C8F1B87676853692CFFF1C89C852E8DEB196F5D3B0D19F0498FAACE0
        891E935E81B29D4254EA5DACF1168DFB61E39E95D808DD34C7DF4D2242EB0065
        CFE455AB7E1A36FA930045DD14F7FE3E492329BD8BA183D60054E7FF0F860E27
        2F5A20BDF412E89B1462C7CA7CF0AA513F0D3BFD4B809232C859F30856817771
        266B0E155CD05450760E9F74EC085B9FD2B48756EEE8BD44C3143A37D6F1C373
        533F0DDDFE27805BC046F2A93B442146A3F9C355C7B18B4BCBF48EBF110A7DB7
        41971B2FDE6AD53D24006CA411F4229DFA30CB899382373CC2057BADC0D75C44
        6BF674D68F3A5467BC401E47E350F77C03D43D2440D14E8A945DA96BB5535C87
        7AABB69FEB55EF900084EE6546A250602F30F7C7AA54588ED4867A7FEC565135
        1012E0ABB6926B351D0A1DEA56970D28B0C444D47999D7752DA97348807EF6FE
        8859072D1CBF7943814FD010933A92F107BCAE63BFFA86042863331DF4B88555
        EF71B09C596B0959AFEB56A6AE2101CADA9D37124CAC09D248C1A39C46F2580B
        1AED5354B1298DF2CC1F50CF9000726472C64EC23A154C7E7371CDCB68716601
        D215A8DFE35ED7418690009A001186A022B4C84303455AE9A3B9FFDAC1220DEE
        2820250DEEEEE782FF3DD51EF3C57902CF09C0ACC38A55F7760DF15548BC8B77
        925D570F0294836B6FD7105F42C3BBD8165E1180E0CADB35840507DEC565E125
        0108157BBB86B0E0D0BB7800BC26405D620537331C7A170F80D704A85BACE066
        8543E7D201F09A00758B15DCACF03B01EA1A2BB819E1D0BB7800BC2640088F11
        1220E008091070840408384202041C2101028E90000147488080C33501423437
        4202041C2101028E90000147488080232440C0111220E0080910708404083842
        02041C2101028E90000147488080232440C0111220E008091070FC1FC2EAB7DB
        0CCA81120000000049454E44AE426082}
      ExplicitLeft = 6
      ExplicitTop = -3
    end
    object btnCashComplete: TBitBtn
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
      Caption = #54788#44552' '#44208#51228
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ImageIndex = 48
      ImageName = 'Cash_32px'
      Images = BPDM.imlIcon32
      ParentFont = False
      TabOrder = 0
      OnClick = btnCashCompleteClick
    end
    object btnCashApprove: TBitBtn
      AlignWithMargins = True
      Left = 5
      Top = 452
      Width = 205
      Height = 50
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      Caption = #54788#44552#50689#49688#51613' '#48156#54665' '#50836#52397
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnCashApproveClick
    end
    object ckbSelfCashReceipt: TCheckBox
      AlignWithMargins = True
      Left = 15
      Top = 419
      Width = 185
      Height = 30
      Margins.Left = 15
      Margins.Right = 15
      Align = alBottom
      Caption = #54788#44552#50689#49688#51613' '#51088#51652' '#48156#44553' (F11)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      StyleElements = [seClient, seBorder]
      OnClick = ckbSelfCashReceiptClick
    end
  end
  object panBody: TPanel
    Left = 0
    Top = 38
    Width = 585
    Height = 562
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object btnEntityPerson: TSpeedButton
      Left = 62
      Top = 391
      Width = 60
      Height = 43
      GroupIndex = 100
      Down = True
      Caption = #44060#51064
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
    end
    object btnEntityBiz: TSpeedButton
      Left = 119
      Top = 391
      Width = 60
      Height = 43
      GroupIndex = 100
      Caption = #49324#50629#51088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 62
      Top = 369
      Width = 56
      Height = 18
      Caption = #48156#44553' '#44396#48516
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
    end
    object lblOrgApproveDate: TLabel
      Left = 62
      Top = 266
      Width = 73
      Height = 18
      Caption = #50896#44144#47000#51068#51088' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
    end
    object lblOrgApproveNo: TLabel
      Left = 62
      Top = 291
      Width = 73
      Height = 18
      Caption = #50896#49849#51064#48264#54840' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
    end
    object edtChargeTotal: TDBNumberEditEh
      Left = 62
      Top = 133
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
      StyleElements = [seBorder]
      TabOrder = 0
      Value = 0.000000000000000000
      Visible = True
    end
    object edtUnpaidTotal: TDBNumberEditEh
      Left = 62
      Top = 209
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
      StyleElements = [seBorder]
      TabOrder = 1
      Value = 0.000000000000000000
      Visible = True
    end
    object edtPaymentAmt: TDBNumberEditEh
      Left = 325
      Top = 133
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
      StyleElements = [seBorder]
      TabOrder = 2
      Value = 0.000000000000000000
      Visible = True
      OnChange = edtPaymentAmtChange
      OnEnter = edtPaymentAmtEnter
    end
    object edtChangeAmt: TDBNumberEditEh
      Left = 325
      Top = 209
      Width = 200
      Height = 45
      TabStop = False
      ControlLabel.Width = 79
      ControlLabel.Height = 18
      ControlLabel.Caption = #44144#49828#47492#46024' ('#50896')'
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
      StyleElements = [seBorder]
      TabOrder = 3
      Value = 0.000000000000000000
      Visible = True
    end
    object ckbManualnput: TCheckBox
      Left = 62
      Top = 330
      Width = 300
      Height = 28
      Caption = #54788#44552#50689#49688#51613' '#51076#51032' '#46321#47197' ('#49688#44592' '#51077#47141')'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = ckbManualnputClick
    end
    object edtManualApproveNo: TDBEditEh
      Left = 185
      Top = 391
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
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -28
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      MaxLength = 8
      ParentFont = False
      TabOrder = 5
      Visible = True
    end
    object edtManualIdentNo: TDBEditEh
      Left = 290
      Top = 391
      Width = 235
      Height = 43
      Alignment = taCenter
      AutoSize = False
      ControlLabel.Width = 230
      ControlLabel.Height = 18
      ControlLabel.Caption = #49885#48324#48264#54840' ('#55092#45824#54256#48264#54840' '#46608#45716' '#49324#50629#51088#48264#54840')'
      ControlLabel.Font.Charset = DEFAULT_CHARSET
      ControlLabel.Font.Color = clWindowText
      ControlLabel.Font.Height = -15
      ControlLabel.Font.Name = 'Pretendard Variable'
      ControlLabel.Font.Style = []
      ControlLabel.ParentFont = False
      ControlLabel.Visible = True
      DynProps = <>
      EditButtons = <>
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -28
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      MaxLength = 11
      ParentFont = False
      TabOrder = 6
      Visible = True
    end
    object btnCheckCheque: TBitBtn
      AlignWithMargins = True
      Left = 400
      Top = 325
      Width = 125
      Height = 38
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = #49688#54364' '#51312#54924
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = btnCheckChequeClick
    end
  end
end
