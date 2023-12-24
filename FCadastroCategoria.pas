unit FCadastroCategoria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.ListBox, FMX.DialogService;

type
  TfrmCadastroCategoria = class(TForm)
    Layout1: TLayout;
    imgNovaCategoria: TLabel;
    imgVoltarConta: TImage;
    imgSave: TImage;
    Layout2: TLayout;
    lblTituloCategoria: TLabel;
    edtDesCategoria: TEdit;
    Line1: TLine;
    Label1: TLabel;
    lbIcone: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    imgSelecao: TImage;
    recExcluir: TRectangle;
    imgExcluirCategoria: TImage;
    procedure imgVoltarContaClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgSaveClick(Sender: TObject);
    procedure imgExcluirCategoriaClick(Sender: TObject);
  private
    iconeSelecionado: TBitMap;
    iconeIndiceSelecionado: Integer;
    procedure selecionaIcone(img: Timage);

    { Private declarations }
  public
    { Public declarations }
    modo: string;
    id_cat: integer;
  end;

var
  frmCadastroCategoria: TfrmCadastroCategoria;

implementation

{$R *.fmx}

uses FPrincipal, cCategorias, FireDAC.Comp.Client, FUniMainModule, FCategorias;

procedure TfrmCadastroCategoria.selecionaIcone(img: Timage);
begin
  iconeSelecionado := img.Bitmap;
  iconeIndiceSelecionado := TListBoxItem(img.Parent).Index;
  imgSelecao.Parent := img.Parent;
end;

procedure TfrmCadastroCategoria.FormResize(Sender: TObject);
begin
  lbIcone.Columns := Trunc(lbIcone.Width / 80);

end;

procedure TfrmCadastroCategoria.FormShow(Sender: TObject);
var
 cat: TCategoria;
 qry: TFDQuery;
 erro: string;
 item: TListBoxItem;
 img: Timage;
begin
  if modo = 'I' then
  begin
    edtDesCategoria.Text := '';
    selecionaIcone(Image1);
    recExcluir.Visible := false;
  end
  else
  begin
    try
      cat := TCategoria.Create(dm.conn);
      cat.ID_CATEGORIA := id_cat;
      qry := cat.ListarCategoria(erro);

      edtDesCategoria.Text := qry.FieldByName('DESCRICAO').AsString;

      item := lbIcone.ItemByIndex(qry.FieldByName('ICONE_INDICE').AsInteger);
      imgSelecao.Parent := item;
      recExcluir.Visible := true;

      img := frmCadastroCategoria.FindComponent('Image' + (item.Index + 1).ToString) as TImage;
      selecionaIcone(img);
    finally
      qry.DisposeOf;
      cat.DisposeOf;
    end;
  end;
end;

procedure TfrmCadastroCategoria.Image1Click(Sender: TObject);
begin
 selecionaIcone(Timage(Sender));
end;

procedure TfrmCadastroCategoria.imgExcluirCategoriaClick(Sender: TObject);
var
  cat: TCategoria;
  erro: string;
begin
  TDialogService.MessageDialog('Confirma exclusão da categoria?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
   procedure(const AResult: TModalResult)
   var
      erro: string;
   begin
      if AResult = mrYes then
      begin
        try
          cat := TCategoria.Create(dm.conn);
          cat.ID_CATEGORIA := id_cat;

          if not cat.Excluir(erro) then
          begin
            showmessage(erro);
            exit;
          end;

          frmCategorias.listarCategoria;
          close;
        finally
          cat.DisposeOf;
        end;
      end;
   end);

end;

procedure TfrmCadastroCategoria.imgSaveClick(Sender: TObject);
var
 cat: TCategoria;
 erro: string;
begin
  try
    cat := TCategoria.Create(dm.conn);
    CAT.DESCRICAO := edtDesCategoria.Text;
    cat.ICONE := iconeSelecionado;
    cat.ICONE_INDICE := iconeIndiceSelecionado;
    if MODO = 'I' then
    cat.Inserir(erro)
    else
    begin
      cat.ID_CATEGORIA := id_cat;
      cat.Alterar(erro);
    end;

    if erro <> '' then
    begin
      ShowMessage(erro);
      exit;
    end;
    frmCategorias.listarCategoria;
    close;
  finally
    cat.DisposeOf;
  end;
end;

procedure TfrmCadastroCategoria.imgVoltarContaClick(Sender: TObject);
begin
  close;
end;

end.
