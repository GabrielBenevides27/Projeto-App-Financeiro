unit FCadastroLancamentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  FMX.DateTimeCtrls, FMX.ListBox, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uFormat, FMX.DialogService;

type
  TfrmCadastroLancamentos = class(TForm)
    Layout1: TLayout;
    imgNovaDespesa: TLabel;
    imgVoltarConta: TImage;
    imgSave: TImage;
    recDelete: TRectangle;
    imgDelete: TImage;
    Layout2: TLayout;
    Label1: TLabel;
    edtDescricao: TEdit;
    Line1: TLine;
    Layout4: TLayout;
    Label3: TLabel;
    Layout5: TLayout;
    Label4: TLabel;
    edtValor: TEdit;
    Line4: TLine;
    imgDespesas: TImage;
    imgTipoLanc: TImage;
    imgReceitas: TImage;
    Layout6: TLayout;
    Label5: TLabel;
    Line3: TLine;
    dtLanc: TDateEdit;
    imgHoje: TImage;
    imgOntem: TImage;
    lblCategoriaSelecao: TLabel;
    Line2: TLine;
    Image1: TImage;
    procedure imgVoltarContaClick(Sender: TObject);
    procedure imgTipoLancClick(Sender: TObject);
    procedure imgHojeClick(Sender: TObject);
    procedure imgOntemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgSaveClick(Sender: TObject);
    procedure edtValorTyping(Sender: TObject);
    procedure imgDeleteClick(Sender: TObject);
    procedure lblCategoriaSelecaoClick(Sender: TObject);
  private
    //procedure comboCategoria;
    { Private declarations }
  public
    { Public declarations }
    modo: string;
    id_Lanc: integer;
  end;

var
  frmCadastroLancamentos: TfrmCadastroLancamentos;

implementation

{$R *.fmx}

uses FPrincipal, cCategorias, FUniMainModule, cLancamento, FCategorias,
  FComboCategoria;
{
procedure TfrmCadastroLancamentos.comboCategoria;
var
    c : TCategoria;
    erro : string;
    qry: TFDQuery;
begin
    try
        cmbCategoria.Items.Clear;

        c := TCategoria.Create(dm.conn);
        qry := c.ListarCategoria(erro);

        if erro <> '' then
        begin
            showmessage(erro);
            exit;
        end;

        while NOT qry.Eof do
        begin
            //cmbCategoria.Items.Add(qry.FieldByName('DESCRICAO').AsString);
            cmbCategoria.Items.AddObject(qry.FieldByName('DESCRICAO').AsString,
            TObject(qry.FieldByName('ID_CATEGORIA').AsInteger));
            qry.Next;
        end;

    finally
        qry.DisposeOf;
        c.DisposeOf;
    end;
end;
}
procedure TfrmCadastroLancamentos.edtValorTyping(Sender: TObject);
begin
  Formatar(edtValor, TFormato.Valor);
end;

procedure TfrmCadastroLancamentos.FormShow(Sender: TObject);
var
  lanc: TLancamento;
  erro: string;
  qry: TFDQuery;
begin
  //comboCategoria;

  if modo = 'I' then
  begin
    edtDescricao.Text := '';
    edtValor.Text := '';
    dtLanc.Date := Date;
    imgTipoLanc.Bitmap := imgDespesas.Bitmap;
    imgTipoLanc.Tag := -1;
    recDelete.Visible := False;
    lblCategoriaSelecao.Text := '';
    lblCategoriaSelecao.Tag := 0;
  end
  else
  begin
    try
      lanc := TLancamento.Create(dm.conn);
      lanc.ID_LANCAMENTO := id_Lanc;
      qry := lanc.ListarLancamento(0, erro);


      if qry.RecordCount = 0 then
      begin
        ShowMessage('Lançamento não encontrado!');
        exit;
      end;

      edtDescricao.Text := qry.FieldByName('DESCRICAO').AsString;
      dtLanc.Date := qry.FieldByName('DATALANCAMENTO').AsDateTime;

      if qry.FieldByName('VALOR').AsFloat < 0 then
      begin
        edtValor.Text := FormatFloat('#,##0.00', qry.FieldByName('VALOR').AsFloat * -1);
        imgTipoLanc.Bitmap := imgDespesas.Bitmap;
        imgTipoLanc.Tag := -1
      end
      else
      begin
        edtValor.Text := FormatFloat('#,##0.00', qry.FieldByName('VALOR').AsFloat);
        imgTipoLanc.Bitmap := imgReceitas.Bitmap;
        imgTipoLanc.Tag := 1;
      end;

      lblCategoriaSelecao.Text := qry.FieldByName('DESCRICAO_CATEGORIA').AsString;
      lblCategoriaSelecao.Tag := qry.FieldByName('ID_CATEGORIA').AsInteger;
      //cmbCategoria.ItemIndex := cmbCategoria.Items.IndexOf(qry.FieldByName('DESCRICAO_CATEGORIA').AsString);
      recDelete.Visible := True;
    finally
      qry.DisposeOf;
      lanc.DisposeOf;
    end;
  end;
