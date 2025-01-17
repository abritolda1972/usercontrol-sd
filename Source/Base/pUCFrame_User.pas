{ **************************************************************************** }
{ Projeto: Componentes User Control ShowDelphi Edition                         }
{ Biblioteca multiplataforma de componentes Delphi para o controle de usu�rios }
{                                                                              }
{ Baseado nos pacotes Open Source User Control 2.31 RC1                        }
{
Autor da vers�o Original: Rodrigo Alves Cordeiro

Colaboradores da vers�o original
Alexandre Oliveira Campioni - alexandre.rural@netsite.com.br
Bernard Grandmougin
Carlos Guerra
Daniel Wszelaki
Everton Ramos [BS2 Internet]
Francisco Due�as - fduenas@flashmail.com
Germ�n H. Cravero
Luciano Almeida Pimenta [ClubeDelphi.net]
Luiz Benevenuto - luiz@siffra.com
Luiz Fernando Severnini
Peter van Mierlo
Rodolfo Ferezin Moreira - rodolfo.fm@bol.com.br
Rodrigo Palhano (WertherOO)
Ronald Marconi
Sergiy Sekela (Dr.Web)
Stefan Nawrath
Vicente Barros Leonel [ Fknyght ]

*******************************************************************************}
{ Vers�o ShowDelphi Edition                                                    }
{                                                                              }
{ Direitos Autorais Reservados (c) 2015   Giovani Da Cruz                      }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{ Voc� pode obter a �ltima vers�o desse arquivo na pagina do projeto           }
{ User Control ShowDelphi Edition                                              }
{ Componentes localizado em http://infussolucoes.github.io/usercontrol-sd/     }
{                                                                              }
{ Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la  }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{ Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM    }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{ Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto }
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{                                                                              }
{ Comunidade Show Delphi - www.showdelphi.com.br                               }
{                                                                              }
{ Giovani Da Cruz  -  giovani@infus.inf.br  -  www.infus.inf.br                }
{                                                                              }
{ ****************************************************************************** }

{ ******************************************************************************
  |* Historico
  |*
  |* 01/07/2015: Giovani Da Cruz
  |*  - Cria��o e distribui��o da Primeira Versao ShowDelphi
  ******************************************************************************* }

unit pUCFrame_User;

interface

{$I 'UserControl.inc'}

uses
  Variants,
  Buttons,
  Classes,
  Controls,
  DB,
  DBCtrls,
  Dialogs,
  ExtCtrls,
  Forms,
  Graphics,
  Messages,
  StdCtrls,
  SysUtils,
  {$IFDEF FPC}
  {$IFDEF WINDOWS}Windows,{$ELSE}LCLType,{$ENDIF}
  {$ELSE}
  Windows,
  {$ENDIF}
  DBGrids,
  Grids,
  ImgList,
  
  {$IFDEF DELPHIXE8_UP}
  System.UITypes,
  {$ENDIF}

  IncUser_U,
  SenhaForm_U,
  UcBase,
  UserPermis_U, System.ImageList;

type
  TUCFrame_User = class(TFrame)
    Panel3: TPanel;
    btAdic: TBitBtn;
    BtAlt: TBitBtn;
    BtExclui: TBitBtn;
    BtAcess: TBitBtn;
    BtPass: TBitBtn;
    DbGridUser: TDBGrid;
    DataUser: TDataSource;
    DataPerfil: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    Nome: TEdit;
    Login: TEdit;
    Email: TEdit;
    btApplyFilter: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ImageList1: TImageList;
    Shape1: TShape;
    procedure btAdicClick(Sender: TObject);
    procedure BtAltClick(Sender: TObject);
    procedure BtAcessClick(Sender: TObject);
    procedure BtPassClick(Sender: TObject);
    procedure BtExcluiClick(Sender: TObject);
    procedure DbGridUserTitleClick(Column: TColumn);
    procedure btApplyFilterClick(Sender: TObject);
  private
    procedure ChangeButtonFilter;
  protected
    FormSenha: TCustomForm;
    FfrmIncluirUsuario: TfrmIncluirUsuario;
    procedure SetWindowUserProfile;
    procedure SetWindowUser(Adicionar: Boolean);
    procedure ActionBtPermissUserDefault;
    procedure FDataSetCadastroUsuarioAfterScroll(DataSet: TDataSet);
  public
    FUsercontrol: TUserControl;
    FDataSetCadastroUsuario: TDataSet;
    procedure SetWindow;
    destructor Destroy; override;
    { Public declarations }
  end;

implementation

uses
  UCMessages, UCDataInfo;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

procedure TUCFrame_User.btAdicClick(Sender: TObject);
begin
  FfrmIncluirUsuario := TfrmIncluirUsuario.Create(Self);
  FfrmIncluirUsuario.FUsercontrol := Self.FUsercontrol;
  SetWindowUser(True);

  {$IFNDEF FPC}
  Application.NormalizeTopMosts;
  Application.RestoreTopMosts;
  {$ENDIF}

  FfrmIncluirUsuario.ShowModal;
  FreeAndNil(FfrmIncluirUsuario);
end;

procedure TUCFrame_User.BtAltClick(Sender: TObject);
begin
  if FDataSetCadastroUsuario.IsEmpty then
    Exit;
  FfrmIncluirUsuario := TfrmIncluirUsuario.Create(Self);
  FfrmIncluirUsuario.FUsercontrol := Self.FUsercontrol;
  SetWindowUser(False);
  with FfrmIncluirUsuario do
  begin
    FAltera := True;
    vNovoIDUsuario := FDataSetCadastroUsuario.FieldByName('IdUser').AsInteger;
    EditNome.Text := FDataSetCadastroUsuario.FieldByName('Nome').AsString;
    EditLogin.Text := FDataSetCadastroUsuario.FieldByName('Login').AsString;
    EditEmail.Text := FDataSetCadastroUsuario.FieldByName('Email').AsString;
    ComboPerfil.KeyValue := FDataSetCadastroUsuario.FieldByName('Perfil').AsInteger;
    ckPrivilegiado.Checked := StrToBool(FDataSetCadastroUsuario.FieldByName('Privilegiado').AsString);
    ckUserExpired.Checked := StrToBool(FDataSetCadastroUsuario.FieldByName('UserNaoExpira').AsString);
    SpinExpira.Value := FDataSetCadastroUsuario.FieldByName('DaysOfExpire').AsInteger;
	{$IFDEF DELPHI2006_UP}
    SetImage(FDataSetCadastroUsuario.FieldByName('Image').AsString);
	{$ENDIF}
    ComboStatus.ItemIndex := FDataSetCadastroUsuario.FieldByName('UserInative').AsInteger;
    FfrmIncluirUsuario.ComboStatus.Enabled :=
      FfrmIncluirUsuario.ComboStatus.Enabled and
      not (
        (FUsercontrol.User.ProtectAdministrator) and
        (FDataSetCadastroUsuario.FieldByName('Login').AsString = FUsercontrol.Login.InitialLogin.User)
      );
    ShowModal;
  end;
  FreeAndNil(FfrmIncluirUsuario);
end;

procedure TUCFrame_User.btApplyFilterClick(Sender: TObject);
begin
  ChangeButtonFilter;
end;

procedure TUCFrame_User.BtExcluiClick(Sender: TObject);
var
  TempID: Integer;
  CanDelete: Boolean;
  ErrorMsg: String;
  DataSetTemp: TDataSet;
begin
  if FDataSetCadastroUsuario.IsEmpty then
    Exit;
  TempID := FDataSetCadastroUsuario.FieldByName('IDUser').AsInteger;
  if MessageBox(Handle,
    PChar(Format(FUsercontrol.UserSettings.UsersForm.PromptDelete,
      [FDataSetCadastroUsuario.FieldByName('Login').AsString])),
    PChar(FUsercontrol.UserSettings.UsersForm.PromptDelete_WindowCaption),
    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = idYes then
  begin
    CanDelete := True;
    if Assigned(FUsercontrol.onDeleteUser) then
      FUsercontrol.onDeleteUser(TObject(Owner), TempID, CanDelete, ErrorMsg);
    if not CanDelete then
    begin
      MessageDlg(ErrorMsg, mtWarning, [mbOK], 0);
      Exit;
    end;

    //Cassiano 31/01/2018
    DataSetTemp := FUsercontrol.DataConnector.UCGetSQLDataset(Format(
      'select * from %s where %s = %s',
      [
        FUsercontrol.TableUsersLogged.TableName,
        FUsercontrol.TableUsersLogged.FieldUserID,
        IntToStr(FUsercontrol.CurrentUser.UserID)
      ]
    ));
    if not DataSetTemp.IsEmpty then
    begin
      MessageDlg(FUserControl.UserSettings.CommonMessages.CanNotDeleteUserLogon, mtWarning, [mbOK], 0);
      Exit;
    end;

    FUsercontrol.DataConnector.UCExecSQL
      ('Delete from ' + FUsercontrol.TableRights.TableName + ' where ' +
      FUsercontrol.TableRights.FieldUserID + ' = ' + IntToStr(TempID));
    FUsercontrol.DataConnector.UCExecSQL
      ('Delete from ' + FUsercontrol.TableUsers.TableName + ' where ' +
      FUsercontrol.TableUsers.FieldUserID + ' = ' + IntToStr(TempID));

    { Giovani da Cruz (G7) // Altera��o para adequa��o de alguns connectores }
    FUsercontrol.DataConnector.CloseDataSet(FDataSetCadastroUsuario);
    FUsercontrol.DataConnector.OpenDataSet(FDataSetCadastroUsuario);
  end;
end;

procedure TUCFrame_User.BtPassClick(Sender: TObject);
begin
  if FDataSetCadastroUsuario.IsEmpty then
    Exit;

  FormSenha := TSenhaForm.Create(Self);
  TSenhaForm(FormSenha).Position := FUsercontrol.UserSettings.WindowsPosition;
  TSenhaForm(FormSenha).FUsercontrol := FUsercontrol;
  TSenhaForm(FormSenha).Caption :=
    Format(FUsercontrol.UserSettings.ResetPassword.WindowCaption,
    [FDataSetCadastroUsuario.FieldByName('Login').AsString]);
  if TSenhaForm(FormSenha).ShowModal = mrOk then
  Begin

    (*
      if (Assigned(FUsercontrol.MailUserControl)) and (FUsercontrol.MailUserControl.SenhaForcada.Ativo ) then
      try
      FUsercontrol.MailUserControl.EnviaEmailSenhaForcada(
      FDataSetCadastroUsuario.FieldByName('NOME').AsString ,
      FDataSetCadastroUsuario.FieldByName('LOGIN').AsString,
      TSenhaForm(FormSenha).edtSenha.Text ,
      FDataSetCadastroUsuario.FieldByName('EMAIL').AsString,
      '');

      except
      on E : Exception do FUsercontrol.Log(e.Message, 0);
      end;

    *)
    FUsercontrol.ChangePassword(FDataSetCadastroUsuario.FieldByName('IDUser')
      .AsInteger, TSenhaForm(FormSenha).edtSenha.Text);
  End;
  FreeAndNil(FormSenha);
end;

procedure TUCFrame_User.ChangeButtonFilter;
var
  Filter, btCaption: string;
  Filtered: Boolean;
  IndexImage: Integer;

  procedure SetFilter(AFilter: string);
  var
    Separetor: string;
  begin
    Separetor := '';
    if Length(Trim(Filter)) > 0 then
      Separetor := ' and ';

    Filter := Filter + Separetor + AFilter;
  end;
begin
  Filter := '';
  Filtered := DataUser.DataSet.Filtered;
  DataUser.DataSet.Filtered := False;
  DataUser.DataSet.Filter := Filter;
  Nome.Enabled := Filtered;
  Login.Enabled := Filtered;
  Email.Enabled := Filtered;

  if Filtered then
  begin
    IndexImage := 0;
    btCaption := 'Aplicar Filtro';
  end
  else
  begin
    if Length(Trim(Nome.Text)) > 0 then
      SetFilter('Nome like ' + QuotedStr('%' + Nome.Text + '%'));

    if Length(Trim(Login.Text)) > 0 then
      SetFilter('Login like ' + QuotedStr('%' + Login.Text + '%'));

    if Length(Trim(Email.Text)) > 0 then
      SetFilter('Email like ' + QuotedStr('%' + Email.Text + '%'));

    DataUser.DataSet.Filter := Filter;
    DataUser.DataSet.Filtered := True;
    IndexImage := 1;
    btCaption := 'Remover Filtro';
  end;

  btApplyFilter.Glyph := nil;
  ImageList1.GetBitmap(IndexImage, btApplyFilter.Glyph);
  btApplyFilter.Caption := btCaption;
  FDataSetCadastroUsuarioAfterScroll(DataUser.DataSet);
end;

procedure TUCFrame_User.DbGridUserTitleClick(Column: TColumn);
begin
  FUsercontrol.DataConnector.OrderBy(Column.Field.DataSet, Column.FieldName);
end;

destructor TUCFrame_User.Destroy;
begin
  // nada a destruir
  // n�o destruir o FDataSetCadastroUsuario o USERCONTROL toma conta dele
  inherited;
end;

procedure TUCFrame_User.BtAcessClick(Sender: TObject);
var
  formHandle: THandle;
begin
  formHandle := FindWindow('TUserPermis', nil);
  if formHandle = 0 then { By Cleilson Sousa }
  begin
    if FDataSetCadastroUsuario.IsEmpty then
      Exit;
    UserPermis := TUserPermis.Create(Self);
    UserPermis.FUsercontrol := FUsercontrol;
    SetWindowUserProfile;
    UserPermis.lbUser.Caption := FDataSetCadastroUsuario.FieldByName('Login').AsString;
    ActionBtPermissUserDefault;
  end
  else
  begin
    ShowWindow(formHandle, SW_SHOWNORMAL);
    SetForegroundWindow(formHandle);
  end;

end;

procedure TUCFrame_User.SetWindowUserProfile;
begin
  with FUsercontrol.UserSettings.Rights do
  begin
    UserPermis.Caption := WindowCaption;
    UserPermis.LbDescricao.Caption := LabelUser;
    UserPermis.lbUser.Left := UserPermis.LbDescricao.Left +
      UserPermis.LbDescricao.Width + 5;
    UserPermis.PageMenu.Caption := PageMenu;
    UserPermis.PageAction.Caption := PageActions;
    UserPermis.PageControls.Caption := PageControls; // By Vicente Barros Leonel
    UserPermis.BtLibera.Caption := BtUnlock;
    UserPermis.BtBloqueia.Caption := BtLOck;
    UserPermis.BtGrava.Caption := BtSave;
    UserPermis.BtCancel.Caption := BtCancel;
    UserPermis.Position := FUsercontrol.UserSettings.WindowsPosition;
  end;
end;

procedure TUCFrame_User.ActionBtPermissUserDefault;
var
  TempCampos, TempCamposEX: String;
begin
  UserPermis.FTempIdUser := FDataSetCadastroUsuario.FieldByName('IdUser').AsInteger;
  with FUsercontrol do
  begin
    TempCampos :=
      Format(' %s as IdUser, %s as Modulo, %s as ObjName, %s as UCKey ',
      [TableRights.FieldUserID, TableRights.FieldModule,
      TableRights.FieldComponentName, TableRights.FieldKey]);
    TempCamposEX := Format(' %s, %s as FormName ',
      [TempCampos, TableRights.FieldFormName]);

    UserPermis.DSPermiss := DataConnector.UCGetSQLDataset
      (Format('SELECT %s FROM %s TAB WHERE TAB.%s = %s AND TAB.%s = %s',
      [TempCampos, TableRights.TableName, TableRights.FieldUserID,
      FDataSetCadastroUsuario.FieldByName('IdUser').AsString,
      TableRights.FieldModule, QuotedStr(ApplicationID)]));
    UserPermis.DSPermiss.Open;

    UserPermis.DSPermissEX := DataConnector.UCGetSQLDataset
      (Format('SELECT %s FROM %s TAB1 WHERE TAB1.%s = %s AND TAB1.%s = %s',
      [TempCamposEX, TableRights.TableName + 'EX', TableRights.FieldUserID,
      FDataSetCadastroUsuario.FieldByName('IdUser').AsString,
      TableRights.FieldModule, QuotedStr(ApplicationID)]));
    UserPermis.DSPermissEX.Open;

    UserPermis.DSPerfil := DataConnector.UCGetSQLDataset
      (Format('Select %s from %s tab Where tab.%s = %s and tab.%s = %s',
      [TempCampos, TableRights.TableName, TableRights.FieldUserID,
      FDataSetCadastroUsuario.FieldByName('Perfil').AsString,
      TableRights.FieldModule, QuotedStr(ApplicationID)]));
    UserPermis.DSPerfil.Open;

    UserPermis.DSPerfilEX := DataConnector.UCGetSQLDataset
      (Format('Select %s from %s tab1 Where tab1.%s = %s and tab1.%s = %s',
      [TempCamposEX, TableRights.TableName + 'EX', TableRights.FieldUserID,
      FDataSetCadastroUsuario.FieldByName('Perfil').AsString,
      TableRights.FieldModule, QuotedStr(ApplicationID)]));

    UserPermis.DSPerfilEX.Open;

    UserPermis.Show;

    { Giovani da Cruz (G7) // Altera��o para adequa��o de alguns connectores }
    FUsercontrol.DataConnector.CloseDataSet(FDataSetCadastroUsuario);
    FUsercontrol.DataConnector.OpenDataSet(FDataSetCadastroUsuario);

    FDataSetCadastroUsuario.Locate('idUser', UserPermis.FTempIdUser, []);
  end;
end;

procedure TUCFrame_User.FDataSetCadastroUsuarioAfterScroll(DataSet: TDataSet);
begin
  if (FUsercontrol.User.ProtectAdministrator) and
    (DataSet.FieldByName('Login').AsString = FUsercontrol.Login.
    InitialLogin.User) then
  begin
    BtExclui.Enabled := False;
    BtPass.Enabled := False;
    if FUsercontrol.CurrentUser.Username <> FUsercontrol.Login.InitialLogin.User
    then
      BtAcess.Enabled := False;
  end
  else
  begin
    BtExclui.Enabled := True;
    BtPass.Enabled := True;
    BtAcess.Enabled := True;
  end;
end;

procedure TUCFrame_User.SetWindow;
begin
  FDataSetCadastroUsuario.AfterScroll := FDataSetCadastroUsuarioAfterScroll;
  FDataSetCadastroUsuarioAfterScroll(FDataSetCadastroUsuario);
  with FUsercontrol.UserSettings.UsersForm do
  begin
    DbGridUser.Columns[0].Title.Caption := ColName;
    DbGridUser.Columns[1].Title.Caption := ColLogin;
    DbGridUser.Columns[2].Title.Caption := ColEmail;

    btAdic.Caption := BtAdd;
    BtAlt.Caption := BtChange;
    BtExclui.Caption := BtDelete;
    BtAcess.Caption := BtRights;
    BtPass.Caption := BtPassword;
    Self.btApplyFilter.Caption := btApplyFilter;
  end;

end;

procedure TUCFrame_User.SetWindowUser(Adicionar: Boolean);
begin
  with FUsercontrol.UserSettings.AddChangeUser do
  begin
    FfrmIncluirUsuario.Caption := WindowCaption;
    if Adicionar then
      FfrmIncluirUsuario.LbDescricao.Caption := LabelAdd
    else
    begin
      FfrmIncluirUsuario.LbDescricao.Caption := LabelChange;
      FfrmIncluirUsuario.LbDescricao.Tag := FDataSetCadastroUsuario.FieldByName('IdUser').AsInteger;
    end;

    FfrmIncluirUsuario.FDataSetCadastroUsuario := DataUser.DataSet;
    FfrmIncluirUsuario.Label1.Caption := LabelStatus;
    FfrmIncluirUsuario.lbNome.Caption := LabelName;
    FfrmIncluirUsuario.lbLogin.Caption := LabelLogin;
    FfrmIncluirUsuario.lbEmail.Caption := LabelEmail;
    FfrmIncluirUsuario.ckPrivilegiado.Caption := CheckPrivileged;
    FfrmIncluirUsuario.lbPerfil.Caption := LabelPerfil;
    FfrmIncluirUsuario.btGravar.Caption := BtSave;
    FfrmIncluirUsuario.btCancela.Caption := BtCancel;
    FfrmIncluirUsuario.Position := Self.FUsercontrol.UserSettings.WindowsPosition;
    FfrmIncluirUsuario.LabelExpira.Caption := ExpiredIn;
    FfrmIncluirUsuario.ckUserExpired.Caption := CheckExpira;
    FfrmIncluirUsuario.ComboPerfil.ListSource := DataPerfil;
    FfrmIncluirUsuario.ComboStatus.Enabled := not Adicionar;
    with FfrmIncluirUsuario.ComboStatus.Items do
    begin
      Clear;
      Add(StatusActive);
      Add(StatusDisabled);
    end;
    FfrmIncluirUsuario.ComboStatus.ItemIndex := 0;
    FfrmIncluirUsuario.lImagem.Caption := LabelImage;
  end;
end;

end.
