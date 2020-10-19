unit ChildIn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl;

type
  TFormChildIn = class(TForm)
    FileListBox1: TFileListBox;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshDir;
  end;

var
  FormChildIn: TFormChildIn;

implementation

{$R *.DFM}

procedure TFormChildIn.RefreshDir;
begin
  {$I-}
  FileListBox1.Update;
  {$I+}
end;

procedure TFormChildIn.FormActivate(Sender: TObject);
begin
  {$I-}
  FileListBox1.Update;
  {$I+}
end;

end.
