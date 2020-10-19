unit ReportReceiveFile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ToolEdit, RXDBCtrl, UCrpe32, Buttons, ExtCtrls, Db,
  Halcn6DB;

type
  TFormReceiveFileReport = class(TForm)
    Panel1: TPanel;
    bbPreview: TBitBtn;
    bbPrint: TBitBtn;
    bbClose: TBitBtn;
    Crpe1: TCrpe;
    Label1: TLabel;
    tbReceiveFileReport: THalcyonDataSet;
    edDate: TDateEdit;
    procedure FormActivate(Sender: TObject);
    procedure bbPreviewClick(Sender: TObject);
  private
    { Private declarations }
    procedure CreateReportFile;
    function CompareDate(stamp : string;dt : TDateTime) : boolean;
  public
    { Public declarations }
  end;

var
  FormReceiveFileReport: TFormReceiveFileReport;

implementation

uses MeterData;

{$R *.DFM}

function TFormReceiveFileReport.CompareDate;
var DTStamp : string;
begin
  DateTimeToString(DTStamp,'dd/mm/yyyy',DT);
  result := copy(Stamp,1,10)=DTStamp;
end;

procedure TFormReceiveFileReport.FormActivate(Sender: TObject);
begin
  tbReceiveFileReport.Exclusive := true;
  tbReceiveFileReport.open;
  tbReceiveFileReport.Zap;
  dm.tbDlog.open;
end;

procedure TFormReceiveFileReport.CreateReportFile;
var i : integer;
    numrec : string;
begin
  dm.tbDlog.First;
  while not dm.tbDlog.EOF do begin
    for i := 1 to 21 do begin
      numrec := dm.tbDlog.StringGet('D'+IntToStr(i));
      if  (numrec <> '0000') and
          (CompareDate(dm.tbDlog.StringGet('stamp'),edDate.Date)) then begin
        with tbReceiveFileReport do begin
          insert;
          IntegerPut('numrec',StrToInt(numrec));
          integerPut('cday',i);
          StringPut('infile',dm.tbDlog.StringGet('infile'));
          StringPut('HEAD1','วันที่รับ '+edDate.Text);
          post;
        end;  // with
      end;  // if
    end;  // for
    dm.tbDlog.next;
  end;  // while
end;
procedure TFormReceiveFileReport.bbPreviewClick(Sender: TObject);
begin
  CreateReportFile;
  tbReceiveFileReport.close;
  Crpe1.Execute;
end;

end.
