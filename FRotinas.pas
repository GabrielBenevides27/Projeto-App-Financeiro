unit FRotinas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D, FireDac.Comp.Client, FireDac.DApt, Data.db, DateUtils;

type
  TfrmRotinas = class(TForm)
  public
   dtFiltro: TDate;
   function nomeMes: string;
    { Public declarations }
  end;

var
  frmRotinas: TfrmRotinas;

implementation

{$R *.fmx}

uses FUniMainModule;

function TfrmRotinas.nomeMes(): string;
begin
  dtFiltro := date;

  case MonthOf(dtFiltro) of
    1 : Result := 'Janeiro';
    2 : Result := 'Fevereiro';
    3 : Result := 'Março';
    4 : Result := 'Abril';
    5 : Result := 'Maio';
    6 : Result := 'Junho';
    7 : Result := 'Julho';
    8 : Result := 'Agosto';
    9 : Result := 'Setembro';
    10 : Result := 'Outubro';
    11 : Result := 'Novembro';
    12 : Result := 'Dezembro';
  end;

  Result := Result;
end;



end.