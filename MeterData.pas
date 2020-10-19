unit MeterData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Halcn6DB;

type
  Tdm = class(TDataModule)
    dsMeter: TDataSource;
    tbMeter: THalcyonDataSet;
    tbDlog: THalcyonDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{$R *.DFM}

end.
