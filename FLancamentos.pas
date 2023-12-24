unit FLancamentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D, FireDac.Comp.Client, FireDac.DApt, Data.db, DateUtils;

type
  TfrmLancamentos = class(TForm)
    Layout1: TLayout;
    imgVoltarLancamento: TLabel;
    imgVoltarConta: TImage;
    Layout2: TLayout;
    imgAnterior: TImage;
    imgProximo: TImage;
    Rectangle3: TRectangle;
    lblMes: TLabel;
    Rectangle1: TRectangle;
    Layout3: TLayout;
    lblReceitas: TLabel;
    lblDespesas: TLabel;
    lblSaldo: TLabel;
    imgLancamento: TImage;
    lv_lancamento: TListView;
    Layout4: TLayout;
    Label5: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    img_resumo: TImage;
    procedure imgVoltarContaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_lancamentoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure imgLancamentoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgProximoClick(Sender: TObject);
    procedure imgAnteriorClick(Sender: TObject);
    procedure img_resumoClick(Sender: TObject);
  private
    dtFiltro: TDate;
    procedure abrirLancamento(idLancamento: string);
    procedure listarLancamentos;
    procedure navegarMes(numMes: integer);
    function nomeMes: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLancamentos: TfrmLancamentos;

implementation

{$R *.fmx}

uses FPrincipal, FCadastroLancamentos, cLancamento, FUniMainModule, FResumo;

function TfrmLancamentos.nomeMes(): string;
begin
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

  Result := Result + ' / ' + YearOf(dtFiltro).ToString;
end;

procedure TfrmLancamentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action := TCloseAction.caFree;
  //frmLancamentos := nil;
end;

procedure TfrmLancamentos.FormShow(Sender: TObject);
begin
  dtFiltro := Date;
  navegarMes(0);
end;

procedure TfrmLancamentos.navegarMes(numMes: integer);
begin
  dtFiltro :=  IncMonth(dtFiltro, numMes);
  lblMes.Text := nomeMes;
  listarLancamentos;
end;

procedure TfrmLancamentos.listarLancamentos;
var
  foto: TStream;
  lanc: TLancamento;
  qry: TFDQuery;
  erro: string;
  vlReceitas, vlDespesas: double;
begin
  try
    frmLancamentos.lv_lancamento.Items.Clear;
     vlReceitas := 0;
     vlDespesas := 0;

    lanc := TLancamento.Create(dm.conn);
    lanc.DATADE := FormatDateTime('YYYY-MM-DD', StartOfTheMonth(dtFiltro));
    lanc.DATAATE := FormatDateTime('YYYY-MM-DD', EndOfTheMonth(dtFiltro));
    qry := lanc.ListarLancamento(0, erro);

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

      frmPrincipal.addLancamentos(frmLancamentos.lv_lancamento, qry.FieldByName('ID_LANCAMENTO').AsString, qry.FieldByName('DESCRICAO').AsString, qry.FieldByName('DESCRICAO_CATEGORIA').AsString, qry.FieldByName('VALOR').AsFloat, qry.FieldByName('DATALANCAMENTO').AsDateTime, foto);

      if qry.FieldByName('VALOR').AsFloat > 0 then
        vlReceitas := vlReceitas + qry.FieldByName('VALOR').AsFloat
      else
        vlDespesas := vlDespesas + qry.FieldByName('VALOR').AsFloat;

      qry.Next;

      foto.DisposeOf;
    end;

    lblReceitas.Text := FormatFloat('#,##0.00', vlReceitas);
    lblDespesas.Text := FormatFloat('#,##0.00', vlDespesas);
    lblSaldo.Text := FormatFloat('#,##0.00', vlReceitas + vlDespesas); // somamos pq o vlDespesas ja está negativo...
  finally
    lanc.DisposeOf;
  end;
end;

procedure TfrmLancamentos.imgAnteriorClick(Sender: TObject);
begin
  navegarMes(-1);
end;

procedure TfrmLancamentos.imgLancamentoClick(Sender: TObject);
begin
  abrirLancamento('');
end;

procedure TfrmLancamentos.imgProximoClick(Sender: TObject);
begin
  navegarMes(1);
end;

procedure TfrmLancamentos.imgVoltarContaClick(Sender: TObject);
begin
  close;
end;

procedure TfrmLancamentos.img_resumoClick(Sender: TObject);
begin
 if NOT Assigned(frmResumo) then
        Application.CreateForm(TfrmResumo, frmResumo);

    frmResumo.lblMes.Text := FrmLancamentos.lblMes.Text;
    frmResumo.dtFiltro := FrmLancamentos.dtFiltro;
    frmResumo.Show;
end;

procedure TfrmLancamentos.abrirLancamento(idLancamento: string);
begin
  if not assigned(frmCadastroLancamentos) then
  Application.CreateForm(TfrmCadastroLancamentos, frmCadastroLancamentos);

  if idLancamento <> '' then
  begin
    frmCadastroLancamentos.modo := 'A';
    frmCadastroLancamentos.id_Lanc := idLancamento.ToInteger;
  end
  else
  begin
    frmCadastroLancamentos.modo := 'I';
    frmCadastroLancamentos.id_Lanc := 0;
  end;


  frmCadastroLancamentos.ShowModal(procedure(ModalResult: TModalResult)
  begin
    listarLancamentos;
  end);
end;

procedure TfrmLancamentos.lv_lancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin

  abrirLancamento(AItem.TagString);

end;

procedure TfrmLancamentos.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  frmPrincipal.setupLancamento(frmLancamentos.lv_lancamento, AItem);
end;

end.
