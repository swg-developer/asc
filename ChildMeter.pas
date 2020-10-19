unit ChildMeter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFormChildMeter = class(TForm)
    MeterPic: TImage;
    Label1: TLabel;
    edMeter: TEdit;
    Label2: TLabel;
    edSection: TEdit;
    Label3: TLabel;
    edTrip: TEdit;
    Label4: TLabel;
    edPrevRead: TEdit;
    Label5: TLabel;
    edRead: TEdit;
    Label6: TLabel;
    edComment: TEdit;
    Label7: TLabel;
    edAvgkw: TEdit;
    Label8: TLabel;
    edKW: TEdit;
    Label9: TLabel;
    edDiff: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure MakeNoDataScreen;
  public
    { Public declarations }
    procedure ShowMeter(MeterNumber : string;RcvFileDate : TDateTime);
    function CalcKW(prevRead,cRead,prevDate : string;cDate : TDatetime) : string;
  end;

var
  FormChildMeter: TFormChildMeter;

implementation

uses MeterData,jpeg;

{$R *.DFM}

procedure TFormChildMeter.MakeNoDataScreen;
begin
  edMeter.Text := '>> Not Found <<';
  edSection.Clear;
  edTrip.Clear;
  edPrevRead.Clear;
  edRead.Clear;
  edComment.Clear;
  edAvgkw.Clear;
  edKw.Clear;
  edDiff.Clear;
end;
function TFormChildMeter.CalcKW(prevRead,cRead,prevDate : string;cDate : TDatetime) : string;
var syy,smm,sdd : string;
    prevDT : TDateTime;
    diffMeter : integer;
    numDay : integer;
begin
  if (prevRead='') or (cRead='') then begin
    result := 'N/A';
  end
  else begin
    syy := '25'+copy(prevDate,1,2);
    smm := copy(prevDate,3,2);
    sdd := copy(prevDate,5,2);
    prevDT := encodedate(StrToInt(syy)-543,StrToInt(smm),StrToInt(sdd));
    diffMeter := StrToInt(cRead)-StrToInt(prevRead);
    numDay := trunc(cDate-prevDT);
    result := IntToStr(trunc(diffMeter*1000/(numDay*24)));
  end;
end;

procedure TFormChildMeter.FormActivate(Sender: TObject);
begin
  dm.tbMeter.open;
end;

procedure TFormChildMeter.ShowMeter;
begin
  self.Caption := MeterNumber;
  if not dm.tbMeter.Find(MeterNumber,true,false) then begin
    MakenoDataScreen;
  end
  else begin
    with dm.tbMeter do begin
      edMeter.Text := MeterNumber;
      edSection.Text := StringGet('m_section');
      edtrip.Text := StringGet('m_trip');
      edPrevRead.Text := StringGet('m_prev_rd');
      edRead.Text := StringGet('e_last_rd');
      edComment.Text := StringGet('e_hh_cmt');
      edAvgKw.Text := StringGet('m_avg_kwhr');
      edKw.Text := CalcKw(StringGet('m_prev_rd'),
                StringGet('e_last_rd'),
                StringGet('m_prev_dte'),
                rcvFileDate);
      if fileExists('pic\'+MeterNumber+'.jpg') then
        MeterPic.Picture.LoadFromFile('pic\'+MeterNumber+'.jpg');
    end;
  end;
end;

procedure TFormChildMeter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormChildMeter.FormCreate(Sender: TObject);
begin
  MeterPic.Picture.RegisterFileFormat('jpg', 'JPEG', TJPEGImage);
end;

end.
