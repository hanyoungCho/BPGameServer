object BPMemberForm: TBPMemberForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 630
  ClientWidth = 800
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = PluginModuleClose
  OnKeyDown = PluginModuleKeyDown
  OnShow = PluginModuleShow
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
    Caption = #54924#50896' '#46321#47197'/'#51312#54924'/'#49688#51221
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
  object pgcMember: TPageControl
    AlignWithMargins = True
    Left = 5
    Top = 43
    Width = 790
    Height = 582
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ActivePage = tabMemberList
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object tabMemberList: TTabSheet
      Caption = #54924#50896'  '#47785#47197
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object panMemberListHeader: TPanel
        Left = 0
        Top = 0
        Width = 782
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object lblSearchTitle: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 6
          Width = 70
          Height = 29
          Margins.Top = 6
          Margins.Right = 5
          Margins.Bottom = 6
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #44160#49353' '#51312#44148
          Color = 5393480
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = False
          Layout = tlCenter
          StyleElements = []
          ExplicitTop = 3
          ExplicitHeight = 35
        end
        object edtSearchMemberName: TDBEditEh
          Left = 122
          Top = 7
          Width = 129
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          Color = clInfoBk
          ControlLabel.Width = 39
          ControlLabel.Height = 18
          ControlLabel.Caption = #54924#50896#47749
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          ImeMode = imSHanguel
          TabOrder = 0
          Visible = True
          OnKeyDown = edtSearchMemberNameKeyDown
          EditMask = ''
        end
        object edtSearchMemberTelNo: TDBEditEh
          Left = 314
          Top = 7
          Width = 130
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          Color = clInfoBk
          ControlLabel.Width = 52
          ControlLabel.Height = 18
          ControlLabel.Caption = #51204#54868#48264#54840
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          ImeMode = imSAlpha
          TabOrder = 1
          Visible = True
          OnKeyDown = edtSearchMemberTelNoKeyDown
          EditMask = ''
        end
        object btnSearchMember: TBitBtn
          AlignWithMargins = True
          Left = 554
          Top = 5
          Width = 110
          Height = 31
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 0
          Margins.Bottom = 5
          Align = alRight
          Caption = #54924#50896' '#44160#49353
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 3
          ImageName = 'find_user_male_16px'
          Images = BPDM.imlIcon16
          ParentFont = False
          TabOrder = 2
          WordWrap = True
          OnClick = btnSearchMemberClick
        end
        object btnSearchClear: TBitBtn
          AlignWithMargins = True
          Left = 669
          Top = 5
          Width = 110
          Height = 31
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 5
          Margins.Bottom = 5
          Align = alRight
          Caption = #44160#49353' '#52488#44592#54868
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 5
          ImageName = 'close_16px'
          Images = BPDM.imlIcon16
          ParentFont = False
          TabOrder = 3
          WordWrap = True
          OnClick = btnSearchClearClick
        end
      end
      object panMemberListToolbar: TPanel
        Left = 0
        Top = 489
        Width = 782
        Height = 60
        Align = alBottom
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        object btnRefreshMemberList: TBitBtn
          AlignWithMargins = True
          Left = 34
          Top = 5
          Width = 110
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = #49352#47196' '#44256#52840
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 50
          ImageName = 'refresh_32px'
          Images = BPDM.imlIcon32
          ParentFont = False
          TabOrder = 0
          WordWrap = True
          OnClick = btnRefreshMemberListClick
        end
        object btnGotoAddMember: TBitBtn
          AlignWithMargins = True
          Left = 149
          Top = 5
          Width = 110
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = #49888#44508' '#46321#47197
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          WordWrap = True
          OnClick = btnGotoAddMemberClick
        end
        object btnGotoEditMember: TBitBtn
          AlignWithMargins = True
          Left = 264
          Top = 5
          Width = 110
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = #51221#48372' '#49688#51221
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          WordWrap = True
          OnClick = btnGotoEditMemberClick
        end
        object btnSelectMember: TBitBtn
          AlignWithMargins = True
          Left = 379
          Top = 5
          Width = 140
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = #54924#50896' '#49440#53469#13#10'(Enter)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 59
          ImageName = 'done_32px'
          Images = BPDM.imlIcon32
          ParentFont = False
          TabOrder = 3
          WordWrap = True
          OnClick = btnSelectMemberClick
        end
        object btnSelectMembership: TBitBtn
          AlignWithMargins = True
          Left = 524
          Top = 5
          Width = 110
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = #51201#50857
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          WordWrap = True
          OnClick = btnSelectMembershipClick
        end
        object btnSelectLocker: TBitBtn
          AlignWithMargins = True
          Left = 639
          Top = 5
          Width = 110
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = #46972#52964#49345#54408' '#49440#53469
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          WordWrap = True
          OnClick = btnSelectLockerClick
        end
      end
      object G1: TcxGrid
        AlignWithMargins = True
        Left = 3
        Top = 41
        Width = 776
        Height = 189
        Margins.Top = 0
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
        LookAndFeel.Kind = lfUltraFlat
        LookAndFeel.NativeStyle = False
        LookAndFeel.ScrollbarMode = sbmTouch
        LookAndFeel.ScrollMode = scmSmooth
        object V1: TcxGridDBBandedTableView
          OnDblClick = V1DblClick
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          OnFocusedRecordChanged = V1FocusedRecordChanged
          DataController.DataSource = dsrMemberList
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
          OptionsView.BandHeaders = False
          Styles.Header = BPDM.StyleHeader1
          Styles.Inactive = BPDM.StyleSelection
          Styles.Indicator = BPDM.StyleHeader1
          Styles.Selection = BPDM.StyleSelection
          Styles.BandHeader = BPDM.StyleHeader1
          Bands = <
            item
            end>
          object V1member_nm: TcxGridDBBandedColumn
            Caption = #54924#50896#47749
            DataBinding.FieldName = 'member_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            Width = 120
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V1tel_no: TcxGridDBBandedColumn
            Caption = #51204#54868#48264#54840
            DataBinding.FieldName = 'calc_tel_no'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 150
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V1car_no: TcxGridDBBandedColumn
            Caption = #52264#47049#48264#54840
            DataBinding.FieldName = 'car_no'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 102
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object V1calc_sex_div: TcxGridDBBandedColumn
            Caption = #49457#48324
            DataBinding.FieldName = 'sex_div_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 63
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object V1birthday: TcxGridDBBandedColumn
            Caption = #49373#45380#50900#51068
            DataBinding.FieldName = 'birthday'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 120
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object V1member_group_nm: TcxGridDBBandedColumn
            Caption = #44256#44061#44396#48516
            DataBinding.FieldName = 'member_group_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object V1club_nm: TcxGridDBBandedColumn
            Caption = #53364#47101#47749
            DataBinding.FieldName = 'club_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 200
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object V1save_point: TcxGridDBBandedColumn
            Caption = #51201#47549' '#54252#51064#53944
            DataBinding.FieldName = 'save_point'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.DisplayFormat = ',0 ; -,0 '
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
        end
        object L1: TcxGridLevel
          GridView = V1
        end
      end
      object G2: TcxGrid
        AlignWithMargins = True
        Left = 3
        Top = 233
        Width = 776
        Height = 150
        Margins.Top = 0
        Align = alBottom
        BevelInner = bvNone
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        LookAndFeel.Kind = lfUltraFlat
        LookAndFeel.NativeStyle = False
        LookAndFeel.ScrollbarMode = sbmTouch
        LookAndFeel.ScrollMode = scmSmooth
        object V2: TcxGridDBBandedTableView
          OnDblClick = V2DblClick
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          OnCustomDrawCell = V2CustomDrawCell
          DataController.DataSource = dsrMembership
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
          OptionsView.BandHeaders = False
          Styles.Header = BPDM.StyleHeader1
          Styles.Inactive = BPDM.StyleSelection
          Styles.Indicator = BPDM.StyleHeader1
          Styles.Selection = BPDM.StyleSelection
          Styles.BandHeader = BPDM.StyleHeader1
          Bands = <
            item
            end>
          object V2prod_nm: TcxGridDBBandedColumn
            Caption = #49345#54408#47749
            DataBinding.FieldName = 'prod_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Vert = taVCenter
            Width = 177
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V2calc_game_div: TcxGridDBBandedColumn
            Caption = #50836#44552#51228
            DataBinding.FieldName = 'calc_game_div'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V2calc_purchase: TcxGridDBBandedColumn
            Caption = #44396#47588
            DataBinding.FieldName = 'calc_purchase'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object V2calc_remain: TcxGridDBBandedColumn
            Caption = #51092#50668
            DataBinding.FieldName = 'calc_remain'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object V2start_dt: TcxGridDBBandedColumn
            Caption = #49884#51089#51068
            DataBinding.FieldName = 'start_dt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object V2end_dt: TcxGridDBBandedColumn
            Caption = #51333#47308#51068
            DataBinding.FieldName = 'end_dt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object V2shoes_free_yn: TcxGridDBBandedColumn
            Caption = #47924#47308#45824#54868
            DataBinding.FieldName = 'shoes_free_yn'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.Alignment = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 70
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object V2calc_use_status: TcxGridDBBandedColumn
            Caption = #51060#50857' '#49345#53468
            DataBinding.FieldName = 'calc_use_status'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 80
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object V2use_status: TcxGridDBBandedColumn
            DataBinding.FieldName = 'use_status'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
        end
        object L2: TcxGridLevel
          GridView = V2
        end
      end
      object G3: TcxGrid
        AlignWithMargins = True
        Left = 3
        Top = 386
        Width = 776
        Height = 100
        Margins.Top = 0
        Align = alBottom
        BevelInner = bvNone
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        LookAndFeel.Kind = lfUltraFlat
        LookAndFeel.NativeStyle = False
        LookAndFeel.ScrollbarMode = sbmTouch
        LookAndFeel.ScrollMode = scmSmooth
        object V3: TcxGridDBBandedTableView
          OnDblClick = V3DblClick
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          OnCustomDrawCell = V3CustomDrawCell
          DataController.DataSource = dsrMemberLocker
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
          OptionsView.BandHeaders = False
          Styles.Header = BPDM.StyleHeader1
          Styles.Inactive = BPDM.StyleSelection
          Styles.Indicator = BPDM.StyleHeader1
          Styles.Selection = BPDM.StyleSelection
          Styles.BandHeader = BPDM.StyleHeader1
          Bands = <
            item
            end>
          object V3locker_nm: TcxGridDBBandedColumn
            Caption = #46972#52964#47749
            DataBinding.FieldName = 'locker_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Vert = taVCenter
            Width = 169
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V3calc_locker_zone_code: TcxGridDBBandedColumn
            Caption = #44396#50669
            DataBinding.FieldName = 'calc_locker_zone_code'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 121
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V3calc_locker_layer_code: TcxGridDBBandedColumn
            Caption = #45800
            DataBinding.FieldName = 'calc_locker_layer_code'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 121
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object V3start_dt: TcxGridDBBandedColumn
            Caption = #49884#51089#51068
            DataBinding.FieldName = 'start_dt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 121
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object V3end_dt: TcxGridDBBandedColumn
            Caption = #51333#47308#51068
            DataBinding.FieldName = 'end_dt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 144
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object V3calc_locker_status: TcxGridDBBandedColumn
            Caption = #51060#50857' '#49345#53468
            DataBinding.FieldName = 'calc_locker_status'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 80
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object V3locker_status: TcxGridDBBandedColumn
            DataBinding.FieldName = 'locker_status'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
        end
        object L3: TcxGridLevel
          GridView = V3
        end
      end
    end
    object tabMemberInfo: TTabSheet
      Caption = #54924#50896' '#51221#48372
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      object panMemberEditToolbar: TPanel
        Left = 0
        Top = 489
        Width = 782
        Height = 60
        Align = alBottom
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Padding.Bottom = 5
        ParentFont = False
        TabOrder = 23
        object btnFPHash: TBitBtn
          AlignWithMargins = True
          Left = 451
          Top = 5
          Width = 110
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = #51648#47928' '#46321#47197
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          WordWrap = True
          OnClick = btnFPHashClick
        end
        object btnGotoMemberList: TBitBtn
          AlignWithMargins = True
          Left = 106
          Top = 5
          Width = 110
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = #54924#50896' '#47785#47197
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 10
          ImageName = 'FindUserMale_32px'
          Images = BPDM.imlIcon32
          ParentFont = False
          TabOrder = 0
          WordWrap = True
          OnClick = btnGotoMemberListClick
        end
        object btnEditMember: TBitBtn
          AlignWithMargins = True
          Left = 336
          Top = 5
          Width = 110
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = #51221#48372' '#49688#51221
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 10
          ParentFont = False
          TabOrder = 2
          WordWrap = True
          OnClick = btnEditMemberClick
        end
        object btnSaveMember: TBitBtn
          AlignWithMargins = True
          Left = 566
          Top = 5
          Width = 110
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = #51200#51109
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 57
          ImageName = 'save_32px'
          Images = BPDM.imlIcon32
          ParentFont = False
          TabOrder = 4
          WordWrap = True
          OnClick = btnSaveMemberClick
        end
        object btnAddMember: TBitBtn
          AlignWithMargins = True
          Left = 221
          Top = 5
          Width = 110
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = #49888#44508' '#46321#47197
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          WordWrap = True
          OnClick = btnAddMemberClick
        end
      end
      object btnMemberZipNo: TBitBtn
        Left = 337
        Top = 210
        Width = 130
        Height = 28
        Caption = #51452#49548#44160#49353'(F8)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 12
        OnClick = btnMemberZipNoClick
      end
      object btnPrintQRCode: TBitBtn
        Left = 474
        Top = 382
        Width = 218
        Height = 28
        Caption = #54924#50896' QR'#53076#46300' '#51064#49604
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 22
      end
      object btnSendQRCode: TBitBtn
        Left = 474
        Top = 348
        Width = 218
        Height = 28
        Caption = #54924#50896' QR'#53076#46300' '#48156#49569
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 21
      end
      object ckbMemberAdAgree: TDBCheckBoxEh
        Left = 481
        Top = 18
        Width = 130
        Height = 17
        Caption = #44305#44256' '#49688#49888' '#46041#51032
        DynProps = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 18
      end
      object edtMemberAddr: TDBEditEh
        Left = 127
        Top = 244
        Width = 340
        Height = 27
        Alignment = taLeftJustify
        AutoSize = False
        ControlLabel.Width = 26
        ControlLabel.Height = 18
        ControlLabel.Caption = #51452#49548
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = #51452#49548
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        MaxLength = 100
        ParentFont = False
        TabOrder = 13
        Visible = True
        EditMask = ''
      end
      object edtMemberAddr2: TDBEditEh
        Left = 127
        Top = 277
        Width = 340
        Height = 27
        Alignment = taLeftJustify
        AutoSize = False
        ControlLabel.Width = 52
        ControlLabel.Height = 18
        ControlLabel.Caption = #49345#49464#51452#49548
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = #49345#49464#51452#49548
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        MaxLength = 100
        ParentFont = False
        TabOrder = 14
        Visible = True
        EditMask = ''
      end
      object edtMemberBirthday: TDBEditEh
        Left = 127
        Top = 145
        Width = 130
        Height = 27
        Alignment = taLeftJustify
        AutoSize = False
        ControlLabel.Width = 52
        ControlLabel.Height = 18
        ControlLabel.Caption = #49373#45380#50900#51068
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = 'yyyy-mm-dd'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        TabOrder = 7
        Visible = True
        EditMask = ''
      end
      object edtMemberCarNo: TDBEditEh
        Left = 337
        Top = 79
        Width = 130
        Height = 27
        Alignment = taLeftJustify
        AutoSize = False
        ControlLabel.Width = 52
        ControlLabel.Height = 18
        ControlLabel.Caption = #52264#47049#48264#54840
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = #52264#47049#48264#54840
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        MaxLength = 20
        ParentFont = False
        TabOrder = 4
        Visible = True
        EditMask = ''
      end
      object edtMemberEmail: TDBEditEh
        Left = 127
        Top = 178
        Width = 339
        Height = 27
        Alignment = taLeftJustify
        AutoSize = False
        CharCase = ecLowerCase
        ControlLabel.Width = 39
        ControlLabel.Height = 18
        ControlLabel.Caption = #51060#47700#51068
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = #51060#47700#51068
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        MaxLength = 50
        ParentFont = False
        TabOrder = 9
        Visible = True
        EditMask = ''
      end
      object edtMemberFPHash: TDBEditEh
        Left = 127
        Top = 433
        Width = 340
        Height = 27
        Alignment = taLeftJustify
        AutoSize = False
        ControlLabel.Width = 65
        ControlLabel.Height = 18
        ControlLabel.Caption = #51648#47928#49885#48324#44050
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = #51648#47928' '#54644#49772
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        MaxLength = 500
        ParentFont = False
        TabOrder = 17
        Visible = True
        EditMask = ''
      end
      object edtMemberName: TDBEditEh
        Left = 127
        Top = 13
        Width = 130
        Height = 27
        Alignment = taLeftJustify
        AutoSize = False
        ControlLabel.Width = 39
        ControlLabel.Height = 18
        ControlLabel.Caption = #54924#50896#47749
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = #54924#50896#47749
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ImeMode = imSHanguel
        MaxLength = 30
        ParentFont = False
        TabOrder = 0
        Visible = True
        EditMask = ''
      end
      object edtMemberNo: TDBEditEh
        Left = 337
        Top = 13
        Width = 130
        Height = 27
        TabStop = False
        Alignment = taLeftJustify
        AutoSize = False
        ControlLabel.Width = 52
        ControlLabel.Height = 18
        ControlLabel.Caption = #54924#50896#48264#54840
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = #54924#50896#48264#54840
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        Visible = True
        EditMask = ''
      end
      object edtMemberSavePoint: TDBNumberEditEh
        Left = 337
        Top = 144
        Width = 130
        Height = 27
        ControlLabel.Width = 69
        ControlLabel.Height = 18
        ControlLabel.Caption = #51201#47549' '#54252#51064#53944
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        Alignment = taRightJustify
        AutoSize = False
        DynProps = <>
        EmptyDataInfo.Text = #54252#51064#53944
        EmptyDataInfo.Alignment = taRightJustify
        EditButtons = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        Value = 0.000000000000000000
        Visible = True
      end
      object edtMemberTelNo: TDBEditEh
        Left = 127
        Top = 79
        Width = 129
        Height = 27
        Alignment = taLeftJustify
        AutoSize = False
        ControlLabel.Width = 52
        ControlLabel.Height = 18
        ControlLabel.Caption = #51204#54868#48264#54840
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = #51204#54868#48264#54840
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ImeMode = imSAlpha
        MaxLength = 11
        ParentFont = False
        TabOrder = 3
        Visible = True
        OnKeyPress = edtMemberTelNoKeyPress
        EditMask = ''
      end
      object edtMemberZipNo: TDBEditEh
        Left = 127
        Top = 211
        Width = 89
        Height = 27
        Alignment = taLeftJustify
        AutoSize = False
        ControlLabel.Width = 52
        ControlLabel.Height = 18
        ControlLabel.Caption = #50864#54200#48264#54840
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = #50864#54200#48264#54840
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        MaxLength = 5
        ParentFont = False
        TabOrder = 10
        Visible = True
        EditMask = ''
      end
      object gbxMemberPhoto: TGroupBox
        Left = 475
        Top = 42
        Width = 216
        Height = 233
        Caption = #54924#50896' '#49324#51652
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 19
        object imgMemberPhoto: TImage
          Left = 7
          Top = 24
          Width = 160
          Height = 200
        end
        object btnPhotoFromFile: TBitBtn
          Left = 172
          Top = 24
          Width = 38
          Height = 28
          Hint = #54924#50896' '#49324#51652' '#48520#47084' '#50724#44592
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000090000
            000E000000100000001000000010000000100000001000000011000000110000
            001100000011000000100000000B00000003000000000000000019427ACA245A
            A5FF255CA7FF255BA7FF245AA6FF2459A6FF2358A5FF2358A4FF2356A4FF2256
            A4FF2255A3FF2154A3FF2153A1FF1C468AE303080F2900000002255DA5FF316B
            AEFF6DA6D5FF86CAF0FF46A6E4FF44A3E4FF41A1E3FF3FA0E2FF3C9EE2FF3B9C
            E1FF389BE0FF369AE0FF3498DFFF2C77C1FF10284D8B000000082B68AEFF4984
            BEFF4B8BC5FFB2E3F8FF68BBECFF55B0E8FF52AEE8FF4EACE7FF4CA9E6FF49A8
            E5FF47A6E4FF44A4E4FF41A2E3FF3A92D6FF1C4885D50000000D2F6FB4FF6CA7
            D2FF3F87C4FFAED9F0FF9AD8F5FF66BDEEFF63BBEDFF60B9EBFF5DB6EBFF5BB5
            EAFF57B2EAFF55B0E9FF51AEE7FF4FABE7FF2D69B1FF040B142F3276B9FF8FC7
            E6FF509FD4FF86BCE0FFC5EFFCFF78CAF2FF74C8F1FF72C5F0FF6FC4F0FF6DC2
            EFFF69C0EEFF66BDEEFF63BBEDFF60B9EBFF448BC9FF122D4D81357CBCFFAFE3
            F5FF75C8EDFF59A2D4FFDDF7FDFFDFF8FEFFDDF7FEFFDBF7FEFFD8F5FEFFD4F4
            FDFFD0F2FDFFCCEFFCFFC7EDFBFFC1EBFBFF9ACBE9FF215187CB3882C1FFC7F5
            FEFF97E5FCFF64BAE5FF4D9FD3FF4D9DD2FF4B9BD1FF4A99CFFF4998CFFF4896
            CEFF4694CCFF4592CBFF3073B7FF3072B6FF2F71B5FF2A65A4EA3A88C5FFCDF7
            FEFFA6ECFEFF9CE8FDFF93E4FBFF8EE1FBFF89DFFBFF86DEFAFF81DAFAFF7ED8
            F9FF7BD7F9FF79D6F9FF2A6BB0FF000000140000000A000000073D8EC8FFD0F8
            FEFFAEF0FEFFAAEEFEFFA6EDFEFFA5EBFDFFBBF2FDFFD4F9FEFFD5F9FEFFD3F8
            FEFFD1F8FEFFCEF7FDFF3680BFFF0000000800000000000000003F92CBFFD3F9
            FEFFB6F3FEFFB3F1FDFFB0F1FEFFB8EDFAFF4895CBFF3B8CC6FF3B8AC6FF3A89
            C5FF3A88C5FF3A87C3FF2A6391C20000000500000000000000004197CEFFE2FC
            FEFFE2FCFEFFE1FCFEFFD4F3FAFF458FBFEC040A0E1B00000006000000060000
            000600000006000000060000000400000001000000000000000031739ABF429A
            D0FF4299D0FF4299D0FF4297CFFF153244590000000200000000000000000000
            0000000000000000000000000000000000000000000000000000000000020000
            0003000000030000000400000003000000020000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000}
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object btnPhotoClear: TBitBtn
          Left = 172
          Top = 92
          Width = 38
          Height = 28
          Hint = #51077#47141#46108' '#54924#50896' '#49324#51652' '#49325#51228
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000000000000000
            0000000000000000000200000007000000070000000400000007000000070000
            0004000000070000000700000002000000000000000000000000000000000000
            000000000000352A288A614D4AFF6B5955FF7A6865FF786865FF756460FF705D
            5AFF604D49FF5B4743FF33272687000000000000000000000000000000000000
            0000000000005C4843EAAE9E95FFB5A69EFF9C887DFFBEB1AAFFBAACA5FF957F
            74FFB2A39AFFA99990FF574540E3000000000000000000000000000000000000
            00000000000068524CFFD9CBC3FFD1C6BFFF9E8B81FFDFD3CDFFD5CAC3FF9682
            77FFD9CBC3FFCCC0B8FF67514BFF000000000000000000000000000000000000
            0000000000006A5550FFD9CBC3FFD1C6BFFFA18E83FFDFD3CDFFD4CAC3FF9A86
            7BFFD9CBC3FFCCC0B8FF69544FFF000000000000000000000000000000000000
            0000000000006E5953FFD9CBC3FFD1C6BEFFA49188FFDED3CCFFD4C9C3FF9D89
            7FFFD9CBC3FFCCC0B8FF6D5852FF000000000000000000000000000000000000
            000000000000725C56FFD8CBC3FFD1C5BEFFA6958BFFDED3CCFFD4C9C2FFA08D
            83FFD8CBC3FFCCC0B8FF715B55FF000000000000000000000000000000010000
            000100000003755F58FFD5C7BFFFCDC1BBFFA6968DFFDACFC8FFD0C5BFFFA190
            86FFD5C7BFFFC8BCB5FF745E57FF000000030000000100000001000000010000
            00030101010874605AFFCDC0B9FFC5BAB3FFA6958DFFD3C8C1FFC8BEB8FFA08F
            85FFCCBFB7FFC0B5AEFF735F59FF010101090101010400000001000000010101
            01060202020E76625BFFC1B6AFFFBAAFA9FFA3948DFFC6BBB5FFBDB3ADFF9E8F
            87FFC0B4ADFFB6ABA4FF76625BFF0202020F0101010600000002000000010101
            010669514BFF6A524CFF6B534DFF6E5751FF725B56FF735D57FF725B56FF6E57
            51FF6B534DFF6A524CFF69514BFF69514BFF0101010600000002000000010000
            00036B544DFFAB9588FFB29D91FFBFAEA4FFCEC0B9FFD3C8C1FFCEC0B9FFBFAE
            A4FFB29D91FFAB9588FFAA9386FF6B544DFF0000000300000001000000000000
            000141332E97907E78FFB0A39FFFC5BBB8FFD2CAC8FFD6D0CDFFD2CAC8FFC7BE
            BBFFBAAFABFFAA9D98FF8D7A73FF40322E950000000100000000000000000000
            00000000000055433EC46F5852FF8D7971FF8E7A72FF715B55FF715A54FF8D79
            71FF8C7870FF6E5751FF55433EC4000000000000000000000000000000000000
            0000000000000000000001010101725B55FF453836900C0C0C0C0B0B0B0B4236
            348C725B55FF0000000000000000000000000000000000000000000000000000
            00000000000000000000010101015A4844C4887570FF8F7D78FF8E7D78FF8976
            71FF594743C40000000000000000000000000000000000000000}
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = btnPhotoClearClick
        end
        object btnPhotoFromWebCam: TBitBtn
          Left = 172
          Top = 58
          Width = 38
          Height = 28
          Hint = #50937#52896#51004#47196' '#52524#50689
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000000000000000
            000000000000303030EF333333FF333333FF333333FF333333FF333333FF3333
            33FF333333FF333333FF303030EF000000000000000000000000000000000000
            000000000000282828CA2D2D2DDF2D2D2DDF2D2D2DDF333333FF333333FF3030
            30EF2D2D2DDF2D2D2DDF282828C9000000000000000000000000000000000000
            0000000000000000000000000001050505181A1A1A82333333FF333333FF1919
            197C0606061D0000000100000000000000000000000000000000000000000000
            000000000000060606201A1A1A82303030EF333333FF333333FF333333FF3131
            31F52F2F2FEB1D1D1D910606061E000000000000000000000000000000000000
            00000202020C252525BB323232FC333333FF333333FF333333FF333333FF3333
            33FF333333FF323232F9232323B0050505190000000000000000000000000202
            02081E1E1E98323232FC333333FF333333FF333333FF313131F3303030F03333
            33FF333333FF333333FF333333FF1D1D1D930202020800000000000000000909
            092F313131F3333333FF333333FF313131F4151515680606061E070707211414
            14632F2F2FE9333333FF333333FF303030F20B0B0B3700000000000000001818
            1879333333FF333333FF313131F71616166F040404121919197D1A1A1A830606
            06201616166F313131F7333333FF333333FF1818187900000000000000002323
            23AD333333FF333333FF2E2E2EE601010105232323AF313131F3333333FF2323
            23B1010101052E2E2EE4333333FF333333FF232323AD00000000000000002626
            26BC333333FF333333FF2A2A2AD4000000021C1C1C8C0C0C0C3E303030EF2929
            29CF000000012B2B2BD7333333FF333333FF262626BC00000000000000001E1E
            1E97333333FF333333FF313131F70A0A0A330606061C101010512C2C2CDC1111
            11570909092C313131F7333333FF333333FF1E1E1E9700000000000000000F0F
            0F4C333333FD333333FF333333FF272727C30A0A0A320303030F0202020B0808
            0829262626C0333333FF333333FF333333FD0F0F0F4C00000000000000000505
            051A292929CD333333FF333333FF333333FF282828C92020209E1F1F1F9D2B2B
            2BD8333333FF333333FF333333FF2B2B2BD90202020B00000000000000000000
            00000F0F0F49313131F7333333FF333333FF333333FF313131F3303030F03333
            33FF333333FF333333FF303030EE0C0C0C3E0000000000000000000000000000
            00000000000210101052282828C6323232FC1E1E1E940B0B0B360B0B0B351C1C
            1C8C333333FD292929CE10101051000000020000000000000000000000000000
            00000000000000000000080808291919197B212121A3242424B3252525BA2424
            24B21919197B0707072100000000000000000000000000000000}
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
      end
      object mmoMemberMemo: TDBMemoEh
        Left = 127
        Top = 310
        Width = 340
        Height = 84
        ControlLabel.Width = 26
        ControlLabel.Height = 18
        ControlLabel.Caption = #47700#47784
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftTopEh
        AutoSize = False
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = #47700#47784
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        MaxLength = 1000
        ParentFont = False
        TabOrder = 15
        Visible = True
        WantReturns = True
      end
      object rdgMemberSexDiv: TDBRadioGroupEh
        Left = 475
        Top = 281
        Width = 216
        Height = 61
        Caption = #49457#48324' '#44396#48516
        Columns = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Items.Strings = (
          #44277#50857
          #45224
          #50668)
        ParentBackground = True
        ParentFont = False
        TabOrder = 20
      end
      object edtMemberQRCode: TDBEditEh
        Left = 127
        Top = 400
        Width = 340
        Height = 27
        Alignment = taLeftJustify
        AutoSize = False
        ControlLabel.Width = 76
        ControlLabel.Height = 18
        ControlLabel.Caption = #54924#50896' QR'#53076#46300
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = 'QR'#53076#46300
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        MaxLength = 50
        ParentFont = False
        TabOrder = 16
        Visible = True
        EditMask = ''
      end
      object cbxMemberDiv: TDBComboBoxEh
        Left = 127
        Top = 112
        Width = 130
        Height = 27
        ControlLabel.Width = 52
        ControlLabel.Height = 18
        ControlLabel.Caption = #54924#50896#44396#48516
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        Alignment = taLeftJustify
        AutoSize = False
        DynProps = <>
        EmptyDataInfo.Text = #54924#50896#44396#48516
        EditButtons = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        Text = 'cbxMemberDiv'
        Visible = True
      end
      object cbxMemberClubSeq: TDBLookupComboboxEh
        Left = 127
        Top = 46
        Width = 340
        Height = 27
        ControlLabel.Width = 26
        ControlLabel.Height = 18
        ControlLabel.Caption = #53364#47101
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        Alignment = taLeftJustify
        AutoSize = False
        DynProps = <>
        DataField = ''
        DropDownBox.Columns = <
          item
            AutoFitColWidth = False
            FieldName = 'club_nm'
            Title.Caption = #53364#47101#47749
            Width = 100
          end
          item
            AutoFitColWidth = False
            FieldName = 'boss_nm'
            Title.Caption = #45824#54364#51088
            Width = 70
          end
          item
            AutoFitColWidth = False
            FieldName = 'tel_no'
            Title.Caption = #50672#46973#52376
            Width = 110
          end
          item
            FieldName = 'dc_rate'
            Title.Alignment = taCenter
            Title.Caption = #54624#51064#50984
          end>
        DropDownBox.ShowTitles = True
        EmptyDataInfo.Text = #53364#47101
        EditButtons = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        KeyField = 'club_seq'
        ListField = 'club_nm'
        ListSource = dsrClubList
        ParentFont = False
        TabOrder = 2
        Visible = True
      end
      object cbxMemberGroupCode: TDBLookupComboboxEh
        Left = 337
        Top = 112
        Width = 130
        Height = 27
        ControlLabel.Width = 52
        ControlLabel.Height = 18
        ControlLabel.Caption = #45800#52404#44396#48516
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        Alignment = taLeftJustify
        AutoSize = False
        DynProps = <>
        DataField = ''
        DropDownBox.Columns = <
          item
            FieldName = 'code_nm'
            Title.Caption = #44536#47353
          end>
        EmptyDataInfo.Text = #45800#52404#44396#48516
        EditButtons = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        KeyField = 'code'
        ListField = 'code_nm'
        ListSource = dsrMemberGroupList
        ParentFont = False
        TabOrder = 6
        Visible = True
      end
      object ckbUseRoadAddr: TDBCheckBoxEh
        Left = 241
        Top = 211
        Width = 90
        Height = 26
        Caption = #46020#47196#47749' '#51452#49548
        Checked = True
        DynProps = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 11
      end
    end
  end
  object dsrMemberList: TDataSource
    DataSet = BPDM.QRMemberList
    Left = 729
    Top = 145
  end
  object dsrMembership: TDataSource
    DataSet = BPDM.QRMembership
    Left = 729
    Top = 337
  end
  object dsrMemberLocker: TDataSource
    DataSet = BPDM.QRMemberLocker
    Left = 729
    Top = 481
  end
  object dsrClubList: TDataSource
    DataSet = BPDM.QRClubList
    Left = 729
    Top = 201
  end
  object dsrMemberGroupList: TDataSource
    DataSet = BPDM.QRMemberGroupList
    Left = 729
    Top = 257
  end
end
