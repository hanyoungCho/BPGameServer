object BPLaneViewForm: TBPLaneViewForm
  Left = 0
  Top = 0
  Margins.Top = 0
  BorderStyle = bsNone
  ClientHeight = 1022
  ClientWidth = 1700
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = PluginModuleClose
  OnKeyDown = PluginModuleKeyDown
  OnResize = PluginModuleResize
  OnShow = PluginModuleShow
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 18
  object panFooter: TPanel
    Left = 0
    Top = 764
    Width = 1700
    Height = 258
    Align = alBottom
    BevelOuter = bvNone
    Padding.Left = 5
    Padding.Right = 5
    ParentBackground = False
    TabOrder = 0
    object panToolBar: TPanel
      Left = 5
      Top = 0
      Width = 1690
      Height = 54
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object btnGameMenu1: TBitBtn
        AlignWithMargins = True
        Left = 0
        Top = 5
        Width = 136
        Height = 44
        Cursor = crHandPoint
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actPinSetterOn
        Align = alLeft
        Caption = #54592' '#49464#53552' On'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object btnGameMenu3: TBitBtn
        AlignWithMargins = True
        Left = 282
        Top = 5
        Width = 136
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actMonitorOn
        Align = alLeft
        Caption = #47784#45768#53552' On'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object btnGameMenu4: TBitBtn
        AlignWithMargins = True
        Left = 423
        Top = 5
        Width = 136
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actMonitorOff
        Align = alLeft
        Caption = #47784#45768#53552' Off'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
      object btnGameMenu5: TBitBtn
        AlignWithMargins = True
        Left = 564
        Top = 5
        Width = 136
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actLaneAssign
        Align = alLeft
        Caption = #48176#51221' '#46321#47197
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
      end
      object btnGameMenu6: TBitBtn
        AlignWithMargins = True
        Left = 705
        Top = 5
        Width = 136
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actOpenGame
        Align = alLeft
        Caption = #50724#54536' '#44172#51076
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object btnGameMenu7: TBitBtn
        AlignWithMargins = True
        Left = 846
        Top = 5
        Width = 136
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actLeagueGame
        Align = alLeft
        Caption = #47532#44536' '#44172#51076
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
      object btnGameMenu8: TBitBtn
        AlignWithMargins = True
        Left = 987
        Top = 5
        Width = 136
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actGameNext
        Align = alLeft
        Caption = #44172#51076' '#45349#49828#53944
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
      end
      object btnGameMenu9: TBitBtn
        AlignWithMargins = True
        Left = 1128
        Top = 5
        Width = 136
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actLaneClear
        Align = alLeft
        Caption = #47112#51064' '#52488#44592#54868
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
      end
      object btnGameMenu12: TBitBtn
        AlignWithMargins = True
        Left = 1551
        Top = 5
        Width = 139
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actPinSetting2
        Align = alClient
        Caption = #54592' '#49464#54021' 2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
      end
      object btnGameMenu10: TBitBtn
        AlignWithMargins = True
        Left = 1269
        Top = 5
        Width = 136
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actLaneControl
        Align = alLeft
        Caption = #47112#51064' '#51228#50612
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
      end
      object btnGameMenu2: TBitBtn
        AlignWithMargins = True
        Left = 141
        Top = 5
        Width = 136
        Height = 44
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actPinSetterOff
        Align = alLeft
        Caption = #54592' '#49464#53552' Off'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object btnGameMenu11: TBitBtn
        AlignWithMargins = True
        Left = 1410
        Top = 5
        Width = 136
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actPinSetting1
        Align = alLeft
        Caption = #54592' '#49464#54021' 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
      end
    end
    object G1: TcxGrid
      Left = 5
      Top = 54
      Width = 1547
      Height = 204
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnEnter = G1Enter
      OnExit = G1Exit
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      LookAndFeel.ScrollbarMode = sbmTouch
      LookAndFeel.ScrollMode = scmSmooth
      object V1: TcxGridDBBandedTableView
        PopupMenu = LanePopupMenu
        Navigator.Buttons.CustomButtons = <>
        FilterBox.Visible = fvNever
        ScrollbarAnnotations.CustomAnnotations = <>
        DataController.DataSource = dsrAssignList
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.Summary.Options = [soSelectedRecords]
        OptionsCustomize.ColumnFiltering = False
        OptionsCustomize.ColumnGrouping = False
        OptionsCustomize.ColumnHidingOnGrouping = False
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnVertSizing = False
        OptionsData.Deleting = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsView.FocusRect = False
        OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'>'
        OptionsView.ScrollBars = ssVertical
        OptionsView.ColumnAutoWidth = True
        OptionsView.GridLines = glVertical
        OptionsView.GroupByBox = False
        Styles.Header = BPDM.StyleHeader1
        Styles.Inactive = BPDM.StyleSelection
        Styles.Selection = BPDM.StyleSelection
        Styles.BandHeader = BPDM.StyleBandHeader
        Bands = <
          item
            Caption = #50696#50557' '#47785#47197
          end>
        object V1calc_rally_yn: TcxGridDBBandedColumn
          DataBinding.FieldName = 'calc_rally_yn'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Images = BPDM.imlIcon16
          Properties.Items = <
            item
              Value = False
            end
            item
              ImageIndex = 12
              Value = True
            end>
          HeaderGlyph.SourceDPI = 96
          HeaderGlyph.Data = {
            89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
            6100000006624B474400FF00FF00FFA0BDA793000001DE494441543811CD52CD
            6B1351109F79FBB289AD3450A85FFDA0829E04E9A142D55E94F52301BD19D1FF
            C1AB9444700FDA420F95B620DE2B14F4288AD4E845FF03BDA8B766B1BD48B005
            1377B36FFC4D62FA65EFFA98DFCCEFFD667676F6ED23FAD78B75803BAFBE66FB
            FCEC73229EC47E15E26BC4BF4C880A108745F8BD5FFF71232C9D8A0D04CA67B3
            B7458C6CC4CDA368A2881D537D2784391192C35AC3EC38E9CFDFD267AD3A1236
            2A2E164EC495B7B5C8A5F46CFACAC8A776EE8F2B576BA799F86AA7266211E769
            AA3D816D78CB427CA4FC2E9AC7046BC633A38475EF4D2D54809231324A246B95
            6AB44044871ABDBC8C48ED06E1B5633FFDB819B0D059889E2309107799737C99
            993D629A4872B9E0D1B9E18616B41B28098B273752723731C1191C6251352157
            552887561091094ED3D2ECE4C0A66A0AABAE0B6B6C469C5B4793DEF24A34F6F0
            D2D007CD555656C7115BD0D753CF66C0B76C6B02551E5C1CFCDC12AF282C4FD8
            D0946A0A315CC1048F912BCC04435F54EB027A976EC7F0C5B79EE440FA11FFFD
            3E89F8F8F6BB19AF35165E38DEDCAEEA30DB097BFCC15F4E9C7D89435D22D677
            F0DCF7460BFDF6D461BB6F8324B54F713732B85B53A8211677BECFCF2D819780
            5DB66F035404CC9227A1EBE0309D82EA20FFA1FD065AAEAB3819A5F7AE000000
            0049454E44AE426082}
          Width = 24
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
          IsCaptionAssigned = True
        end
        object V1assign_no: TcxGridDBBandedColumn
          Caption = #48176#51221#48264#54840
          DataBinding.FieldName = 'assign_no'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 130
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object V1reserve_datetime: TcxGridDBBandedColumn
          Caption = #50696#50557#49884#44033
          DataBinding.FieldName = 'reserve_datetime'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 200
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object V1calc_lane_no: TcxGridDBBandedColumn
          Caption = #47112#51064
          DataBinding.FieldName = 'calc_lane_no'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
        object V1direction: TcxGridDBBandedColumn
          DataBinding.FieldName = 'direction'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Images = BPDM.imlIcon16
          Properties.Items = <
            item
              ImageIndex = 0
              Value = 0
            end
            item
              ImageIndex = 1
              Value = 1
            end
            item
              ImageIndex = 2
              Value = 2
            end
            item
              ImageIndex = 7
              Value = 3
            end>
          HeaderAlignmentHorz = taCenter
          HeaderGlyph.SourceDPI = 96
          HeaderGlyph.Data = {
            89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
            6100000006624B474400FF00FF00FFA0BDA793000001464944415438116360A0
            1030C2F4D7EC79120262B3304B6F687064FC0362138399E08AFEFFD7F9CFF07F
            FAEFBF4FEE54ED7E5C5A71F8A1205C0E0F0361005011E37F86A98C8CFF9D9918
            1984997F325FAFDEF37855EDBEC7E640299C88055DA6C559EE2E50ACA2ECC8EB
            56D61F3F23FFFDFB37BF66F7A377FF999826B23249AF47F71E8A0B801AE1A8CB
            46F473AB8BCC2C5666593D0646A6090CFF19F27EFF7D7C091856E90D9B9F71C1
            14E23400A6009566E4028613FF4FCE7F9C30710C2FC0241AF63F91F9F3F77F0E
            3050E38062471819981A5B9CA5F732000309C887230C03AAF73EB562F8FFAFE0
            F7DFFFB6C0385E08546F0B0D17B82664068A01FF1919B2819A6381CE9CC6C6FC
            37ADC151F103B2626C6C540318FEAF653B229BD5D0C0F80F9B626C622881C8F4
            9FF105299A4106A21800122015536C003C0CFE33FCDB43AAED54510F00C0DA6E
            D422BD1CEF0000000049454E44AE426082}
          Options.Sorting = False
          Width = 24
          Position.BandIndex = 0
          Position.ColIndex = 4
          Position.RowIndex = 0
          IsCaptionAssigned = True
        end
        object V1shoes_rent_yn: TcxGridDBBandedColumn
          DataBinding.FieldName = 'shoes_rent_yn'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Images = BPDM.imlIcon16
          Properties.Items = <
            item
              ImageIndex = 13
              Value = True
            end>
          HeaderAlignmentHorz = taCenter
          HeaderGlyph.SourceDPI = 96
          HeaderGlyph.Data = {
            89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
            6100000006624B474400FF00FF00FFA0BDA7930000021F494441543811AD524D
            68135110FEE6ED265651BCDB86543C080AFE82A0682131AD15BDC4532F3928E2
            C14341282DAE3D6C3546AB82A0080AAD20D44BBD48D04B9350C4D48BD48B3F37
            AB34A9E2CFA5972626BB6F9CB721901C028A2E3B6F67E6FBBE6166DE02FFF8D0
            DFE8C7721F37DB2A9C62A05A598FC7B70F452AEA4F0B38B9F2098BC2EFC08893
            4672C31A1E19AD6D8E4E369E2F5D1741D5E04C9CD25A0D6506BA17465E7CDEDA
            55B73F987C5B0167AEBC8714CF08B0831897A5D53102262486C7B57D9303DB56
            C14CEB0A2B530C0E0ADB066C9A227D90415D60DD97EE8F169D42A9723511996C
            E2EEFCF78DB5FCCA3414EF254D8EC9B7EDC05E883C006889C8DA69C0CCD186D8
            75598DE7CBB7EAFEAF6552D80ECDAFD389EEFB861314182DFED86402AFAF3C08
            F06E8DDA531337AD76A47C465A8E33618698D742553B0992218540EE3CDB75BF
            FCD3F8624B4AE9B357E2D145F183F752A1744016F95C31A6342119B2ACC36E6C
            8BE107B87263E489F79240A3A162CFFE56B1935F1E025396806911A7C8F78FB7
            8A4587600421DC93162F7C39B96899A43BFB3E2C0BBC23452714FBC3721BA741
            38953ED6FBC9E0AD26DA46E8E44B4F24781BB2E8A1E7F3AC06BEB1655D54BE3F
            47A0F3E944CFB306B3FD0C3A08529E3F2CDF73758FDF30235B271E1171961837
            3B8985DF18C13899C1DEAFCCDADCAD8CC1D130D32BD9FA8D747FE4AEC13B9974
            DD0EC928BBA4AD980F9DBB968806BF6B3BE33F47BF01FFA9D0FC5C3F687C0000
            000049454E44AE426082}
          Width = 24
          Position.BandIndex = 0
          Position.ColIndex = 5
          Position.RowIndex = 0
          IsCaptionAssigned = True
        end
        object V1bowler_seq: TcxGridDBBandedColumn
          Caption = #49692#48264
          DataBinding.FieldName = 'bowler_seq'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Options.Sorting = False
          Width = 46
          Position.BandIndex = 0
          Position.ColIndex = 6
          Position.RowIndex = 0
        end
        object V1calc_bowler_nm: TcxGridDBBandedColumn
          Caption = #48380#47084#47749
          DataBinding.FieldName = 'calc_bowler_nm'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 160
          Position.BandIndex = 0
          Position.ColIndex = 7
          Position.RowIndex = 0
        end
        object V1handy: TcxGridDBBandedColumn
          Caption = #54648#46356
          DataBinding.FieldName = 'handy'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 8
          Position.RowIndex = 0
        end
        object V1prod_nm: TcxGridDBBandedColumn
          Caption = #49345#54408#47749
          DataBinding.FieldName = 'prod_nm'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 160
          Position.BandIndex = 0
          Position.ColIndex = 9
          Position.RowIndex = 0
        end
        object V1calc_game_div: TcxGridDBBandedColumn
          Caption = #50836#44552#51228
          DataBinding.FieldName = 'calc_game_div'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 76
          Position.BandIndex = 0
          Position.ColIndex = 10
          Position.RowIndex = 0
        end
        object V1calc_payment_type: TcxGridDBBandedColumn
          Caption = #44208#51228' '#48169#48277
          DataBinding.FieldName = 'calc_payment_type'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 75
          Position.BandIndex = 0
          Position.ColIndex = 11
          Position.RowIndex = 0
        end
        object V1expected_end_datetime: TcxGridDBBandedColumn
          Caption = #50696#49345' '#51333#47308' '#49884#44033
          DataBinding.FieldName = 'expected_end_datetime'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 200
          Position.BandIndex = 0
          Position.ColIndex = 12
          Position.RowIndex = 0
        end
        object V1league_yn: TcxGridDBBandedColumn
          Caption = #47532#44536
          DataBinding.FieldName = 'league_yn'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.Alignment = taCenter
          Properties.NullStyle = nssUnchecked
          Properties.ValueChecked = 'Y'
          Properties.ValueUnchecked = 'N'
          HeaderAlignmentHorz = taCenter
          Width = 50
          Position.BandIndex = 0
          Position.ColIndex = 13
          Position.RowIndex = 0
        end
        object V1calc_assign_status: TcxGridDBBandedColumn
          Caption = #49345#53468
          DataBinding.FieldName = 'calc_assign_status'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 100
          Position.BandIndex = 0
          Position.ColIndex = 14
          Position.RowIndex = 0
        end
        object V1calc_receipt_no: TcxGridDBBandedColumn
          Caption = #51452#47928#48264#54840
          DataBinding.FieldName = 'calc_receipt_no'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 0
          Width = 80
          Position.BandIndex = 0
          Position.ColIndex = 15
          Position.RowIndex = 0
        end
        object V1game_cnt: TcxGridDBBandedColumn
          Caption = #44172#51076#49688
          DataBinding.FieldName = 'game_cnt'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 70
          Position.BandIndex = 0
          Position.ColIndex = 16
          Position.RowIndex = 0
        end
        object V1game_min: TcxGridDBBandedColumn
          Caption = #44172#51076#49884#44036
          DataBinding.FieldName = 'game_min'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 70
          Position.BandIndex = 0
          Position.ColIndex = 17
          Position.RowIndex = 0
        end
        object V1game_fin: TcxGridDBBandedColumn
          Caption = #50756#47308#44172#51076
          DataBinding.FieldName = 'game_fin'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 70
          Position.BandIndex = 0
          Position.ColIndex = 18
          Position.RowIndex = 0
        end
        object V1lane_no: TcxGridDBBandedColumn
          Caption = #47112#51064
          DataBinding.FieldName = 'lane_no'
          DataBinding.IsNullValueType = True
          HeaderAlignmentHorz = taCenter
          MinWidth = 0
          Width = 0
          Position.BandIndex = 0
          Position.ColIndex = 19
          Position.RowIndex = 0
        end
      end
      object L1: TcxGridLevel
        GridView = V1
      end
    end
    object panReserveControl: TPanel
      Left = 1552
      Top = 54
      Width = 143
      Height = 204
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      object btnGameMenu13: TBitBtn
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 138
        Height = 45
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actAssignRefresh
        Align = alTop
        Caption = #49352#47196' '#44256#52840
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object btnGameMenu16: TBitBtn
        AlignWithMargins = True
        Left = 5
        Top = 149
        Width = 138
        Height = 45
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Action = actReceiptList
        Align = alTop
        Caption = #44144#47000' '#45236#50669#13#10#51312#54924
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object btnGameMenu14: TBitBtn
        AlignWithMargins = True
        Left = 5
        Top = 50
        Width = 138
        Height = 45
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actAssignListAll
        Align = alTop
        Caption = #51204#52404' '#48372#44592#13#10'(Esc)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object btnGameMenu15: TBitBtn
        AlignWithMargins = True
        Left = 5
        Top = 100
        Width = 138
        Height = 44
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 5
        Action = actRallyMode
        Align = alTop
        Caption = #45824#54924' '#44288#47532
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
    end
  end
  object sbxLaneView: TScrollBox
    Left = 0
    Top = 50
    Width = 1700
    Height = 714
    HorzScrollBar.Visible = False
    VertScrollBar.Increment = 64
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 1
    OnMouseWheel = sbxLaneViewMouseWheel
  end
  object panMiniMap: TPanel
    Left = 0
    Top = 0
    Width = 1700
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Padding.Left = 5
    Padding.Right = 5
    Padding.Bottom = 5
    TabOrder = 2
    object btnLaneSelectAll: TBitBtn
      AlignWithMargins = True
      Left = 1449
      Top = 5
      Width = 120
      Height = 40
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 0
      Action = actLaneSelectAll
      Align = alRight
      Caption = #51204#52404' '#49440#53469
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      Images = BPDM.imlIcon32
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object btnLaneRefresh: TBitBtn
      AlignWithMargins = True
      Left = 1574
      Top = 5
      Width = 120
      Height = 40
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 1
      Margins.Bottom = 0
      Action = actGameRefresh
      Align = alRight
      Caption = #49352#47196' '#44256#52840
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      Images = BPDM.imlIcon32
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object btnLaneSelectClear: TBitBtn
      AlignWithMargins = True
      Left = 1324
      Top = 5
      Width = 120
      Height = 40
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 0
      Action = actLaneSelectClear
      Align = alRight
      Caption = #49440#53469' '#52712#49548
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      Images = BPDM.imlIcon32
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object aclLaneMenu: TActionList
    Images = BPDM.imlIcon32
    Left = 256
    Top = 280
    object actPinSetterOn: TAction
      Category = 'GameMenu'
      Caption = #54592' '#49464#53552' On'
      ImageIndex = 43
      ImageName = 'ToggleOn_32px'
      OnExecute = actPinSetterOnExecute
    end
    object actPinSetterOff: TAction
      Category = 'GameMenu'
      Caption = #54592' '#49464#53552' Off'
      ImageIndex = 44
      ImageName = 'ToggleOff_32px'
      OnExecute = actPinSetterOffExecute
    end
    object actMonitorOn: TAction
      Category = 'GameMenu'
      Caption = #47784#45768#53552' On'
      ImageIndex = 43
      ImageName = 'ToggleOn_32px'
      OnExecute = actMonitorOnExecute
    end
    object actMonitorOff: TAction
      Category = 'GameMenu'
      Caption = #47784#45768#53552' Off'
      ImageIndex = 44
      ImageName = 'ToggleOff_32px'
      OnExecute = actMonitorOffExecute
    end
    object actLaneAssign: TAction
      Category = 'GameMenu'
      Caption = #48176#51221' '#46321#47197
      ImageIndex = 27
      ImageName = 'Task_32px'
      ShortCut = 115
      OnExecute = actLaneAssignExecute
    end
    object actOpenGame: TAction
      Category = 'GameMenu'
      Caption = #50724#54536' '#44172#51076
      ImageIndex = 21
      ImageName = 'BowlingBall_32px'
      OnExecute = actOpenGameExecute
    end
    object actLeagueGame: TAction
      Category = 'GameMenu'
      Caption = #47532#44536' '#44172#51076
      ImageIndex = 30
      ImageName = 'FlipVertical_32px'
      OnExecute = actLeagueGameExecute
    end
    object actGameNext: TAction
      Category = 'GameMenu'
      Caption = #44172#51076' '#45349#49828#53944
      ImageIndex = 31
      ImageName = 'Next_32px'
      OnExecute = actGameNextExecute
    end
    object actLaneClear: TAction
      Category = 'GameMenu'
      Caption = #47112#51064' '#52488#44592#54868
      ImageIndex = 32
      ImageName = 'InitialState_32px'
      OnExecute = actLaneClearExecute
    end
    object actLaneControl: TAction
      Category = 'GameMenu'
      Caption = #47112#51064' '#51228#50612
      ImageIndex = 29
      ImageName = 'Support_32px'
      OnExecute = actLaneControlExecute
    end
    object actLaneSelectClear: TAction
      Category = 'BaseMenu'
      Caption = #49440#53469' '#52712#49548
      Hint = #47112#51064' '#49440#53469' '#52488#44592#54868
      ImageIndex = 49
      ImageName = 'cancel_32px'
      OnExecute = actLaneSelectClearExecute
    end
    object actLaneSelectAll: TAction
      Category = 'BaseMenu'
      Caption = #51204#52404' '#49440#53469
      ImageIndex = 52
      ImageName = 'double_tick_32px'
      OnExecute = actLaneSelectAllExecute
    end
    object actGameRefresh: TAction
      Category = 'BaseMenu'
      Caption = #49352#47196' '#44256#52840
      Hint = #47112#51064' '#49345#54889' '#49352#47196' '#44256#52840
      ImageIndex = 50
      ImageName = 'refresh_32px'
      OnExecute = actGameRefreshExecute
    end
    object actPinSetting1: TAction
      Category = 'GameMenu'
      Caption = #54592' '#49464#54021' 1'
      ImageIndex = 60
      ImageName = '1st_32px'
      OnExecute = actPinSetting1Execute
    end
    object actPinSetting2: TAction
      Category = 'GameMenu'
      Caption = #54592' '#49464#54021' 2'
      ImageIndex = 61
      ImageName = 'circled_2_32px'
      OnExecute = actPinSetting2Execute
    end
    object actAssignRefresh: TAction
      Category = 'GameMenu'
      Caption = #49352#47196' '#44256#52840
      Hint = #48176#51221' '#54788#54889' '#49352#47196' '#44256#52840
      ImageIndex = 50
      ImageName = 'refresh_32px'
      OnExecute = actAssignRefreshExecute
    end
    object actAssignListAll: TAction
      Category = 'GameMenu'
      Caption = #51204#52404' '#48372#44592
      ImageIndex = 25
      ImageName = 'Restart_32px'
      OnExecute = actAssignListAllExecute
    end
    object actRallyMode: TAction
      Category = 'GameMenu'
      Caption = #45824#54924' '#44288#47532
      ImageIndex = 56
      ImageName = 'trophy_32px'
      OnExecute = actRallyModeExecute
    end
    object actReceiptList: TAction
      Category = 'GameMenu'
      Caption = #44144#47000' '#45236#50669
      ImageIndex = 34
      ImageName = 'Receipt_32px'
      OnExecute = actReceiptListExecute
    end
  end
  object dsrAssignList: TDataSource
    DataSet = BPDM.QRAssignList
    Left = 392
    Top = 928
  end
  object tmrRunOnce: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrRunOnceTimer
    Left = 256
    Top = 226
  end
  object LanePopupMenu: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = LanePopupMenuPopup
    Left = 248
    Top = 928
    object mniGameAssign: TMenuItem
      Caption = #48176#51221' '#44288#47532
      OnClick = mniGameAssignClick
    end
    object mniSaleView: TMenuItem
      Caption = #54032#47588' '#44288#47532
      OnClick = mniSaleViewClick
    end
    object mniSetChangePaid: TMenuItem
      Caption = #44208#51228' '#50756#47308' '#52376#47532
      ImageIndex = 48
      ImageName = 'Cash_32px'
      OnClick = mniSetChangePaidClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniScoreEdit: TMenuItem
      Caption = #51216#49688' '#49688#51221
      OnClick = mniScoreEditClick
    end
    object mniLaneHold: TMenuItem
      Caption = #51076#49884' '#50696#50557
      OnClick = mniLaneHoldClick
    end
    object mniGameCancel: TMenuItem
      Caption = #44172#51076' '#52712#49548
      OnClick = mniGameCancelClick
    end
    object mniLeagueMode: TMenuItem
      Caption = #47532#44536' '#44172#51076#51004#47196' '#51204#54872
      OnClick = mniLeagueModeClick
    end
    object mniGameNext: TMenuItem
      Caption = #44172#51076' '#45349#49828#53944
      OnClick = mniGameNextClick
    end
    object mniBowlerPause: TMenuItem
      Caption = #48380#47084' '#51068#49884#51221#51648
      OnClick = mniBowlerPauseClick
    end
    object mniLaneControl: TMenuItem
      Caption = #47112#51064' '#51228#50612
      object mniPinSetterOn: TMenuItem
        Caption = #54592' '#49464#53552' On'
        OnClick = mniPinSetterOnClick
      end
      object mniPinSetterOff: TMenuItem
        Caption = #54592' '#49464#53552' Off'
        OnClick = mniPinSetterOffClick
      end
      object mniMonitorOn: TMenuItem
        Caption = #44592#44228' On'
        OnClick = mniMonitorOnClick
      end
      object mniMonitorOff: TMenuItem
        Caption = #44592#44228' Off'
        OnClick = mniMonitorOffClick
      end
      object mniPinSetting1: TMenuItem
        Caption = #54592' '#49464#54021' #1'
        OnClick = mniPinSetting1Click
      end
      object mniPinSetting2: TMenuItem
        Caption = #54592' '#49464#54021' #2'
        OnClick = mniPinSetting2Click
      end
      object mniLaneInit: TMenuItem
        Caption = #47112#51064' '#52488#44592#54868
        OnClick = mniLaneInitClick
      end
      object mniLaneCheck: TMenuItem
        Caption = #47112#51064' '#51216#44160
        OnClick = mniLaneCheckClick
      end
    end
  end
end
