unit FCategorias;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TfrmCategorias = class(TForm)
    Layout1: TLayout;
    imgCategorias: TLabel;
    imgVoltarConta: TImage;
    Rectangle1: TRectangle;
    Layout4: TLayout;
    imgLancamento: TImage;
    lvCategorias: TListView;
    Layout3: TLayout;
    lblCategoria: TLabel;
    procedure imgVoltarContaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lvCategoriasUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure imgLancamentoClick(Sender: TObject);
    procedure lvCategoriasItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    
  private

    { Private declarations }
  public
    { Public declarations }
    procedure cadastroCategoria(idCategoria: string);
    procedure listarCategoria;
  end;

var
  frmCategorias: TfrmCategorias;

implementation

{$R *.fmx}

uses FPrincipal, FCadastroCategoria, FUniMainModule, cCategorias;

procedure TfrmCategorias.listarCategoria;
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

      frmPrincipal.addCategoria(lvCategorias, qry.FieldByName('ID_CATEGORIA').AsString, qry.FieldByName('DESCRICAO').AsString, icone);

      if icone <> nil then
        icone.DisposeOf;

      qry.Next;
    end;

    if lvCategorias.Items.Count = 1 then
      lblCategoria.Text := '1 Categoria'
    else
      lblCategoria.Text := lvCategorias.Items.Count.ToString + ' Categorias';

  finally
    qry.DisposeOf;
    cat.DisposeOf;
  end;

end;

procedure TfrmCategorias.cadastroCategoria(idCategoria: string);
begin
  if not Assigned(frmCadastroCategoria) then
    Application.CreateForm(TfrmCadastroCategoria, frmCadastroCategoria);

  if idCategoria = '' then
  begin
    frmCadastroCategoria.id_cat := 0;
    frmCadastroCategoria.modo := 'I'; //Inclusão
    frmCadastroCategoria.lblTituloCategoria.text := 'Nova Categoria'
  end
  else
  begin
    frmCadastroCategoria.id_cat := idCategoria.tointeger;
    frmCadastroCategoria.modo := 'A'; //Alteração
    frmCadastroCategoria.lblTituloCategoria.text := 'Editar Categoria';
  end;

  frmCadastroCategoria.Show;
end;

procedure TfrmCategorias.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmCategorias := nil;
end;

procedure TfrmCategorias.FormShow(Sender: TObject);
begin
  listarCategoria;
end;

procedure TfrmCategorias.imgLancamentoClick(Sender: TObject);
begin
  cadastroCategoria('');
end;

procedure TfrmCategorias.imgVoltarContaClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCategorias.lvCategoriasItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
 cadastroCategoria(AItem.TagString);
end;

procedure TfrmCategorias.lvCategoriasUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  frmPrincipal.setupCategoria(lvCategorias, AItem);
end;

end.