end;

procedure TfrmCadastroLancamentos.imgDeleteClick(Sender: TObject);
var
  lanc: TLancamento;
  erro: string;
begin
  TDialogService.MessageDialog('Confirma exclusão do lançamento?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
   procedure(const AResult: TModalResult)
   var
      erro: string;
   begin
      if AResult = mrYes then
      begin
        try
          lanc := TLancamento.Create(dm.conn);
          lanc.ID_LANCAMENTO := id_Lanc;

          if not lanc.Excluir(erro) then
          begin
            showmessage(erro);
            exit;
          end;

          close;
        finally
          lanc.DisposeOf;
        end;
      end;
   end);

end;

procedure TfrmCadastroLancamentos.imgHojeClick(Sender: TObject);
begin
  dtLanc.Date := date;
end;

procedure TfrmCadastroLancamentos.imgOntemClick(Sender: TObject);
begin
  dtLanc.Date := Date - 1;
end;

function TrataValor(str: string): double;
begin
  if str = '' then
  exit;

  str := StringReplace(str, '.', '', [rfReplaceAll]);
  str := StringReplace(str, ',', '', [rfReplaceAll]);

  try
    Result := StrToFloat(str) / 100;
  except
    Result := 0;
  end;

end;

procedure TfrmCadastroLancamentos.imgSaveClick(Sender: TObject);
 var
  lanc: TLancamento;
  erro: string;
begin
  try
    lanc := TLancamento.Create(dm.conn);
    lanc.DESCRICAO := edtDescricao.Text;
    lanc.VALOR :=  TrataValor(edtValor.Text) * imgTipoLanc.Tag;
    lanc.DATALANCAMENTO := dtLanc.Date;
    lanc.ID_CATEGORIA := lblCategoriaSelecao.Tag;

    if modo = 'I' then
    begin
      //lanc.ID_LANCAMENTO := id_Lanc;
      lanc.Inserir(erro);
    end
    else
    begin
      lanc.ID_LANCAMENTO := id_Lanc;
      lanc.Alterar(erro);
    end;

    if erro <> '' then
    begin
      ShowMessage(erro);
      exit;
    end;

    close;

  finally
    lanc.DisposeOf;
  end;
end;

procedure TfrmCadastroLancamentos.imgTipoLancClick(Sender: TObject);
begin
  if imgTipoLanc.Tag = 1 then
  begin
    imgTipoLanc.Bitmap := imgDespesas.Bitmap;
    imgTipoLanc.Tag := -1;
  end
  else
  begin
    imgTipoLanc.Bitmap := imgReceitas.Bitmap;
    imgTipoLanc.Tag := 1;
  end;
end;

procedure TfrmCadastroLancamentos.imgVoltarContaClick(Sender: TObject);
begin
  close;
end;

procedure TfrmCadastroLancamentos.lblCategoriaSelecaoClick(Sender: TObject);
begin
   if NOT Assigned(FrmComboCategoria) then
        Application.CreateForm(TFrmComboCategoria, FrmComboCategoria);

    FrmComboCategoria.ShowModal(procedure(ModalResult: TModalResult)
    begin
        if FrmComboCategoria.IdCategoriaSelecao > 0 then
        begin
            lblCategoriaSelecao.Text := FrmComboCategoria.CategoriaSelecao;
            lblCategoriaSelecao.Tag := FrmComboCategoria.IdCategoriaSelecao;
        end;
    end);
end;

end.
