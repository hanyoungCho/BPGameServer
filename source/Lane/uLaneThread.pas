unit uLaneThread;

interface

uses
  System.Classes, System.SysUtils;

type
  TLaneThread = class(TThread)
  private
    Cnt: Integer;
    Cnt_1: Integer;
    FCheckTime: String;
    //FCloseSend: String;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    property CheckTime: String read FCheckTime write FCheckTime;
  end;

implementation

uses
  uGlobal;

constructor TLaneThread.Create;
begin
  Cnt := 0;
  Cnt_1 := 5;
  FCheckTime := '';
  //FCloseSend := 'N';

  Global.Log.LogWrite('TLaneThread Create');

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TLaneThread.Destroy;
begin

  inherited;
end;

procedure TLaneThread.Execute;
var
  sLogMsg: String;
begin
  inherited;

  while not Terminated do
  begin
    try

      Synchronize(Global.LaneThreadTimeCheck);

      //���� erp ���
      Synchronize(Global.Lane.LaneReserveErp);

      inc(Cnt_1);
      if Cnt_1 > 2 then
      begin
        //��������
        //Synchronize(Global.Lane.LaneStatusChk);
        Synchronize(Global.Lane.LaneStatusChk_tm);

        Synchronize(Global.Lane.LaneStatusChk_tm_Competition);

        //��������
        //Synchronize(Global.Lane.LaneAssignChk);

        Cnt_1 := 0;
      end;

      inc(Cnt);
      if Cnt > 10 then
      begin

        if Global.Config.Emergency = False then
        begin
          //Ÿ���� ����Ȯ�ο�-> ERP ����
          //Synchronize(Global.Teebox.SendADStatusToErp);
        end;

        //���� ����Ȯ��
        Synchronize(Global.Lane.LaneReserveChk);

        Cnt := 0;
      end;

      Sleep(1000);
    except
      on e: Exception do
      begin
        sLogMsg := 'TLaneThread Error : ' + e.Message;
        Global.Log.LogWrite(sLogMsg);
      end;
    end;
  end;

end;

end.
