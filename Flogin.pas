unit Flogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.Layouts, FMX.StdCtrls,
  FMX.TabControl, System.Math.Vectors, FMX.Controls3D, FMX.Layers3D,
  System.Actions, FMX.ActnList, u99Permissions, FMX.MediaLibrary,FireDac.Comp.Client, FireDac.DApt,
  FMX.MediaLibrary.Actions,

  {$IFDEF ANDROID}
  FMX.VirtualKeyboard, FMX.Platform,
  {$ENDIF}

  FMX.StdActns;


type
  TfrmLogin = class(TForm)
    Layout: TLayout;
    imgLoginLogo: TImage;
    LayoutEmail: TLayout;
    RoundRect1: TRoundRect;
    edtLoginEmail: TEdit;
    StyleBook1: TStyleBook;
    LayoutSenha: TLayout;
    RoundRect2: TRoundRect;
    edtLoginSenha: TEdit;
    LayoutAcessar: TLayout;
    recLogin: TRoundRect;
    Label1: TLabel;
    TabEscolher: TTabControl;
    tabLogin: TTabItem;
    tabConta: TTabItem;
    Layout1: TLayout;
    Image1: TImage;
    Layout2: TLayout;
    RoundRect4: TRoundRect;
    edtCadNome: TEdit;
    Layout3: TLayout;
    RoundRect5: TRoundRect;
    edtCadSenha: TEdit;
    Layout4: TLayout;
    rectContaProximo: TRoundRect;
    edtProximoFoto: TLabel;
    Layout5: TLayout;
    RoundRect7: TRoundRect;
    edtCadEmail: TEdit;
    TabFoto: TTabItem;
    Layout6: TLayout;
    Layout7: TLayout;
    RoundRect8: TRoundRect;
    Label4: TLabel;
    TabEscolha: TTabItem;
    Layout8: TLayout;
    Label5: TLabel;
    Layout3D1: TLayout3D;
    Layout9: TLayout;
    imgVoltarConta: TImage;
    Layout10: TLayout;
    voltarEscolhaFoto: TImage;
    Layout11: TLayout;
    Layout12: TLayout;
    lblLogin: TLabel;
    lblConta: TLabel;
    Rectangle1: TRectangle;
    ActionList1: TActionList;
    actConta: TChangeTabAction;
    actEscolha: TChangeTabAction;
    actFoto: TChangeTabAction;
    actLogin: TChangeTabAction;
    Layout13: TLayout;
    Layout14: TLayout;
    lblContaLogin: TLabel;
    lblEfetivarConta: TLabel;
    Rectangle2: TRectangle;
    actLibrary: TTakePhotoFromLibraryAction;
    actCamera: TTakePhotoFromCameraAction;
    cEditarFoto: TCircle;
    imgLibrary: TImage;
    imgFoto: TImage;
    Layout15: TLayout;
    Rotation: TImage;
    Timer1: TTimer;
    procedure lblContaClick(Sender: TObject);
    procedure lblContaLoginClick(Sender: TObject);
    procedure imgVoltarContaClick(Sender: TObject);
    procedure edtProximoFotoClick(Sender: TObject);
    procedure cEditarFotoClick(Sender: TObject);
    procedure voltarEscolhaFotoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgLibraryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: WideChar;
      Shift: TShiftState);
    procedure recLoginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actLibraryDidFinishTaking(Image: TBitmap);
    procedure RotationClick(Sender: TObject);
    procedure RoundRect8Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private declarations }
    permissao: T99Permissions;
    procedure TrataErroPermissao(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses FPrincipal, cUser, FUniMainModule, cLancamento, cCategorias;
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.Windows.fmx MSWINDOWS}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}

procedure TfrmLogin.lblContaLoginClick(Sender: TObject);
begin
  actLogin.Execute;
end;

procedure TfrmLogin.recLoginClick(Sender: TObject);
VAR
  U: TUser;
  erro: string;
begin
  try
    u := TUser.Create(dm.conn);
    u.EMAIL := edtLoginEmail.Text;
    u.SENHA := edtLoginSenha.Text;

    if not u.validarLogin(erro) then
    begin
      ShowMessage(erro);
      exit;
    end;

  finally
    u.DisposeOf;
  end;

  if NOT Assigned(frmPrincipal)  then
    Application.CreateForm(TfrmPrincipal, frmPrincipal);

  Application.MainForm := frmPrincipal;
  frmPrincipal.Show;
  frmLogin.Close;
end;

procedure TfrmLogin.RoundRect8Click(Sender: TObject);
VAR
  U: TUser;
  erro: string;
