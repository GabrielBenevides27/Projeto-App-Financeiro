program ProjetoMoney;

uses
  System.StartUpCopy,
  FMX.Forms,
  Flogin in 'Flogin.pas' {frmLogin},
  u99Permissions in 'Units\u99Permissions.pas',
  FPrincipal in 'FPrincipal.pas' {frmPrincipal},
  FLancamentos in 'FLancamentos.pas' {frmLancamentos},
  FCadastroLancamentos in 'FCadastroLancamentos.pas' {frmCadastroLancamentos},
  FCategorias in 'FCategorias.pas' {frmCategorias},
  FCadastroCategoria in 'FCadastroCategoria.pas' {frmCadastroCategoria},
  FUniMainModule in 'FUniMainModule.pas' {dm: TDataModule},
  cCategorias in 'Classes\cCategorias.pas',
  cLancamento in 'Classes\cLancamento.pas',
  uFormat in 'Units\uFormat.pas',
  cUser in 'Classes\cUser.pas',
  FComboCategoria in 'FComboCategoria.pas' {frmComboCategoria},
  FResumo in 'FResumo.pas' {frmResumo},
  FRotinas in 'FRotinas.pas' {frmRotinas},
  FPlanejamento in 'FPlanejamento.pas' {frmPlanejamento},
  cPlanejamento in 'Classes\cPlanejamento.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmRotinas, frmRotinas);
  Application.CreateForm(TfrmPlanejamento, frmPlanejamento);
  Application.Run;
end.
