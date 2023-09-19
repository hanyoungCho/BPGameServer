object BPRallyModeForm: TBPRallyModeForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 800
  ClientWidth = 1160
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
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
    Width = 1160
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #45824#54924' '#54788#54889' '#51312#54924
    Color = 5393480
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    StyleElements = []
    OnMouseMove = panHeaderMouseMove
    object lblPluginVersion: TLabel
      AlignWithMargins = True
      Left = 43
      Top = 5
      Width = 95
      Height = 13
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
    end
    object panHeaderToolbar: TPanel
      AlignWithMargins = True
      Left = 1125
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
  object pgcMain: TPageControl
    AlignWithMargins = True
    Left = 5
    Top = 43
    Width = 1150
    Height = 752
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ActivePage = tabSetting
    Align = alClient
    TabOrder = 1
    object tabListView: TTabSheet
      Caption = #45824#54924' '#47785#47197
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 1142
        Height = 42
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label2: TLabel
          Left = 616
          Top = 0
          Width = 48
          Height = 42
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #45824#54924#47749
          Layout = tlCenter
          ExplicitLeft = 661
          ExplicitHeight = 46
        end
        object Label3: TLabel
          Left = 0
          Top = 0
          Width = 62
          Height = 42
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #46321#47197#51068#51088
          Layout = tlCenter
        end
        object Label4: TLabel
          Left = 327
          Top = 0
          Width = 36
          Height = 42
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #53364#47101
          Layout = tlCenter
          ExplicitLeft = 372
          ExplicitHeight = 46
        end
        object Label5: TLabel
          Left = 183
          Top = 0
          Width = 20
          Height = 42
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = '~'
          Layout = tlCenter
          ExplicitLeft = 186
          ExplicitHeight = 46
        end
        object edtRallyTitle: TDBEditEh
          AlignWithMargins = True
          Left = 664
          Top = 7
          Width = 249
          Height = 28
          Margins.Left = 0
          Margins.Top = 7
          Margins.Bottom = 7
          TabStop = False
          Align = alClient
          ControlLabel.Font.Charset = DEFAULT_CHARSET
          ControlLabel.Font.Color = clWindowText
          ControlLabel.Font.Height = -12
          ControlLabel.Font.Name = 'Pretendard Variable'
          ControlLabel.Font.Style = []
          ControlLabel.ParentFont = False
          ControlLabelLocation.Spacing = 5
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #51312#54924#54624' '#45824#54924#47749' '#51077#47141
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          Visible = True
          ExplicitHeight = 26
        end
        object btnRefreshList: TBitBtn
          AlignWithMargins = True
          Left = 916
          Top = 3
          Width = 110
          Height = 36
          Cursor = crHandPoint
          Margins.Left = 0
          Align = alRight
          Caption = #51312#54924
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 10
          ImageName = 'search_16px'
          Images = BPDM.imlIcon16
          ParentFont = False
          TabOrder = 0
          OnClick = btnRefreshListClick
        end
        object edtStartDate: TDBDateTimeEditEh
          AlignWithMargins = True
          Left = 62
          Top = 7
          Width = 121
          Height = 28
          Margins.Left = 0
          Margins.Top = 7
          Margins.Right = 0
          Margins.Bottom = 7
          ControlLabel.Font.Charset = DEFAULT_CHARSET
          ControlLabel.Font.Color = clWindowText
          ControlLabel.Font.Height = -12
          ControlLabel.Font.Name = 'Pretendard Variable'
          ControlLabel.Font.Style = []
          ControlLabel.ParentFont = False
          Align = alLeft
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #49884#51089' '#51068#51088
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          Kind = dtkDateEh
          ParentFont = False
          TabOrder = 2
          Visible = True
          ExplicitHeight = 26
        end
        object edtEndDate: TDBDateTimeEditEh
          AlignWithMargins = True
          Left = 203
          Top = 7
          Width = 121
          Height = 28
          Margins.Left = 0
          Margins.Top = 7
          Margins.Bottom = 7
          ControlLabel.Font.Charset = DEFAULT_CHARSET
          ControlLabel.Font.Color = clWindowText
          ControlLabel.Font.Height = -12
          ControlLabel.Font.Name = 'Pretendard Variable'
          ControlLabel.Font.Style = []
          ControlLabel.ParentFont = False
          Align = alLeft
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #51333#47308' '#51068#51088
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          Kind = dtkDateEh
          ParentFont = False
          TabOrder = 3
          Visible = True
          ExplicitHeight = 26
        end
        object cbxClubSeq: TDBLookupComboboxEh
          AlignWithMargins = True
          Left = 363
          Top = 7
          Width = 250
          Height = 28
          Margins.Left = 0
          Margins.Top = 7
          Margins.Bottom = 7
          ControlLabel.Font.Charset = DEFAULT_CHARSET
          ControlLabel.Font.Color = clWindowText
          ControlLabel.Font.Height = -12
          ControlLabel.Font.Name = 'Pretendard Variable'
          ControlLabel.Font.Style = []
          ControlLabel.ParentFont = False
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          Align = alLeft
          Alignment = taLeftJustify
          AutoSize = False
          DynProps = <>
          DataField = ''
          DropDownBox.Columns = <
            item
              FieldName = 'club_nm'
              Title.Caption = #53364#47101#47749
            end>
          EmptyDataInfo.Text = #53364#47101' '#49440#53469
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
          TabOrder = 4
          Visible = True
        end
        object btnSelectRally: TBitBtn
          AlignWithMargins = True
          Left = 1029
          Top = 3
          Width = 110
          Height = 36
          Cursor = crHandPoint
          Margins.Left = 0
          Align = alRight
          Caption = #45824#54924' '#49440#53469
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 4
          ImageName = 'bowling_16px'
          Images = BPDM.imlIcon16
          ParentFont = False
          TabOrder = 5
          OnClick = btnSelectRallyClick
        end
      end
      object G1: TcxGrid
        AlignWithMargins = True
        Left = 3
        Top = 42
        Width = 1136
        Height = 674
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
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          OnCellDblClick = V1CellDblClick
          DataController.DataSource = dsrRallyList
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
          Styles.Indicator = BPDM.StyleHeader1
          Styles.Selection = BPDM.StyleSelection
          Styles.BandHeader = BPDM.StyleHeader1
          Bands = <
            item
              Caption = #45824#54924' '#51221#48372
            end
            item
              Caption = #47112#51064' '#51060#46041
            end
            item
              Caption = #46041#51216#51088' '#52376#47532' '#44592#51456
            end>
          object V1Column1: TcxGridDBBandedColumn
            Caption = #46321#47197#51068
            DataBinding.FieldName = 'calc_reg_date'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 86
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V1rally_datetime: TcxGridDBBandedColumn
            Caption = #45824#54924#51068#49884
            DataBinding.FieldName = 'rally_datetime'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 141
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V1rally_nm: TcxGridDBBandedColumn
            Caption = #45824#54924#47749
            DataBinding.FieldName = 'rally_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 194
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object V1club_nm: TcxGridDBBandedColumn
            Caption = #53364#47101#47749
            DataBinding.FieldName = 'club_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 129
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object V1entry_cnt: TcxGridDBBandedColumn
            Caption = #51064#50896
            DataBinding.FieldName = 'entry_cnt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 52
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object V1lane_nm: TcxGridDBBandedColumn
            Caption = #47112#51064' '#51221#48372
            DataBinding.FieldName = 'lane_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 115
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object V1game_cnt: TcxGridDBBandedColumn
            Caption = #44172#51076
            DataBinding.FieldName = 'game_cnt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 53
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object V1league_yn: TcxGridDBBandedColumn
            Caption = #47532#44536
            DataBinding.FieldName = 'league_yn'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.Alignment = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 49
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object V1team_yn: TcxGridDBBandedColumn
            AlternateCaption = 'V1team_yn'
            Caption = #54016#51204
            DataBinding.FieldName = 'team_yn'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.Alignment = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 53
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object V1calc_move_method: TcxGridDBBandedColumn
            Caption = #48169#49885
            DataBinding.FieldName = 'calc_move_method'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 50
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V1lane_move_cnt: TcxGridDBBandedColumn
            Caption = #51060#46041
            DataBinding.FieldName = 'lane_move_cnt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 40
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V1rank_nohandy_yn: TcxGridDBBandedColumn
            Caption = #45432#54648#46356
            DataBinding.FieldName = 'rank_nohandy_yn'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.Alignment = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 52
            Position.BandIndex = 2
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V1rank_highlow_yn: TcxGridDBBandedColumn
            Caption = #54616#51060#47196#50864
            DataBinding.FieldName = 'rank_highlow_yn'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.Alignment = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 57
            Position.BandIndex = 2
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V1rank_birth_yn: TcxGridDBBandedColumn
            Caption = #50672#51109#51088
            DataBinding.FieldName = 'rank_birth_yn'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.Alignment = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 53
            Position.BandIndex = 2
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
        end
        object L1: TcxGridLevel
          GridView = V1
        end
      end
    end
    object tabSetting: TTabSheet
      Caption = #45824#54924' '#49444#51221
      ImageIndex = 1
      object G2: TcxGrid
        AlignWithMargins = True
        Left = 3
        Top = 0
        Width = 849
        Height = 716
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
        TabOrder = 0
        LookAndFeel.Kind = lfUltraFlat
        LookAndFeel.NativeStyle = False
        LookAndFeel.ScrollbarMode = sbmTouch
        LookAndFeel.ScrollMode = scmSmooth
        object V2: TcxGridDBBandedTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = dsrRallyEntryList
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
          Styles.Indicator = BPDM.StyleHeader1
          Styles.Selection = BPDM.StyleSelection
          Styles.BandHeader = BPDM.StyleHeader1
          Bands = <
            item
              Caption = #45824#54924#47749' : '#48380#47553#54589' '#53364#47101' '#45824#51204
            end>
          object V2rec_no: TcxGridDBBandedColumn
            Caption = #49692
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            OnGetDataText = V2rec_noGetDataText
            HeaderAlignmentHorz = taCenter
            Width = 40
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V2club_nm: TcxGridDBBandedColumn
            Caption = #53364#47101#47749
            DataBinding.FieldName = 'club_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 200
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V2bowler_nm: TcxGridDBBandedColumn
            Caption = #48380#47084#47749
            DataBinding.FieldName = 'bowler_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 120
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object V2member_div: TcxGridDBBandedColumn
            Caption = #54924#50896#44396#48516
            DataBinding.FieldName = 'member_div'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 71
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object V2mobile_no: TcxGridDBBandedColumn
            Caption = #51204#54868#48264#54840
            DataBinding.FieldName = 'mobile_no'
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
          object V2birthday: TcxGridDBBandedColumn
            Caption = #49373#45380#50900#51068
            DataBinding.FieldName = 'birthday'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 110
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object V2lane_no: TcxGridDBBandedColumn
            Caption = #47112#51064
            DataBinding.FieldName = 'lane_no'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object V2game_cnt: TcxGridDBBandedColumn
            Caption = #44172#51076
            DataBinding.FieldName = 'game_cnt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object V2handy: TcxGridDBBandedColumn
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
        end
        object L2: TcxGridLevel
          GridView = V2
        end
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 855
        Top = 0
        Width = 284
        Height = 716
        Margins.Left = 0
        Margins.Top = 0
        Align = alRight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object gbxGame: TGroupBox
          AlignWithMargins = True
          Left = 6
          Top = 31
          Width = 272
          Height = 174
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          Caption = #44172#51076' '#49444#51221
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object cbxShiftCount: TDBComboBoxEh
            Left = 80
            Top = 130
            Width = 177
            Height = 27
            ControlLabel.Width = 56
            ControlLabel.Height = 18
            ControlLabel.Caption = #47112#51064' '#51060#46041
            ControlLabel.Visible = True
            ControlLabelLocation.Spacing = 5
            ControlLabelLocation.Position = lpLeftCenterEh
            Alignment = taLeftJustify
            AutoSize = False
            DynProps = <>
            EmptyDataInfo.Text = #47112#51064' '#51060#46041' '#49440#53469
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Visible = True
          end
          object cbxShiftMethod: TDBComboBoxEh
            Left = 80
            Top = 97
            Width = 177
            Height = 27
            ControlLabel.Width = 56
            ControlLabel.Height = 18
            ControlLabel.Caption = #51060#46041' '#48169#49885
            ControlLabel.Visible = True
            ControlLabelLocation.Spacing = 5
            ControlLabelLocation.Position = lpLeftCenterEh
            Alignment = taLeftJustify
            AutoSize = False
            DynProps = <>
            EmptyDataInfo.Text = #47112#51064' '#51060#46041' '#48169#49885' '#49440#53469
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            Visible = True
          end
          object ckbLeagueMode: TDBCheckBoxEh
            Left = 80
            Top = 65
            Width = 100
            Height = 26
            Caption = #47532#44536' '#44172#51076
            DynProps = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object edtRallyName: TDBEditEh
            Left = 80
            Top = 32
            Width = 177
            Height = 26
            ControlLabel.Width = 39
            ControlLabel.Height = 18
            ControlLabel.Caption = #45824#54924#47749
            ControlLabel.Visible = True
            ControlLabelLocation.Spacing = 5
            ControlLabelLocation.Position = lpLeftCenterEh
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Visible = True
          end
        end
        object gbxSameScore: TGroupBox
          AlignWithMargins = True
          Left = 6
          Top = 210
          Width = 272
          Height = 130
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          Caption = #46041#51216#51088' '#52376#47532' '#44592#51456
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object ckbHighLow: TDBCheckBoxEh
            Left = 80
            Top = 58
            Width = 100
            Height = 26
            Caption = #54616#51060'-'#47196#50864
            DynProps = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object ckbSeniorFirst: TDBCheckBoxEh
            Left = 80
            Top = 90
            Width = 100
            Height = 26
            Caption = #50672#51109#51088' '#50864#49440
            DynProps = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object ckbNotHandy: TDBCheckBoxEh
            Left = 80
            Top = 26
            Width = 100
            Height = 26
            Caption = #48708' '#54648#46356
            DynProps = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
        end
        object gbxTeamRally: TGroupBox
          AlignWithMargins = True
          Left = 6
          Top = 345
          Width = 272
          Height = 66
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          Caption = #54016' '#49444#51221
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object ckbTeamMode: TDBCheckBoxEh
            Left = 80
            Top = 26
            Width = 100
            Height = 26
            Caption = #54016#51204' '#47784#46300
            DynProps = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel2: TPanel
          Left = 1
          Top = 1
          Width = 282
          Height = 25
          Align = alTop
          BevelOuter = bvNone
          Caption = #45824#54924' '#49444#51221
          Color = 9857565
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 7
          StyleElements = [seBorder]
        end
        object btnSaveSetting: TBitBtn
          AlignWithMargins = True
          Left = 62
          Top = 476
          Width = 160
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #49444#51221' '#51200#51109
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
          OnClick = btnSaveSettingClick
        end
        object btnDoAssign: TBitBtn
          AlignWithMargins = True
          Left = 62
          Top = 577
          Width = 160
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #51593#49884' '#48176#51221
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 56
          ImageName = 'trophy_32px'
          Images = BPDM.imlIcon32
          ParentFont = False
          TabOrder = 6
          OnClick = btnDoAssignClick
        end
        object btnRallyList: TBitBtn
          AlignWithMargins = True
          Left = 62
          Top = 419
          Width = 160
          Height = 50
          Cursor = crHandPoint
          Margins.Left = 0
          Caption = #45824#54924' '#47785#47197
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 28
          ImageName = 'AssignmentReturn_32px'
          Images = BPDM.imlIcon32
          ParentFont = False
          TabOrder = 3
          OnClick = btnRallyListClick
        end
        object edtPrepareMin: TDBNumberEditEh
          Left = 180
          Top = 542
          Width = 40
          Height = 26
          ControlLabel.Width = 79
          ControlLabel.Height = 18
          ControlLabel.Caption = #51456#48708' '#49884#44036'('#48516')'
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          MaxValue = 30.000000000000000000
          ParentFont = False
          TabOrder = 5
          Value = 10.000000000000000000
          Visible = True
        end
      end
    end
  end
  object dsrRallyEntryList: TDataSource
    DataSet = BPDM.QRRallyEntryList
    Left = 144
    Top = 536
  end
  object dsrRallyList: TDataSource
    DataSet = BPDM.QRRallyList
    Left = 144
    Top = 480
  end
  object dsrClubList: TDataSource
    DataSet = BPDM.QRClubList
    Left = 144
    Top = 424
  end
end
