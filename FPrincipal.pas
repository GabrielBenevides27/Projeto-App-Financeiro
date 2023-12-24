unit FPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Ani, FireDac.Comp.Client, FireDac.DApt, Data.db;

type
  TfrmPrincipal = class(TForm)
    Layout1: TLayout;
    imgMenu: TImage;
    iconFoto: TCircle;
    Image1: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    Label2: TLabel;
    lblSaldo: TLabel;
    lblMes: Tlabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Image2: TImage;
    lblReceitas: TLabel;
    Label5: TLabel;
    Layout6: TLayout;
    Image3: TImage;
    lblDespesas: TLabel;
    Label7: TLabel;
    Rectangle1: TRectangle;
    imgAdd: TImage;
    Rectangle2: TRectangle;
    Layout7: TLayout;
    Label8: TLabel;
    lblVerTodos: TLabel;
    lv_lancamento: TListView;
    imgCategoria: TImage;
    StyleBook1: TStyleBook;
    recMenu: TRectangle;
    layoutPrincipal: TLayout;
    animationMenu: TFloatAnimation;
    layout_menu_cat: TLayout;
    Label9: TLabel;
    img_fechar_menu: TImage;
    Layout8: TLayout;
    Label10: TLabel;
    Layout9: TLayout;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lblVerTodosClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure animationMenuFinish(Sender: TObject);
    procedure animationMenuProcess(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure img_fechar_menuClick(Sender: TObject);
    procedure imgAddClick(Sender: TObject);
    procedure lv_lancamentoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure Label10Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
    procedure listarUltLanc;
    procedure montaPainel;
    procedure carregaIcone;
    { Private declarations }
  public
    { Public declarations }
    procedure addLancamentos(listview: TlistView; id_lancamento, descricao, categoria: string; valor: double; dt: TDateTime;
       foto: TStream);

    procedure setupLancamento(lv: TlistView; Item: TlistViewItem);

    procedure addCategoria(listview: TlistView; id_categoria, categoria: string;
      foto: TStream);

    procedure setupCategoria(lv: TlistView; Item: TlistViewItem);


  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses FLancamentos, FCategorias, cLancamento, FUniMainModule,
  FCadastroLancamentos, cUser, Flogin, System.DateUtils, FRotinas,
  FPlanejamento;

procedure TfrmPrincipal.carregaIcone;
var
  u: TUser;
  qry: TFDQuery;
  erro: string;
  foto: TStream;
begin
  try
      u := TUser.Create(dm.conn);
      qry := u.ListarUsuario(erro);

      if erro <> '' then
      begin
        ShowMessage(erro);
        exit;
      end;

      if qry.FieldByName('FOTO').AsString <> '' then
        foto := qry.CreateBlobStream(qry.FieldByName('FOTO'), TBlobStreamMode.bmRead)
      else
        foto := nil;

      if foto <> nil then
      begin
        iconFoto.Fill.Bitmap.Bitmap.LoadFromStream(foto);
        foto.DisposeOf;
      end;

  finally
      u.DisposeOf;
      qry.DisposeOf;
  end;

end;

procedure TfrmPrincipal.montaPainel;
var
  lanc: TLancamento;
  qry: TFDQuery;
  erro: string;
  vlReceita, vlDespesas: double;
begin
  try
    lanc := TLancamento.Create(dm.conn);
    lanc.DATADE := FormatDateTime('YYYY-MM-DD', StartOfTheMonth(date));
    lanc.DATAATE := FormatDateTime('YYYY-MM-DD', EndOfTheMonth(date));
    qry := lanc.ListarLancamento(0, erro);

    if erro <> '' then
    begin
      ShowMessage(erro);
      exit;
    end;

    vlReceita := 0;
    vlDespesas := 0;

    while not qry.Eof do
    begin

      if qry.FieldByName('VALOR').AsFloat > 0 then
        vlReceita := vlReceita + qry.FieldByName('VALOR').AsFloat
      else
        vlDespesas := vlDespesas + qry.FieldByName('VALOR').AsFloat;

      qry.Next;
    end;

    lblReceitas.Text := FormatFloat('#,##0.00', vlReceita);
    lblDespesas.Text := FormatFloat('#,##0.00', vlDespesas);
    lblSaldo.Text := FormatFloat('#,##0.00', vlReceita + vlDespesas);

  finally
    lanc.DisposeOf;
    qry.DisposeOf;
  end;
end;


procedure TfrmPrincipal.setupCategoria(lv: TlistView; Item: TlistViewItem);
var
  txt :TListItemText;
begin
  txt := TListItemText(Item.Objects.FindDrawable('txtCategoria'));
  txt.Width := self.Width - txt.PlaceOffset.X - 100;

end;

procedure TfrmPrincipal.addCategoria(listview: TlistView; id_categoria, categoria: string; foto: TStream);
var
  txt: TListItemText;
  img: TListItemImage;
  bmp: TBitmap;
begin
  with listview.Items.Add do
  begin
    TagString := id_categoria;

    txt := TListItemText(Objects.FindDrawable('txtCategoria'));
    txt.Text := categoria;

    img := TListItemImage(Objects.FindDrawable('imgIcone'));

    if foto <> nil then
    begin
      bmp := TBitmap.Create;
      bmp.LoadFromStream(foto);

      img.OwnsBitmap := true;
      img.Bitmap := bmp;
    end;
  end;
end;

procedure TfrmPrincipal.addLancamentos(listview: TlistView; id_lancamento, descricao, categoria: string; valor: double; dt: TDateTime;  foto: TStream);
var
  txt: TListItemText;
  img: TListItemImage;
  bmp: TBitmap;
begin
  with listview.Items.Add do
  begin
    TagString := id_lancamento;

    txt := TListItemText(Objects.FindDrawable('TxtDescricao'));
    txt.Text := descricao;

    TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;
    TListItemText(Objects.FindDrawable('TxtValor')).Text := FormatFloat('#,##0.00', valor);
    TListItemText(Objects.FindDrawable('TxtData')).Text := FormatDateTime('dd/mm', dt);

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

procedure TfrmPrincipal.animationMenuFinish(Sender: TObject);
begin
  layoutPrincipal.Enabled := AnimationMenu.Inverse;
  animationMenu.Inverse := not animationMenu.Inverse;
end;

procedure TfrmPrincipal.animationMenuProcess(Sender: TObject);
begin
 layoutPrincipal.Margins.Right := -310 - recMenu.Margins.Left;
end;

procedure TfrmPrincipal.setupLancamento(lv: TlistView; Item: TlistViewItem);
var
  txt :TListItemText;
begin
  txt := TListItemText(Item.Objects.FindDrawable('TxtDescricao'));
  txt.Width := self.Width - txt.PlaceOffset.X - 100;

end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(frmLancamentos) then
  begin
    frmLancamentos.DisposeOf;
    frmLancamentos := nil;
  end;

  action := TCloseAction.caFree;
  frmPrincipal := nil;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  recMenu.Visible := True;
  recMenu.Align := TAlignLayout.Left;
  recMenu.Margins.Left := -310;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
 listarUltLanc;
 carregaIcone;
 lblMes.Text := frmRotinas.nomeMes;
end;

procedure TfrmPrincipal.imgAddClick(Sender: TObject);
begin
  if not assigned(frmCadastroLancamentos) then
  Application.CreateForm(TfrmCadastroLancamentos, frmCadastroLancamentos);

  frmCadastroLancamentos.modo := 'I';
  frmCadastroLancamentos.id_Lanc := 0;
  frmCadastroLancamentos.ShowModal(procedure(ModalResult: TModalResult)
  begin
    listarUltLanc;
  end);
end;

procedure TfrmPrincipal.listarUltLanc;
var
  foto: TStream;
  x : integer;

  lanc: TLancamento;
  qry: TFDQuery;
  erro: string;
begin
  try
    lv_lancamento.Items.Clear;

    lanc := TLancamento.Create(dm.conn);
    qry := lanc.ListarLancamento(10, erro);


    if erro <> '' then
    begin
      ShowMessage(erro);
      exit;
    end;

    while not qry.Eof do
    begin
      if qry.FieldByName('ICONE').AsString <> '' then
        foto := qry.CreateBlobStream(qry.FieldByName('ICONE'), TBlobStreamMode.bmRead)
      else
       foto := nil;

      addLancamentos(frmPrincipal.lv_lancamento, qry.FieldByName('ID_LANCAMENTO').AsString, qry.FieldByName('DESCRICAO').AsString, qry.FieldByName('DESCRICAO_CATEGORIA').AsString, qry.FieldByName('VALOR').AsFloat, qry.FieldByName('DATALANCAMENTO').AsDateTime, foto);

      qry.Next;

      foto.DisposeOf;
    end;

  finally
    lanc.DisposeOf;
  end;

  montaPainel;
end;

procedure TfrmPrincipal.imgMenuClick(Sender: TObject);
begin
  animationMenu.Start;
end;

procedure TfrmPrincipal.img_fechar_menuClick(Sender: TObject);
begin
  AnimationMenu.Start;
end;

procedure TfrmPrincipal.Label10Click(Sender: TObject);
var
  u: TUser;
  erro: string;
begin
  try
    u := TUser.Create(dm.conn);

    if not u.logout(erro) then
    exit;

  finally
    u.DisposeOf;
  end;

  if NOT Assigned(frmLogin) then
  Application.CreateForm(TfrmLogin, frmLogin);

  Application.MainForm := frmLogin;
  frmLogin.Show;
  frmPrincipal.Close;
end;

procedure TfrmPrincipal.Label3Click(Sender: TObject);
begin
  AnimationMenu.Start;

  if not Assigned(frmPlanejamento) then
  Application.CreateForm(TfrmPlanejamento, frmPlanejamento);

  frmPlanejamento.Show;
end;

procedure TfrmPrincipal.Label9Click(Sender: TObject);
begin
   AnimationMenu.Start;

  if not Assigned(frmCategorias) then
  Application.CreateForm(TfrmCategorias, frmCategorias);

  frmCategorias.Show;
end;

procedure TfrmPrincipal.lblVerTodosClick(Sender: TObject);
begin
  if not Assigned(frmLancamentos) then
  Application.CreateForm(TfrmLancamentos, frmLancamentos);

  frmLancamentos.Show;
end;

procedure TfrmPrincipal.lv_lancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if not assigned(frmCadastroLancamentos) then
  Application.CreateForm(TfrmCadastroLancamentos, frmCadastroLancamentos);

    frmCadastroLancamentos.modo := 'A';
    frmCadastroLancamentos.id_Lanc := AItem.TagString.ToInteger;

  frmCadastroLancamentos.ShowModal(procedure(ModalResult: TModalResult)
  begin
    listarUltLanc;
  end);

end;

procedure TfrmPrincipal.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  setupLancamento(frmPrincipal.lv_lancamento,AItem);
end;

end.
