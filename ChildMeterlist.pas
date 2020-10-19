unit ChildMeterlist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, RXDBCtrl, Halcn6DB;

type
  TFormChildMeterList = class(TForm)
    MeterGrid: TRxDBGrid;
    procedure FormActivate(Sender: TObject);
    procedure MeterGridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormChildMeterList: TFormChildMeterList;

implementation

uses  MeterData, ChildMeter;

{$R *.DFM}

procedure TFormChildMeterList.FormActivate(Sender: TObject);
begin
  dm.tbMeter.open;
end;

procedure TFormChildMeterList.MeterGridDblClick(Sender: TObject);
var
  Child: TFormChildMeter;
begin
  { create a new MDI child window }
  Child := TFormChildMeter.Create(Application);
  Child.ShowMeter(dm.tbMeter.StringGet('m_Mea_num'),now);
end;

end.