begin
  try
    u := TUser.Create(dm.conn);
    u.NOME :=  edtCadNome.Text;
    u.EMAIL := edtCadEmail.Text;
    u.SENHA := edtCadSenha.Text;
    u.IND_LOGIN := 'S';

    u.FOTO := cEditarFoto.Fill.Bitmap.Bitmap;

    if not u.Excluir(erro) then
    begin
      ShowMessage(erro);
      exit;
    end;

    if not u.ExcluirTodosLancamentos(erro) then
    begin
      ShowMessage(erro);
      exit;
    end;

    if not u.ExcluirTodasCategorias(erro) then
    begin
      ShowMessage(erro);
      exit;
    end;

    if not u.Inserir(erro) then
    begin
      ShowMessage(erro);
      exit;
    end;

  finally
    u.DisposeOf;
  end;

  if NOT Assigned(frmPrincipal)  then
    Application.CreateForm(TfrmPrincipal, frmPrincipal);

  Application.MainForm := frmPrincipal;
  frmPrincipal.Show;
  cEditarFoto.Tag := 0;
  frmLogin.Close;
end;

procedure TfrmLogin.Timer1Timer(Sender: TObject);
var
  u: TUser;
  erro: string;
  qry: TFDQuery;
begin
  Timer1.Enabled := False;

  try
    u := TUser.Create(dm.conn);
    qry := TFDQuery.Create(nil);

    qry := u.ListarUsuario(erro);

    if qry.FieldByName('IND_LOGIN').AsString <> 'S' then
    exit;

  finally
    u.DisposeOf;
    qry.DisposeOf;
  end;

  if NOT Assigned(frmPrincipal)  then
    Application.CreateForm(TfrmPrincipal, frmPrincipal);

  Application.MainForm := frmPrincipal;
  frmPrincipal.Show;
  frmLogin.Close;
end;

procedure TfrmLogin.TrataErroPermissao(Sender: TObject);
begin
  showmessage('Você não possui permissão de acesso para esse recurso!')
end;

procedure TfrmLogin.actLibraryDidFinishTaking(Image: TBitmap);
begin
  cEditarFoto.Fill.Bitmap.Bitmap := Image;
  ActFoto.Execute;
  Rotation.Visible := True;
  cEditarFoto.Tag := 1;
end;

procedure TfrmLogin.cEditarFotoClick(Sender: TObject);
begin
  actEscolha.Execute;
end;

procedure TfrmLogin.edtProximoFotoClick(Sender: TObject);
begin
 actFoto.Execute;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmLogin := nil;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  permissao := T99Permissions.Create;
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
  permissao.DisposeOf;
end;

procedure TfrmLogin.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
{$IFDEF ANDROID}
var
    FService : IFMXVirtualKeyboardService;
{$ENDIF}

begin
    {$IFDEF ANDROID}
    if (Key = vkHardwareBack) then
    begin
        TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
                                                          IInterface(FService));

        if (FService <> nil) and
           (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
        begin
            // Botao back pressionado e teclado visivel...
            // (apenas fecha o teclado)
        end
        else
        begin
            // Botao back pressionado e teclado NAO visivel...

            if TabEscolher.ActiveTab = TabConta then
            begin
                Key := 0;
                ActLogin.Execute
            end
            else if TabEscolher.ActiveTab = TabFoto then
            begin
                Key := 0;
                ActConta.Execute
            end
            else if TabEscolher.ActiveTab = TabEscolha then
            begin
                Key := 0;
                ActFoto.Execute;
            end;
        end;
    end;
    {$ENDIF}
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  TabEscolher.ActiveTab := tabLogin;
  Timer1.Enabled := true;
  if cEditarFoto.Tag <> 0 then
  cEditarFoto.Tag := 0;
end;

procedure TfrmLogin.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  TabEscolher.Margins.Bottom := 0;
end;

procedure TfrmLogin.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  TabEscolher.Margins.Bottom := 160;
end;

procedure TfrmLogin.RotationClick(Sender: TObject);
begin
  cEditarFoto.Fill.Bitmap.Bitmap.Rotate(90);
end;

procedure TfrmLogin.voltarEscolhaFotoClick(Sender: TObject);
begin
  actFoto.Execute;
end;

procedure TfrmLogin.imgLibraryClick(Sender: TObject);
begin
 permissao.PhotoLibrary(actLibrary, TrataErroPermissao);
end;

procedure TfrmLogin.imgVoltarContaClick(Sender: TObject);
begin
  actConta.Execute;
end;

procedure TfrmLogin.lblContaClick(Sender: TObject);
begin
  actConta.Execute;
end;

end.
