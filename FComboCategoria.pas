unit FComboCategoria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances,FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TfrmComboCategoria = class(TForm)
    Layout1: TLayout;
    imgNovaCategoria: TLabel;
    imgVoltarConta: TImage;
    lvCategorias: TListView;
    procedure imgVoltarContaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvCategoriasItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure listarCategoria;
    { Private declarations }
  public
    { Public declarations }
    CategoriaSelecao: string;
    IdCategoriaSelecao: Integer;
  end;

var
  frmComboCategoria: TfrmComboCategoria;

implementation

{$R *.fmx}

uses FPrincipal, cCategorias, FUniMainModule, Data.DB;

procedure TfrmComboCategoria.listarCategoria;
var
 cat: TCategoria;
 qry: TFDQuery;
 erro: string;
 icone: Tstream;
begin
  try
    lvCategorias.Items.Clear;
    cat := TCategoria.Create(dm.conn);
    qry := cat.ListarCategoria(erro);

    while NOT qry.Eof do
    begin
      if qry.FieldByName('ICONE').AsString <> '' then
      begin
        icone := qry.CreateBlobStream(qry.FieldByName('ICONE'), TBlobStreamMode.bmRead)
      end
      else
      icone := nil;

      frmPrincipal.addCategoria(frmComboCategoria.lvCategorias, qry.FieldByName('ID_CATEGORIA').AsString, qry.FieldByName('DESCRICAO').AsString, icone);

      if icone <> nil then
        icone.DisposeOf;

      qry.Next;
    end;

  finally
    qry.DisposeOf;
    cat.DisposeOf;
  end;

end;

procedure TfrmComboCategoria.lvCategoriasItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
   IdCategoriaSelecao := Aitem.TagString.ToInteger;
   CategoriaSelecao := TListItemText(Aitem.Objects.FindDrawable('txtCategoria')).Text;
   close;
end;

procedure TfrmComboCategoria.FormShow(Sender: TObject);
begin
  listarCategoria;
end;

procedure TfrmComboCategoria.imgVoltarContaClick(Sender: TObject);
begin
  idCategoriaSelecao := 0;
  categoriaSelecao := '';
  close;
end;

end.
