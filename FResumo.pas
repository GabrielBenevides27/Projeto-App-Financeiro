unit FResumo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, FMX.Controls.Presentation,FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.StdCtrls,
  FMX.Layouts;

type
  TfrmResumo = class(TForm)
    Layout1: TLayout;
    imgVoltarLancamento: TLabel;
    imgVoltarConta: TImage;
    Layout2: TLayout;
    Rectangle3: TRectangle;
    lblMes: TLabel;
    lv_Resumo: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgVoltarContaClick(Sender: TObject);
  private
    procedure montarResumo;
    procedure addCategoria(listview: TlistView; categoria: string; valor: double; foto: TStream);
    { Private declarations }
  public
    { Public declarations }
    dtFiltro: TDate;
  end;

var
  frmResumo: TfrmResumo;

implementation

{$R *.fmx}

uses FPrincipal, cCategorias, FUniMainModule, cLancamento, System.DateUtils;

procedure TfrmResumo.AddCategoria(listview: TListView;
                                      categoria: string;
                                      valor: double;
                                      foto: TStream);
var
  txt: TListItemText;
  img: TListItemImage;
  bmp: TBitmap;
begin
  with listview.Items.Add do
  begin

    txt := TListItemText(Objects.FindDrawable('TxtCategoria'));
    txt.Text := categoria;

    txt := TListItemText(Objects.FindDrawable('TxtValor'));
    txt.Text := FormatFloat('#,##0.00', valor);

    img := TListItemImage(Objects.FindDrawable('ImgIcone'));

    if foto <> nil then
    begin
      bmp := TBitmap.Create;
      bmp.LoadFromStream(foto);

      img.OwnsBitmap := true;
      img.Bitmap := bmp;
    end;
  end;
end;

procedure TfrmResumo.montarResumo;
var
 lanc: TLancamento;
 qry: TFDQuery;
 erro: string;
 icone: Tstream;
begin
  try
    lv_Resumo.Items.Clear;
    lanc := TLancamento.Create(dm.conn);
    lanc.DATADE := FormatDateTime('YYYY-MM-DD', StartOfTheMonth(dtFiltro));
    lanc.DATAATE := FormatDateTime('YYYY-MM-DD', EndOfTheMonth(dtFiltro));
    qry := lanc.ListarResumo(erro);

    while NOT qry.Eof do
    begin
      if qry.FieldByName('ICONE').AsString <> '' then
      begin
        icone := qry.CreateBlobStream(qry.FieldByName('ICONE'), TBlobStreamMode.bmRead)
      end
      else
      icone := nil;

      frmResumo.addCategoria(lv_Resumo, qry.FieldByName('DESCRICAO').AsString, qry.FieldByName('VALOR').AsCurrency, icone);


      if icone <> nil then
        icone.DisposeOf;

      qry.Next;
    end;

  finally
    qry.DisposeOf;
    lanc.DisposeOf;
  end;

end;

procedure TfrmResumo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TcloseAction.caFree;
  frmResumo := nil;
end;

procedure TfrmResumo.FormShow(Sender: TObject);
begin
  montarResumo;
end;

procedure TfrmResumo.imgVoltarContaClick(Sender: TObject);
begin
  close;
end;

end.
