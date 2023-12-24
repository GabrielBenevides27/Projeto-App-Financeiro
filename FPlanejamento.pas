unit FPlanejamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TfrmPlanejamento = class(TForm)
    Layout2: TLayout;
    imgAnterior: TImage;
    imgProximo: TImage;
    Rectangle3: TRectangle;
    lblMes: TLabel;
    Layout1: TLayout;
    imgVoltarLancamento: TLabel;
    imgVoltarConta: TImage;
    img_resumo: TImage;
    Rectangle1: TRectangle;
    Layout3: TLayout;
    lblReceitas: TLabel;
    lblDespesas: TLabel;
    lblSaldo: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Layout4: TLayout;
    imgLancamento: TImage;
    lv_lancamento: TListView;
    procedure imgVoltarContaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPlanejamento: TfrmPlanejamento;

implementation

{$R *.fmx}

procedure TfrmPlanejamento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmPlanejamento := nil;
end;

procedure TfrmPlanejamento.imgVoltarContaClick(Sender: TObject);
begin
  close;
end;

end.
