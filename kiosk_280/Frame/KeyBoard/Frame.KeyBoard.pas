unit Frame.KeyBoard;

interface

uses
  Frame.KeyBoard.Item.Style,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, System.Generics.Collections;

type
  TKeyBoard = class(TFrame)
    KeyRectangle: TRectangle;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DisPlayKeyBoard;
    procedure CloseFrame;
  end;

implementation

uses
  uConsts;

{$R *.fmx}

{ TKeyBoard }

procedure TKeyBoard.CloseFrame;
begin
  //KeyRectangle.DeleteChildren;
  //KeyRectangle.DisposeOf;
end;

procedure TKeyBoard.DisPlayKeyBoard;
var
  Index, ColIndex, RowIndex: Integer;
  AKeyBoardItemStyle: TKeyBoardItemStyle;
begin

  try
    ColIndex := 0;
    RowIndex := 0;

    for Index := 0 to Length(Key3BoardName) - 1 do
    begin

      if ColIndex = 3 then
      begin
        Inc(RowIndex);
        ColIndex := 0;
      end;

      AKeyBoardItemStyle := TKeyBoardItemStyle.Create(nil);
      AKeyBoardItemStyle.Position.X := ColIndex * (AKeyBoardItemStyle.Width + 22);
      AKeyBoardItemStyle.Position.Y := RowIndex * (AKeyBoardItemStyle.Height + 22);

      AKeyBoardItemStyle.Text.Text := Key3BoardName[Index];
      if Index in [9, 11] then
      begin
        AKeyBoardItemStyle.KeyRectangle.Fill.Color := $FFB1BBFB;

        if Index = 11 then
        begin
          AKeyBoardItemStyle.Text.Visible := False;
          AKeyBoardItemStyle.imgDel.Visible := True;
        end;
      end;

      AKeyBoardItemStyle.Key := Key3BoardArray[Index];
      AKeyBoardItemStyle.Parent := KeyRectangle;

      Inc(ColIndex);
    end;
  finally

  end;

end;

end.
