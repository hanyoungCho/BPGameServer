unit Frame.FullPopup.SelectTime;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, Frame.FullPopup.Time.ItemStyle, Generics.Collections;

type
  TFullPopupSelectTime = class(TFrame)
    Layout: TLayout;
    Rectangle: TRectangle;
    txtSetTime: TText;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Text17: TText;
    Rectangle5: TRectangle;
    Text18: TText;
    TimeRectangle: TRectangle;
    Image1: TImage;
    Image2: TImage;
    procedure Text17Click(Sender: TObject);
    procedure Text18Click(Sender: TObject);
    procedure LayoutClick(Sender: TObject);
  private
    { Private declarations }
    FTime: Integer;
    FItemList: TList<TFullPopupTimeItemStyle>;
  public
    { Public declarations }
    procedure CloseFrame;
    procedure SetText(ATime: Integer);
    procedure Display;
    property Time: Integer read FTime write FTime;
    property ItemList: TList<TFullPopupTimeItemStyle> read FItemList write FItemList;
  end;

implementation

uses
  uFunction, Form.Full.Popup, uCommon, uGlobal, uConsts;

{$R *.fmx}

procedure TFullPopupSelectTime.CloseFrame;
var
  Index: Integer;
  AFullPopupTimeItemStyle: TFullPopupTimeItemStyle;
begin
  for Index := TimeRectangle.ChildrenCount - 1 downto 0 do
  begin
    TimeRectangle.Children[Index].Free;
  end;
  TimeRectangle.DeleteChildren;
end;

procedure TFullPopupSelectTime.Display;
var
  Index, ATime, AFirstIndex, Loop: Integer;
  ColIndex, RowIndex: Integer;
  Y, X: Single;
  APosition: TPosition;
  APoint: TPointF;
  AFullPopupTimeItemStyle: TFullPopupTimeItemStyle;
  IsAdd: Boolean;
  a, b: string;
begin
  try
    X := 0;
    Y := 0;

    RowIndex := 0;
    ColIndex := 0;
    AFirstIndex := 0;

    APoint := TPointF.Create(Y, X);
    APosition := TPosition.Create(APoint);

    if FItemList = nil then
      FItemList := TList<TFullPopupTimeItemStyle>.Create
    else
    begin
      for Index := FItemList.Count - 1 downto 0 do
        FItemList.Delete(Index);
    end;

    for Index := TimeRectangle.ChildrenCount - 1 downto 0 do
      TimeRectangle.Children[Index].Free;

    TimeRectangle.DeleteChildren;

    for Index := 0 to Length(SelectTime) - 1 do
    begin
//      ATime := StrToIntDef(FormatDateTime('hh', now), 6);
      ATime := SelectTime[Index];
      if {ATime <= SelectTime[Index]} True then
      begin
        AFullPopupTimeItemStyle := TFullPopupTimeItemStyle.Create(nil);

        if ColIndex = 4 then
        begin
          Inc(RowIndex);
          ColIndex := 0;
        end;

        IsAdd := False;
        for Loop := 0 to Global.TeeBox.TeeBoxList.Count - 1 do
        begin
          a := Copy(Global.TeeBox.TeeBoxList[Loop].End_Time, 1, 2);
          b := Global.TeeBox.TeeBoxList[Loop].End_Time;

          a := Copy(Global.TeeBox.TeeBoxList[Loop].End_DT, 1, 2);
          b := Global.TeeBox.TeeBoxList[Loop].End_DT;

          if Copy(Global.TeeBox.TeeBoxList[Loop].End_Time, 1, 2) =  FormatFloat('00', ATime) then
          begin
            IsAdd := True;
            Break;
          end;
        end;

        if IsAdd then
        begin
          APosition.X := ColIndex * (AFullPopupTimeItemStyle.Width + 20);
          APosition.Y := RowIndex * (AFullPopupTimeItemStyle.Height + 20);

          AFullPopupTimeItemStyle.Position := APosition;
          AFullPopupTimeItemStyle.Tag := Index;
          AFullPopupTimeItemStyle.Bind(SelectTime[Index]);

          AFullPopupTimeItemStyle.Parent := TimeRectangle;

          if AFirstIndex = 0 then
            AFirstIndex := SelectTime[Index];

          Inc(ColIndex);

          FItemList.Add(AFullPopupTimeItemStyle);
        end;
      end;
    end;

    if AFirstIndex <> 0 then
      SetText(AFirstIndex);
  finally
    APosition.Free;
    //chy test
    //FreeAndNil(APoint);
  end;
end;

procedure TFullPopupSelectTime.LayoutClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TFullPopupSelectTime.SetText(ATime: Integer);
var
  AStr: string;
  Index: Integer;
begin
  Time := ATime;

//  if Time > StrToIntDef(FormatDateTime('nn', now), 0) then
//    Exit;

  TouchSound;

  Global.SaleModule.SelectTime := DateStrToDateTime(FormatDateTime('YYYYMMDD', now) + FormatFloat('00', Time) + '0000');

  txtSetTime.Text := Format('%s%s', [FormatFloat('00', Time),
    IfThen(Time = 12, '(정오)', Format('(%s %s시)', [IfThen(Time < 12, '오전', '오후'), FormatFloat('00', IfThen(Time < 12, Time, Time - 12))]))
  ]);

  for Index := 0 to FItemList.Count - 1 do
  begin
    if FItemList[Index].Tag = ATime then
      FItemList[Index].Rectangle.Fill.Color := $FF13CE00
    else
      FItemList[Index].Rectangle.Fill.Color := TAlphaColorRec.Null;
  end;
    
end;

procedure TFullPopupSelectTime.Text17Click(Sender: TObject);
begin
  TouchSound;
  Global.SaleModule.SelectTime := DateStrToDateTime(FormatDateTime('YYYYMMDDhhnnss', now));
  FullPopup.CloseFormStrMrCancel;
end;

procedure TFullPopupSelectTime.Text18Click(Sender: TObject);
begin
  TouchSound;
  FullPopup.CloseFormStrMrok('');
end;

end.
