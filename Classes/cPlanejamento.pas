unit cPlanejamento;

interface

uses FireDac.Comp.Client, FireDac.DApt, System.SysUtils, FMX.Graphics, FUniMainModule;

type
       TPlanejamento = class
       private
       Fconn: TFDConnection;
       FVALOR: Double;
       FDESCRICAO: string;
       FDATAATE: String;
       FID_CATEGORIA: Integer;
       FDATAPLANEJAMENTO: TDateTime;
       FDATADE: String;
       FID_PLANEJAMENTO: Integer;
    public
        constructor Create(conn: TFDConnection);
        property ID_PLANEJAMENTO: Integer read FID_PLANEJAMENTO write FID_PLANEJAMENTO;
        property ID_CATEGORIA: Integer read FID_CATEGORIA write FID_CATEGORIA;
        property VALOR: Double read FVALOR write FVALOR;
        property DATAPLANEJAMENTO: TDateTime read FDATAPLANEJAMENTO write FDATAPLANEJAMENTO;
        property DATADE: String read FDATADE write FDATADE;
        property DATAATE: String read FDATAATE write FDATAATE;
        property DESCRICAO: string read FDESCRICAO write FDESCRICAO;

        function ListarLancamento(qtdResult: integer; out erro: string): TFDQuery;
        function Inserir(out erro: string): Boolean;
        function Alterar(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
        function ListarResumo(out erro: string): TFDQuery;
       end;

implementation

uses
  System.Classes;

{ TCategoria }

constructor TPlanejamento.Create(conn: TFDConnection);
begin
    Fconn := conn;
end;

function TPlanejamento.Inserir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_CATEGORIA <= 0 then
    begin
        erro := 'Informe a categoria do planejamento!';
        Result := false;
        exit;
    end;

    if DESCRICAO = '' then
    begin
        erro := 'Informe a descri��o do planejamento!';
        Result := false;
        exit;
    end;

    try
        try
            qry := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := false;
                SQL.Clear;
                SQL.Add('INSERT INTO TAB_PLANEJAMENTO(ID_CATEGORIA, VALOR, DATAPLANEJAMENTO, DESCRICAO)');
                SQL.Add('VALUES(:ID_CATEGORIA, :VALOR, :DATAPLANEJAMENTO, :DESCRICAO)');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
                ParamByName('VALOR').Value := VALOR;
                ParamByName('DATAPLANEJAMENTO').Value := DATAPLANEJAMENTO;
                ParamByName('DESCRICAO').Value := DESCRICAO;
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao inserir o planejamento: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;

function TPlanejamento.Alterar(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_PLANEJAMENTO <= 0 then
    begin
        erro := 'Informe o planejamento!';
        Result := false;
        exit;
    end;

    if ID_CATEGORIA <= 0 then
    begin
        erro := 'Informe a categoria do planejamento!';
        Result := false;
        exit;
    end;

    if DESCRICAO = '' then
    begin
        erro := 'Informe a descri��o do planejamento!';
        Result := false;
        exit;
    end;

    try
        try
            qry := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := false;
                SQL.Clear;
                SQL.Add('UPDATE TAB_PLANEJAMENTO SET ID_CATEGORIA=:ID_CATEGORIA, VALOR=:VALOR, DATAPLANEJAMENTO=:DATAPLANEJAMENTO, DESCRICAO=:DESCRICAO');
                SQL.Add('WHERE ID_PLANEJAMENTO =:ID_PLANEJAMENTO');
                ParamByName('ID_PLANEJAMENTO').Value := ID_PLANEJAMENTO;
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
                ParamByName('VALOR').Value := VALOR;
                ParamByName('DATAPLANEJAMENTO').Value := DATAPLANEJAMENTO;
                ParamByName('DESCRICAO').Value := DESCRICAO;

                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao alterar o planejamento: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;

function TPlanejamento.Excluir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_PLANEJAMENTO <= 0 then
    begin
        erro := 'Informe o planejamento!';
        Result := false;
        exit;
    end;

    try
        try
            qry := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := false;
                SQL.Clear;
                SQL.Add('DELETE FROM TAB_PLANEJAMENTO');
                SQL.Add('WHERE ID_PLANEJAMENTO = :ID_PLANEJAMENTO');
                ParamByName('ID_PLANEJAMENTO').Value := ID_PLANEJAMENTO;
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao excluir o planejamento: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;

function TPlanejamento.ListarLancamento(qtdResult: integer; out erro: string): TFDQuery;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Fconn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            sql.Add('SELECT P.*, C.DESCRICAO AS DESCRICAO_CATEGORIA, C.ICONE FROM TAB_PLANEJAMENTO P');
            sql.Add('JOIN TAB_CATEGORIA C ON (C.ID_CATEGORIA = P.ID_CATEGORIA)');
            sql.Add('WHERE 1 = 1');

            if ID_PLANEJAMENTO > 0 then
            begin
                SQL.Add('AND P.ID_PLANEJAMENTO = :ID_PLANEJAMENTO');
                ParamByName('ID_PLANEJAMENTO').Value := ID_PLANEJAMENTO;
            end;

            if ID_CATEGORIA > 0 then
            begin
                SQL.Add('AND P.ID_CATEGORIA = :ID_CATEGORIA');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
            end;

            if (DATADE <> '') and (DATAATE <> '') then
              sql.Add('AND P.DATAPLANEJAMENTO BETWEEN "'+ DATADE +'" AND "'+ DATAATE +'"');

            sql.Add('ORDER BY P.DATAPLANEJAMENTO DESC');

            if qtdResult > 0 then
              sql.Add('LIMIT ' + qtdResult.ToString);

            Active := true;
        end;

        Result := qry;
        erro := '';

    except on ex:exception do
    begin
        Result := nil;
        erro := 'Erro ao consultar os Planejamentos: ' + ex.Message;
    end;
    end;
end;

function TPlanejamento.ListarResumo(out erro: string): TFDQuery;
var
    qry : TFDQuery;
begin
    {try
        qry := TFDQuery.Create(nil);
        qry.Connection := Fconn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            sql.Add('SELECT C.ICONE, C.DESCRICAO, CAST(SUM(L.VALOR) AS REAL) AS VALOR');
            sql.Add('FROM    TAB_LANCAMENTO L');
            sql.Add('JOIN TAB_CATEGORIA C ON (C.ID_CATEGORIA = L.ID_CATEGORIA)');
            SQL.Add('WHERE L.DATALANCAMENTO BETWEEN ''' + DATADE + ''' AND ''' + DATAATE + '''');
            sql.Add('GROUP BY C.ICONE, C.DESCRICAO');
            sql.Add('ORDER BY 3');
            Active := true;
        end;

        Result := qry;
        erro := '';

    except on ex:exception do
    begin
        Result := nil;
        erro := 'Erro ao consultar categorias: ' + ex.Message;
    end;
    end;  }
end;

end.
