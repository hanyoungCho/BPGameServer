object BPLaneContainer: TBPLaneContainer
  Left = 0
  Top = 0
  Width = 500
  Height = 404
  Margins.Top = 2
  Margins.Bottom = 0
  BevelOuter = bvNone
  Color = 5393480
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  ParentFont = False
  PopupMenu = LanePopupMenu
  TabOrder = 0
  object GameGrid: TcxGrid
    AlignWithMargins = True
    Left = 3
    Top = 49
    Width = 494
    Height = 195
    Margins.Bottom = 0
    Align = alClient
    BorderStyle = cxcbsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    LookAndFeel.NativeStyle = False
    LookAndFeel.ScrollbarMode = sbmTouch
    LookAndFeel.ScrollMode = scmSmooth
    object GameView: TcxGridDBTableView
      PopupMenu = LanePopupMenu
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = GameDataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnFiltering = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnHorzSizing = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsSelection.CellSelect = False
      OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'>'
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      Styles.Header = BPDM.StyleHeader1
      Styles.Inactive = BPDM.StyleSelection2
      Styles.Selection = BPDM.StyleSelection2
      object GameViewdirection: TcxGridDBColumn
        Caption = #8596
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
        MinWidth = 24
        Options.HorzSizing = False
        Width = 24
      end
      object GameViewshoes_yn: TcxGridDBColumn
        Caption = 'S'
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
        MinWidth = 24
        Options.HorzSizing = False
        Width = 24
      end
      object GameViewprogress: TcxGridDBColumn
        Caption = #48380#47084'/'#49345#54408#47749
        DataBinding.FieldName = 'frame_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxProgressBarProperties'
        Properties.BeginColor = 10809855
        Properties.Max = 10.000000000000000000
        Properties.OverloadValue = 10.000000000000000000
        Properties.PeakValue = 10.000000000000000000
        Properties.ShowTextStyle = cxtsText
        OnCustomDrawCell = GameViewprogressCustomDrawCell
        Width = 159
      end
      object GameViewgame_cnt: TcxGridDBColumn
        Caption = 'C'
        DataBinding.FieldName = 'game_cnt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        MinWidth = 30
        Options.HorzSizing = False
        Width = 30
      end
      object GameViewgame_fin: TcxGridDBColumn
        Caption = 'G'
        DataBinding.FieldName = 'game_fin'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        MinWidth = 30
        Options.HorzSizing = False
        Width = 30
      end
      object GameViewbowler_id: TcxGridDBColumn
        DataBinding.FieldName = 'bowler_id'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        MinWidth = 0
        Width = 0
      end
      object GameViewbowler_nm: TcxGridDBColumn
        DataBinding.FieldName = 'bowler_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        MinWidth = 0
        Width = 0
      end
      object GameViewprod_nm: TcxGridDBColumn
        DataBinding.FieldName = 'prod_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        MinWidth = 0
        Width = 0
      end
      object GameViewassign_no: TcxGridDBColumn
        DataBinding.FieldName = 'assign_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        MinWidth = 0
        Width = 0
      end
    end
    object GameLevel: TcxGridLevel
      GridView = GameView
    end
  end
  object TitlePanel: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 46
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentBackground = False
    ParentColor = True
    ParentFont = False
    ParentShowHint = False
    PopupMenu = LanePopupMenu
    ShowHint = True
    TabOrder = 0
    StyleElements = []
    object FrameNoLabel: TLabel
      AlignWithMargins = True
      Left = 471
      Top = 3
      Width = 24
      Height = 40
      Hint = #51652#54665' '#51473#51064' '#54532#47112#51076
      Margins.Left = 0
      Margins.Right = 5
      Align = alRight
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      PopupMenu = LanePopupMenu
      ShowHint = True
      Transparent = False
      Layout = tlCenter
      StyleElements = []
      ExplicitLeft = 221
      ExplicitTop = 4
      ExplicitHeight = 37
    end
    object SpecialModeLabel: TLabel
      AlignWithMargins = True
      Left = 437
      Top = 3
      Width = 14
      Height = 40
      Margins.Left = 0
      Align = alRight
      Alignment = taCenter
      AutoSize = False
      Caption = '9'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16748574
      Font.Height = -16
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      PopupMenu = LanePopupMenu
      Transparent = False
      Layout = tlCenter
      StyleElements = []
      ExplicitLeft = 187
      ExplicitTop = 4
      ExplicitHeight = 37
    end
    object LeagueModeLabel: TLabel
      AlignWithMargins = True
      Left = 454
      Top = 3
      Width = 14
      Height = 40
      Hint = #47532#44536' '#44172#51076
      Margins.Left = 0
      Align = alRight
      Alignment = taCenter
      AutoSize = False
      Caption = 'L'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3305471
      Font.Height = -16
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      PopupMenu = LanePopupMenu
      ShowHint = True
      Transparent = False
      Layout = tlCenter
      StyleElements = []
      ExplicitLeft = 204
      ExplicitTop = 4
      ExplicitHeight = 37
    end
    object RallyModeImage: TImage
      AlignWithMargins = True
      Left = 85
      Top = 7
      Width = 32
      Height = 32
      Hint = #45824#54924'/'#45800#52404#51204
      Margins.Left = 5
      Margins.Top = 7
      Margins.Right = 5
      Margins.Bottom = 7
      Align = alLeft
      Transparent = True
      ExplicitLeft = 88
      ExplicitTop = 8
    end
    object ShiftMethodLabel: TLabel
      AlignWithMargins = True
      Left = 122
      Top = 3
      Width = 37
      Height = 40
      Hint = #51068#48152' '#51060#46041
      Margins.Left = 0
      Align = alLeft
      Caption = #9654#9654'2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = [seClient, seBorder]
      ExplicitHeight = 19
    end
    object LaneNoPanel: TPanel
      Left = 0
      Top = 0
      Width = 80
      Height = 46
      Cursor = crHandPoint
      Align = alLeft
      BevelOuter = bvNone
      Caption = '1'
      Color = 9857565
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -29
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      PopupMenu = LanePopupMenu
      ShowHint = True
      TabOrder = 0
      StyleElements = []
      object StatusPanel: TPanel
        Left = 0
        Top = 41
        Width = 80
        Height = 5
        Align = alBottom
        BevelOuter = bvNone
        Color = 14676381
        ParentBackground = False
        TabOrder = 0
        Visible = False
        StyleElements = []
      end
    end
  end
  object GameInfoPanel: TPanel
    Left = 0
    Top = 356
    Width = 500
    Height = 24
    Margins.Top = 0
    Margins.Bottom = 1
    Align = alBottom
    BevelOuter = bvNone
    Caption = #50696#49345' '#51333#47308#49884#44033
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentBackground = False
    ParentColor = True
    ParentCtl3D = False
    ParentFont = False
    PopupMenu = LanePopupMenu
    TabOrder = 2
    VerticalAlignment = taAlignBottom
    StyleElements = []
  end
  object PaymentInfoPanel: TPanel
    Left = 0
    Top = 380
    Width = 500
    Height = 24
    Margins.Top = 0
    Margins.Bottom = 1
    Align = alBottom
    BevelOuter = bvNone
    Caption = #44208#51228#54624' '#44552#50529
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 8831471
    Font.Height = -16
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentBackground = False
    ParentColor = True
    ParentCtl3D = False
    ParentFont = False
    PopupMenu = LanePopupMenu
    TabOrder = 3
    VerticalAlignment = taAlignTop
    StyleElements = []
  end
  object SaleGrid: TcxGrid
    AlignWithMargins = True
    Left = 3
    Top = 246
    Width = 494
    Height = 110
    Margins.Top = 2
    Margins.Bottom = 0
    Align = alBottom
    BorderStyle = cxcbsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    LookAndFeel.NativeStyle = False
    LookAndFeel.ScrollbarMode = sbmTouch
    LookAndFeel.ScrollMode = scmSmooth
    object SaleView: TcxGridDBTableView
      PopupMenu = LanePopupMenu
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = SaleDataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0'
          Kind = skSum
          FieldName = 'calc_charge_amt'
          Column = SaleViewcalc_charge_amt
        end>
      DataController.Summary.SummaryGroups = <>
      DataController.Summary.OnAfterSummary = GridViewSaleDataControllerSummaryAfterSummary
      OptionsCustomize.ColumnFiltering = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnHorzSizing = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsSelection.CellSelect = False
      OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'>'
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      Styles.Header = BPDM.StyleHeader1
      Styles.Inactive = BPDM.StyleSelection2
      Styles.Selection = BPDM.StyleSelection2
      object SaleViewprod_nm: TcxGridDBColumn
        Caption = #49345#54408#47749
        DataBinding.FieldName = 'prod_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 142
      end
      object SaleVieworder_qty: TcxGridDBColumn
        Caption = #49688#47049
        DataBinding.FieldName = 'order_qty'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 40
      end
      object SaleViewcalc_charge_amt: TcxGridDBColumn
        Caption = #49345#54408#44552#50529
        DataBinding.FieldName = 'calc_charge_amt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.DisplayFormat = ',0 ; -,0 '
        HeaderAlignmentHorz = taCenter
        MinWidth = 90
        Options.HorzSizing = False
        Width = 90
      end
    end
    object SaleLevel: TcxGridLevel
      GridView = SaleView
    end
  end
  object GameDataSource: TDataSource
    DataSet = GameDataSet
    Left = 216
    Top = 160
  end
  object GameDataSet: TABSQuery
    CurrentVersion = '7.94 '
    DatabaseName = 'DBLocal'
    InMemory = False
    ReadOnly = False
    SQL.Strings = (
      'SELECT'
      '  A.lane_no'
      '  , A.assign_lane_no'
      '  , A.assign_no'
      '  , S.receipt_no'
      '  , A.lane_status'
      '  , A.rally_seq'
      '  , A.league_yn'
      '  , A.lane_shift_method'
      '  , A.lane_shift_cnt'
      '  , A.direction'
      '  , A.frame_no'
      '  , A.entry_seq'
      '  , A.bowler_id'
      '  , A.bowler_nm'
      '  , A.member_no'
      '  , M.member_nm'
      '  , A.membership_seq'
      '  , A.membership_use_cnt'
      '  , A.membership_use_min'
      '  , A.game_div'
      '  , A.fee_div'
      '  , A.game_cnt'
      '  , A.game_min'
      '  , A.game_fin'
      '  , A.handy'
      '  , A.shoes_rent_yn'
      '  , A.prod_cd'
      '  , P.prod_nm'
      '  , COALESCE(S.prod_amt, 0) AS prod_amt'
      '  , COALESCE(S.order_qty, 0) AS order_qty'
      '  , COALESCE(S.dc_amt, 0) AS dc_amt'
      '  , P.prod_detail_div'
      '  , P.shoes_free_yn'
      '  , A.payment_type'
      '  , A.expected_end_datetime'
      '  , A.total_score'
      '  , A.pin_fall_result'
      'FROM MEMORY MTGameList A'
      'LEFT OUTER JOIN TBSaleItem S'
      'ON ('
      '  A.assign_no = S.assign_no'
      '  AND A.bowler_id = S.bowler_id'
      '  AND A.prod_cd = S.prod_cd'
      ')'
      'LEFT OUTER JOIN MEMORY MTProdGame P'
      'ON ('
      '  A.prod_cd = P.prod_cd'
      ')'
      'LEFT OUTER JOIN MEMORY MTMemberList M'
      'ON ('
      '  A.member_no = M.member_no'
      ')'
      'WHERE A.lane_no = :p_lane_no'
      'ORDER BY A.bowler_seq;'
      '')
    Left = 216
    Top = 104
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'p_lane_no'
        ParamType = ptUnknown
      end>
  end
  object SaleDataSet: TABSQuery
    CurrentVersion = '7.94 '
    DatabaseName = 'DBLocal'
    InMemory = False
    ReadOnly = True
    SQL.Strings = (
      'SELECT'
      '  A.assign_lane_no'
      '  , A.prod_div'
      '  , A.prod_detail_div'
      '  , A.prod_cd'
      '  , A.prod_nm'
      '  , A.service_yn'
      '  , A.receipt_no'
      '  , SUM(A.prod_amt) AS prod_amt'
      '  , SUM(A.order_qty) AS order_qty'
      '  , SUM(A.dc_amt) AS dc_amt'
      '  , SUM(A.keep_amt) AS keep_amt'
      
        '  , SUM(CASE WHEN A.service_yn = True THEN 0 ELSE ((A.prod_amt *' +
        ' A.order_qty) - A.dc_amt) END) AS calc_charge_amt'
      'FROM TBSaleItem A'
      'WHERE A.assign_lane_no = :p_assign_lane_no'
      'AND A.assign_no = :p_assign_no'
      'AND A.payment_yn = False'
      'GROUP BY'
      '  A.assign_lane_no'
      '  , A.prod_div'
      '  , A.prod_detail_div'
      '  , A.prod_cd'
      '  , A.prod_nm'
      '  , A.service_yn'
      '  , A.receipt_no'
      'ORDER BY A.prod_detail_div, A.prod_nm;'
      '')
    Left = 216
    Top = 216
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'p_assign_lane_no'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'p_assign_no'
        ParamType = ptUnknown
      end>
  end
  object SaleDataSource: TDataSource
    DataSet = SaleDataSet
    Left = 216
    Top = 272
  end
  object LanePopupMenu: TPopupMenu
    AutoHotkeys = maManual
    Images = BPDM.imlIcon16
    OnPopup = LanePopupMenuPopup
    Left = 128
    Top = 104
    object mniGameAssign: TMenuItem
      Caption = #48176#51221' '#44288#47532
      ImageIndex = 4
      ImageName = 'bowling_16px'
      OnClick = mniGameAssignClick
    end
    object mniSaleView: TMenuItem
      Caption = #54032#47588' '#44288#47532
      ImageIndex = 6
      ImageName = 'card_payment_16px'
      OnClick = mniSaleViewClick
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
      ImageIndex = 0
      ImageName = 'empty_flag_16px'
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
  object SaleRemainDataSet: TABSQuery
    CurrentVersion = '7.94 '
    DatabaseName = 'DBLocal'
    InMemory = False
    ReadOnly = True
    SQL.Strings = (
      'SELECT'
      '  A.assign_lane_no'
      
        '  , COALESCE(SUM((A.prod_amt * A.order_qty) - A.dc_amt), 0) AS c' +
        'harge_total'
      'FROM TBSaleItem A'
      'WHERE A.assign_lane_no = :p_assign_lane_no'
      'AND A.assign_no <> :p_assign_no'
      'GROUP BY A.assign_lane_no;')
    Left = 80
    Top = 216
    ParamData = <
      item
        DataType = ftInteger
        Name = 'p_assign_lane_no'
        ParamType = ptInput
        Value = 0
      end
      item
        DataType = ftUnknown
        Name = 'p_assign_no'
        ParamType = ptUnknown
      end>
  end
end
