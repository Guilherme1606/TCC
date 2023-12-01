{$I \Globus\Sistemas\Globus.inc}
unit DueQueryAuxiliar;

interface

uses
  Vcl.Forms, System.SysUtils, System.Classes, System.StrUtils, Vcl.Dialogs, 
  Vcl.StdCtrls, ADODB, Variants, Vcl.ClipBrd, GlobalType, FireDac.Comp.Client, 
  JvMemoryDataset, FireDac.Stan.Param, FireDac.Stan.Error, Data.Db;

Type
  TQFetchOptions = (qfUnidirecionalAtivo,qfUnidirecionalNaoAtivo);

const
  Mes: array[1..12] of string[3] = ('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC');


procedure GetSQL(qry: TFDQuery; vMemo: TMemo = nil; vSoRetornaParametros: Boolean = false; vIdentificador: string = '');

function GetSQLDDDU(qry: TFDQuery): string;

procedure GetSqlADO(qry: TADOQuery; vMemo: TMemo = nil; vSoRetornaParametros: Boolean = false; vIdentificador: string = '');

function GetPosParametro(pTexto, pParametro: string): Integer;

function LimparEspacos(s: string): string;

function MostraErrosQuery(pErrors: EFDDBEngineException; pExibeMsg: Boolean = False; pMensagemComplementar: string = ''): string;

procedure MontaFiltroIn(pQuery: TFDQuery; pCampo: string; plista: TStrings);

(*
Exibe uma caixa de mensagem com os erros que tenham acontecido durante um acesso ao banco.
Se não houver erro, o retorno é uma string vazia, senão o texto com os erros.

Ex.:

  With vQuery Do
  Begin
    Try
      ExecSQL;
      Result := True;
    Except
      On E:EFDDBEngineException Do
      Begin
        MostraErrosQuery(E, True, 'Ocorreu erro ao inserir na tabela XXX');
        Result := False;
      End;
    End;
  End; // With
*)

function AbrirQuery(pQuery: TFDQuery; pReferenciaGetSql: string = ''; pMsgQdoEmpty: string = ''; pMsgBarraStatus: string = ''): TAbrirQuery;
(*
Abre a query, faz o getsql e permite exibir mensagens qdo o retorno é vazio e de barra de status.

No GetSql registra o tempo gasto na consulta.

Ex.:

  If AbrirQuery(Qr_Auxiliar
                ,'ConsultaPrincipal'
                ,'Nenhuma informação para os filtros especificados.'
                ,'Consultando dados ...').Achou Then ...
*)

function ExecSqlOuRollback(pMensagem: string; pQuery: TFDQuery): Boolean; //Função trasferidas do TUR_Funcoes

function CriarQuery(aFetchOptions : TQFetchOptions): TFDQuery; overload;

function CriarQuery: TFDQuery; overload;

function CriarQuery(ADataBaseName: string): TFDQuery; overload;

function CriarQuery(ADataBaseName: string; aFetchOptions : TQFetchOptions): TFDQuery; overload;

function CriarQuery(AOwner: TComponent): TFDQuery; overload;

function CriarQuery(AUtilizaSulfixo: Boolean; ASulfixo: string): TFDQuery; overload;

function CriarQuery(ADataBaseName: string; AOwner: TComponent; ASulfixo: string): TFDQuery; overload;

function IdentificarAlteracoes(vAtual, vAnterior: TFDQuery): string;
(* Compara os Parâmetros de vAtual com os Campos de vAnterior e retorna String com as Diferenças.
   Para tanto, é necessário que os parâmetros tenha o mesmo nome dos campos *)

function TrazComparacaoDivergente(pQuery: TFDQuery; pCriaRx: Boolean = True): string;
(*Verifica se o cadastro foi alterado. *)

procedure PreencherParametrosQuery(var AQueryOrigem: TFDQuery; var AQueryDestino: TFDQuery);

function ReturnSQL(Str, DataBas: string): Boolean;


implementation

uses
  Prx.Utilitarios.Aplicacao.Interfaces,
  Prx.Utilitarios.Aplicacao.FeedBack.Interfaces,
  Prx.Utilitarios.Aplicacao.Tools.Interfaces,
  PRXString,
  PRXBarraDeEstatusAuxiliar,
  GlbComum,
  Prx.Utilitarios.MensagemDlg.Interfaces,
  PRXComum,
  PRXIConexao;

var
  vRxCompDive: TJvMemoryData;

procedure GetSqlADO(qry: TADOQuery; vMemo: TMemo = nil; vSoRetornaParametros: Boolean = false; vIdentificador: string = '');
(* Alexandre Mendes - 23/10/2017
   Coloca em Memo1.Lines o TADOQuery substituindo as variáveis "Bind" pelos valores
   atribuídos aos parâmetros. Utilizado para testes.
*)

var
  i, j, k: Integer;
  s, w, m: string;
  Memo1: TMemo;
  vToDate: Boolean;
  vTrunc: Boolean;
  vNull: Boolean;
  vStrings: TStringList;
  vForm: TForm;
begin

  if (not vcUsuarioManagerComSenhaUm) and (vcArquivoRastreioSQL = '') then
    Exit;

  vForm := TForm.Create(Application);
  vForm.Visible := False;

  if vMemo <> Nil then
    Memo1 := vMemo
  else

  begin
    // Cria um TMemo para poder usar o CopyToClipboard
    Memo1 := TMemo.Create(vForm);
    Memo1.Visible := false;
    Memo1.Parent := vForm;
  end;

  with qry do
  begin
    // Controla se o Parameters.Items[j] = '' deve ser substituído por Null
    vNull := (Pos('INSERT', UpperCase(SQL.Text)) <> 0) or (Pos('UPDATE', UpperCase(SQL.Text)) <> 0);

    for i := 0 to SQL.Count - 1 do
    begin
      w := SQL.Strings[i];

      for j := 0 to Parameters.Count - 1 do
      begin
        if GetPosParametro(':' + Parameters.Items[j].Name, w) <> 0 then
        begin
          k := GetPosParametro(':' + Parameters.Items[j].Name, w);
          // System.Delete(w, k, Length(':' + Params[j].Name));
          // Apaga os (:)
          System.Delete(w, k, 1);
          System.Insert(' */ ', w, k + Length(Parameters.Items[j].Name));
          System.Insert(' /* ', w, k);

          if Parameters.Items[j].DataType in [ftString] then
          begin
            if (vNull) and (Parameters.Items[j].Value = unassigned) then
            begin
              s := 'NULL';
              System.Insert('NULL', w, k)
            end
            else
            begin
              s := QuotedStr(Parameters.Items[j].Value);
              System.Insert(QuotedStr(Parameters.Items[j].Value), w, k);
            end;
          end
          else if Parameters.Items[j].DataType in [ftDateTime, ftDate] then
          begin
            // Verifica se aparece TO_DATE
            m := UpperCase(LimparEspacos(w));
            vToDate := GetPosParametro('TO_DATE(' + ':' + Parameters.Items[j].Name, m) <> 0;
            vTrunc := GetPosParametro('TRUNC', m) <> 0;

            if not (vToDate) and not (vTrunc) then
            begin
              // Coloca o TO_DATE
              s := FormatDateTime('DD/MM/YYYY HH:NN:SS', Parameters.Items[j].Value);

              s := 'TO_DATE(' + QuotedStr(s) + ', ';
              s := s + QuotedStr('DD/MM/YYYY HH24:MI:SS') + ')';
              System.Insert(s, w, k);
            end
            else

            begin
              // Garante que será inserido o mês em inglês
              s := FormatDateTime('DD-', Parameters.Items[j].Value);
              s := s + Mes[StrToInt(FormatDateTime('MM', Parameters.Items[j].VAlue))];
              s := s + '-' + FormatDateTime('YYYY', Parameters.Items[j].Value);

              if Parameters.Items[j].DataType <> ftDate then
                if FormatDateTime('HH:NN:SS', Parameters.Items[j].Value) <> '00:00:00' then
                  s := s + FormatDateTime(' HH:NN:SS', Parameters.Items[j].Value);
              System.Insert(QuotedStr(s), w, k);
            end;

          end
          else if Parameters.Items[j].DataType in [ftFloat] then
          begin

            if (vNull) and (Parameters.Items[j].Value = unassigned) then
              s := 'NULL'
            else

            begin
              s := FormatFloat('######0.######', Parameters.Items[j].Value);
              if Pos(',', s) <> 0 then
              begin
                s := Copy(s, 1, Pos(',', s) - 1) + '.' + Copy(s, Pos(',', s) + 1, Length(s));
              end;
            end;

            System.Insert(s, w, k)
          end
          else if Parameters.Items[j].DataType in [ftInteger] then
          begin
            if (vNull) and (Parameters.Items[j].Value = unassigned) then
              s := 'NULL'
            else
            begin
              s := Parameters.Items[j].Value;
              if Pos(',', s) <> 0 then
              begin
                s := Copy(s, 1, Pos(',', s) - 1) + '.' + Copy(s, Pos(',', s) + 1, Length(s));
              end;
            end;

            System.Insert(s, w, k)
          end
          else
          begin
            if (vNull) and (Parameters.Items[j].Value = unassigned) then
            begin
              s := 'NULL';
              System.Insert('NULL', w, k)
            end
            else

            begin
              s := Parameters.Items[j].Value;
              System.Insert(Parameters.Items[j].Value, w, k);
            end;

          end;

          if vSoRetornaParametros then
            Memo1.Lines.Add(Parameters.Items[j].Name + ' = ' + s);

        end;

      end;

      if not (vSoRetornaParametros) then
        Memo1.Lines.Add(TrimRight(w) + ' ');

    end;
  end;

  if vcUsuarioManagerComSenhaUm then
  // só copia para a memória se estiver no nosso ambiente.
  begin
    Memo1.SelectAll;
    Memo1.CopyToClipboard;
    Memo1.Width := 10000;
  end;

  if vcArquivoRastreioSQL <> '' then
  begin
    vStrings := TStringList.Create;
    try
      vStrings.LoadFromFile(vcArquivoRastreioSQL);
    except
    end;
    vStrings.Add(Replicate('-', 50));
    vStrings.Add('-- ' + FormatDateTime('DD/MM/YYYY HH:MM:NN   ', now) + Screen.ActiveForm.Name + IfThen(vIdentificador = '', '', ' Identificador: ' + vIdentificador));

    vStrings.AddStrings(Memo1.Lines);
    try
      vStrings.SaveToFile(vcArquivoRastreioSQL);
    except
    end;
    FreeAndNil(vStrings);
  end;

  if vMemo = Nil then
    FreeAndNil(Memo1);

  FreeAndNil(vForm);

end;

function GetSQLDDDU(qry: TFDQuery): string;
var
  i, j, k: Integer;
  s, w, m: string;
  Memo1: TMemo;
  vToDate: Boolean;
  vTrunc: Boolean;
  vNull: Boolean;
  vForm: TForm;
begin

  vForm := TForm.Create(Application);
  vForm.Visible := False;

  // Cria um TMemo para poder usar o CopyToClipboard
  Memo1 := TMemo.Create(vForm);
  Memo1.Visible := false;
  Memo1.Parent := vForm;

  with qry do
  begin
    // Controla se o Params[j] = '' deve ser substituído por Null
    vNull := (Pos('INSERT', UpperCase(SQL.Text)) <> 0) or (Pos('UPDATE', UpperCase(SQL.Text)) <> 0);

    for i := 0 to SQL.Count - 1 do
    begin
      w := SQL.Strings[i];

      for j := 0 to ParamCount - 1 do
      begin
        if GetPosParametro(':' + Params[j].Name, w) <> 0 then
        begin
          k := GetPosParametro(':' + Params[j].Name, w);
          // System.Delete(w, k, Length(':' + Params[j].Name));
          // Apaga os (:)
          System.Delete(w, k, 1);
          System.Insert(' */ ', w, k + Length(Params[j].Name));
          System.Insert(' /* ', w, k);

          if Params[j].DataType in [ftString] then
          begin
            if (vNull) and ((Params[j].IsNull) or (Params[j].AsString = '')) then
            begin
              s := 'NULL';
              System.Insert('NULL', w, k)
            end
            else
            begin
              s := QuotedStr(Params[j].AsString);
              System.Insert(QuotedStr(Params[j].AsString), w, k);
            end;
          end
          else if Params[j].DataType in [ftDateTime, ftDate] then
          begin
            // Verifica se aparece TO_DATE
            m := UpperCase(LimparEspacos(w));
            vToDate := GetPosParametro('TO_DATE(' + ':' + Params[j].Name, m) <> 0;
            vTrunc := GetPosParametro('TRUNC', m) <> 0;

            if not (vToDate) and not (vTrunc) then
            begin
              // Coloca o TO_DATE
              s := FormatDateTime('DD/MM/YYYY HH:NN:SS', Params[j].AsDateTime);

              s := 'TO_DATE(' + QuotedStr(s) + ', ';
              s := s + QuotedStr('DD/MM/YYYY HH24:MI:SS') + ')';
              System.Insert(s, w, k);
            end
            else

            begin
              // Garante que será inserido o mês em inglês
              s := FormatDateTime('DD-', Params[j].AsDateTime);
              s := s + Mes[StrToInt(FormatDateTime('MM', Params[j].AsDateTime))];
              s := s + '-' + FormatDateTime('YYYY', Params[j].AsDateTime);

              if Params[j].DataType <> ftDate then
                if FormatDateTime('HH:NN:SS', Params[j].AsDateTime) <> '00:00:00' then
                  s := s + FormatDateTime(' HH:NN:SS', Params[j].AsDateTime);
              System.Insert(QuotedStr(s), w, k);
            end;

          end
          else if Params[j].DataType in [ftFloat] then
          begin

            if (vNull) and ((Params[j].IsNull) or (Params[j].AsString = '')) then
              s := 'NULL'
            else

            begin
              s := FormatFloat('######0.######', Params[j].AsFloat);
              if Pos(',', s) <> 0 then
              begin
                s := Copy(s, 1, Pos(',', s) - 1) + '.' + Copy(s, Pos(',', s) + 1, Length(s));
              end;
            end;

            System.Insert(s, w, k)
          end
          else

          begin
            if (vNull) and ((Params[j].IsNull) or (Params[j].AsString = '')) then
            begin
              s := 'NULL';
              System.Insert('NULL', w, k)
            end
            else

            begin
              s := Params[j].AsString;
              System.Insert(Params[j].AsString, w, k);
            end;

          end;

        end;

      end;
      Memo1.Lines.Add(TrimRight(w) + ' ');
    end;
  end;

  result := Memo1.Text;
  FreeAndNil(Memo1);
  FreeAndNil(vForm);

end;

procedure GetSQL(qry: TFDQuery; vMemo: TMemo = nil; vSoRetornaParametros: Boolean = false; vIdentificador: string = '');
var
  i, j, k: Integer;
  s, m: string;
  vSql: string;
  vToDate: Boolean;
  vTrunc: Boolean;
  vNull: Boolean;
  vStrings: TStringList;

  procedure SeInformadoProcessaArquivoDeRatreio;
  var
    vStringsRastreio: TStringList;
  begin

    if Trim(vcArquivoRastreioSQL) = '' then
      Exit;

    vStringsRastreio := TStringList.Create;

    try

      vStringsRastreio.Clear;

      if FileExists(vcArquivoRastreioSQL) then
        vStringsRastreio.LoadFromFile(vcArquivoRastreioSQL);

      vStringsRastreio.Add(Replicate('-', 50));
      vStringsRastreio.Add('-- ' + FormatDateTime('DD/MM/YYYY HH:MM:NN   ', now) + Screen.ActiveForm.Name + IfThen(vIdentificador = '', '', ' Identificador: ' + vIdentificador));
      vStringsRastreio.Add(vStrings.text);
      vStringsRastreio.SaveToFile(vcArquivoRastreioSQL);
    finally
      vStringsRastreio.Free;
    end;

  end;

  procedure CopiarParaAreaDeTransferenciaCasoAmbienteInterno;
  var
    vSucesso: Boolean;
    vTentativa: Integer;
  begin

    if (not vcUsuarioManagerComSenhaUm) and (not vcAplicacaoToolsService.CapturarGetSql) then
      Exit;

    vTentativa := 0;

    repeat

      try
        Clipboard.AsText := '';
        Clipboard.AsText := vStrings.Text;
        vSucesso := true;
      except
        vSucesso := false;
        vTentativa := vTentativa + 1;
      end;

    until ((vSucesso) or (vTentativa > 2));

  end;

begin

  if (not vcUsuarioManagerComSenhaUm) and (vcArquivoRastreioSQL = '') and not (vcAplicacaoToolsService.CapturarGetSql)then
    Exit;

  vStrings := TStringList.Create;

  with qry do
  begin

    // Controla se o Params[j] = '' deve ser substituído por Null
    vNull := (Pos('INSERT', UpperCase(SQL.Text)) <> 0) or (Pos('UPDATE', UpperCase(SQL.Text)) <> 0);

    for i := 0 to SQL.Count - 1 do
    begin
      vSql := SQL.Strings[i];

      for j := 0 to ParamCount - 1 do
      begin
        if GetPosParametro(':' + Params[j].Name, vSql) <> 0 then
        begin
          k := GetPosParametro(':' + Params[j].Name, vSql);

          System.Delete(vSql, k, 1);
          System.Insert(' */ ', vSql, k + Length(Params[j].Name));
          System.Insert(' /* ', vSql, k);

          if Params[j].DataType in [ftString] then
          begin
            if (vNull) and ((Params[j].IsNull) or (Params[j].AsString = '')) then
            begin
              s := 'NULL';
              System.Insert('NULL', vSql, k)
            end
            else
            begin
              s := QuotedStr(Params[j].AsString);
              System.Insert(QuotedStr(Params[j].AsString), vSql, k);
            end;
          end
          else if Params[j].DataType in [ftDateTime, ftDate] then
          begin
            // Verifica se aparece TO_DATE
            m := UpperCase(LimparEspacos(vSql));
            vToDate := GetPosParametro('TO_DATE(' + ':' + Params[j].Name, m) <> 0;
            vTrunc := GetPosParametro('TRUNC', m) <> 0;

            if not (vToDate) and not (vTrunc) then
            begin
              // Coloca o TO_DATE
              s := FormatDateTime('DD/MM/YYYY HH:NN:SS', Params[j].AsDateTime);

              s := 'TO_DATE(' + QuotedStr(s) + ', ';
              s := s + QuotedStr('DD/MM/YYYY HH24:MI:SS') + ')';
              System.Insert(s, vSql, k);
            end
            else

            begin
              // Garante que será inserido o mês em inglês
              s := FormatDateTime('DD-', Params[j].AsDateTime);
              s := s + Mes[StrToInt(FormatDateTime('MM', Params[j].AsDateTime))];
              s := s + '-' + FormatDateTime('YYYY', Params[j].AsDateTime);

              if Params[j].DataType <> ftDate then
                if FormatDateTime('HH:NN:SS', Params[j].AsDateTime) <> '00:00:00' then
                  s := s + FormatDateTime(' HH:NN:SS', Params[j].AsDateTime);
              System.Insert(QuotedStr(s), vSql, k);
            end;

          end
          else if Params[j].DataType in [ftFloat, ftCurrency] then
          begin

            if (vNull) and ((Params[j].IsNull) or (Params[j].AsString = '')) then
              s := 'NULL'
            else

            begin
              s := FormatFloat('######0.######', Params[j].AsFloat);
              if Pos(',', s) <> 0 then
              begin
                s := Copy(s, 1, Pos(',', s) - 1) + '.' + Copy(s, Pos(',', s) + 1, Length(s));
              end;
            end;

            System.Insert(s, vSql, k)
          end
          else

          begin
            if (vNull) and ((Params[j].IsNull) or (Params[j].AsString = '')) then
            begin
              s := 'NULL';
              System.Insert('NULL', vSql, k)
            end
            else

            begin
              s := Params[j].AsString;
              System.Insert(Params[j].AsString, vSql, k);
            end;

          end;

          if vSoRetornaParametros then
            vStrings.Add(Params[j].Name + ' = ' + s);

        end;

      end;

      if not (vSoRetornaParametros) then
        vStrings.Add(TrimRight(vSql) + ' ');

    end;
  end;

  if vMemo <> Nil then
    vMemo.Lines.Add(vStrings.Text);

  CopiarParaAreaDeTransferenciaCasoAmbienteInterno;

  SeInformadoProcessaArquivoDeRatreio;

  FreeAndNil(vStrings);

end;

function LimparEspacos(s: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if s[i] <> ' ' then
      Result := Result + s[i]
end;

function GetPosParametro(pTexto, pParametro: string): Integer;
var
  i: Integer;
begin
  pTexto := UpperCase(pTexto);
  pParametro := UpperCase(pParametro);
  Result := Pos(pTexto + ' ', pParametro);
  if Result = 0 then
    Result := Pos(pTexto + ',', pParametro);
  if Result = 0 then
    Result := Pos(pTexto + ')', pParametro);
  if Result = 0 then
  begin
   // Verifica se está no final da linha
    i := Pos(pTexto, pParametro);
    if Trim(Copy(pParametro, i + length(pTexto), 1)) = '' then
      Result := i;
  end;
end;

function MostraErrosQuery(pErrors: EFDDBEngineException; pExibeMsg: Boolean = False; pMensagemComplementar: string = ''): string;
var
  a: Integer;
  b: string;
begin
  b := '';
  for a := 0 to pErrors.ErrorCount - 1 do
  begin
    b := b + '(' + IntToStr(pErrors.Errors[a].ErrorCode) + ') ' + pErrors.Errors[a].Message + #10;
  end;
  if pMensagemComplementar <> '' then
    b := b + #10 + pMensagemComplementar;
  if pExibeMsg then
    vcMensagem.MensagemDeErro('Erro de SQL :' + #13 + b);
  Result := b;
end;

function AbrirQuery(pQuery: TFDQuery; pReferenciaGetSql: string = ''; pMsgQdoEmpty: string = ''; pMsgBarraStatus: string = ''): TAbrirQuery;
var
  Hour, Min, Sec, MSec: Word;
  vErro: string;
begin
  with pQuery do
  begin
    try
      if Trim(pMsgBarraStatus) <> '' then
        AplicacaoFeedBackMensagem(pMsgBarraStatus);

      if (Trim(pReferenciaGetSql) = '') and (Trim(pQuery.Name) <> '') then
        pReferenciaGetSql := pQuery.Name;

      Result.TempoIni := Time;
      GetSql(pQuery);
      try
        pQuery.Open;
      except
        on e: exception do
          Result.Achou := False;
      end;
      Result.TempoFin := Time;
      Result.Minutos := Result.TempoFin - Result.TempoIni;
      DecodeTime(Result.Minutos, Hour, Min, Sec, MSec);

      GetSql(pQuery, Nil, False, pReferenciaGetSql + ', Tempo: ' + FormatDateTime('hh:mm:ss', Result.Minutos) + '.' + IntToStr(MSec));

      Result.Achou := not IsEmpty;

      if (not Result.Achou) and (Trim(pMsgQdoEmpty) <> '') then
        vcMensagem.MensagemDeInformacao(pMsgQdoEmpty);

      if Trim(pMsgBarraStatus) <> '' then
        AplicacaoFeedBackMensagem;

    except
      on E: EFDDBEngineException do
      begin
        Result.Achou := False;
        vErro := '';
        if (Trim(pReferenciaGetSql) <> '') then
          vErro := vErro + Trim(pReferenciaGetSql) + ' : ';
        if (Trim(pQuery.Name) <> '') and (Trim(pReferenciaGetSql) <> '') and (Trim(pReferenciaGetSql) <> Trim(pQuery.Name)) then
          vErro := vErro + pQuery.Name + ' : ';
        vErro := vErro + MostraErrosQuery(E, False);
        vcMensagem.MensagemDeErro(vErro);
      end
    end; // Try - Except
  end; // With pQuery do
end;

function ExecSqlOuRollback(pMensagem: string; pQuery: TFDQuery): Boolean;
begin
  with pQuery do
  begin
    Result := True;
    AplicacaoFeedBackMensagem(pMensagem + '...');
    try
      ExecSQL;
    except
      on E: EFDDBEngineException do
      begin
        vcDatabase.Rollback;
        Result := False;
        vcMensagem.MensagemDeErro('Erro ao ' + pMensagem + ': ' + E.Message);
      end
    end; // try - except
    AplicacaoFeedBackMensagem;
  end; // With pQuery do
end;

function CriarQuery: TFDQuery; overload;
begin

  Result := CriarQuery(vcConexao.DatabaseName);
end;

function CriarQuery(ADataBaseName: string): TFDQuery; overload;
begin
  Result := CriarQuery(ADataBaseName, Application, EmptyStr);
end;

function CriarQuery(ADataBaseName: string; aFetchOptions : TQFetchOptions): TFDQuery; overload;
begin
  Result := CriarQuery(ADataBaseName);
  Result.FetchOptions.Unidirectional := aFetchOptions = qfUnidirecionalAtivo;
end;

function CriarQuery(aFetchOptions : TQFetchOptions): TFDQuery; overload;
begin
  Result := CriarQuery;
  Result.FetchOptions.Unidirectional := aFetchOptions = qfUnidirecionalAtivo;
end;

function CriarQuery(AOwner: TComponent): TFDQuery; overload;
begin

  Result := CriarQuery(vcConexao.DatabaseName, AOwner, EmptyStr);

end;

function CriarQuery(AUtilizaSulfixo: Boolean; ASulfixo: string): TFDQuery; overload;
begin

  if (AUtilizaSulfixo) and (ASulfixo = EmptyStr) then
    ASulfixo := Screen.ActiveForm.Name
  else if not AUtilizaSulfixo then
    ASulfixo := '';

  Result := CriarQuery(vcConexao.DatabaseName, Application, ASulfixo);

end;

function CriarQuery(ADataBaseName: string; AOwner: TComponent; ASulfixo: string): TFDQuery; overload;
var
  Qry: TFDQuery;

  function CriarIDentificador : string;
  begin
    result := StringReplace(StringReplace(StringReplace(TGuid.NewGuid.ToString,'{','',[]),'}','',[]),'-','',[rfreplaceall]);
  end;

begin

  Qry := TFDQuery.Create(AOwner);
  Qry.Name := ASulfixo +'QRY' + CriarIDentificador;
  Qry.ConnectionName := ADataBaseName;
  Qry.Sql.Clear;
  Result := Qry;

end;

function IdentificarAlteracoes(vAtual, vAnterior: TFDQuery): string;
// Esta função compara os Parâmetros de vAtual com os Campos de vAnterior.
// Para tanto, é necessário que os parâmetros tenha o mesmo nome dos campos

  function TratarVazio(S: string): string;
  begin
    if Trim(S) = '' then
      Result := '<vazio>'
    else
      Result := S;
  end;

var
  i: Integer;
  vCampo: string;
  vVlrAnterior: string;
  vVlrAtual: string;
begin

  Result := '';
  for i := 0 to vAtual.Params.Count - 1 do
  begin
    vCampo := vAtual.Params[i].Name;
    // Se existe campo com o mesmo nome do parâmetro
    if vAnterior.FindField(vCampo) <> nil then
    begin
      if (vAnterior.FieldByName(vCampo) is TDateTimeField) then
      begin
        with vAtual.ParamByName(vCampo) do
          if (Trim(AsString) = '') then
            vVlrAtual := FormatDateTime('DD/MM/YYYY HH:NN', 0)
          else
            vVlrAtual := FormatDateTime('DD/MM/YYYY HH:NN', AsDateTime);
        with vAnterior.FieldByName(vCampo) do
          if (Trim(AsString) = '') then
            vVlrAnterior := FormatDateTime('DD/MM/YYYY HH:NN', 0)
          else
            vVlrAnterior := FormatDateTime('DD/MM/YYYY HH:NN', AsDateTime);
      end
      else

      begin
        vVlrAtual := vAtual.ParamByName(vCampo).AsString;
        vVlrAnterior := vAnterior.FieldByName(vCampo).AsString;
      end;

      if (vCampo <> 'DATA_ALTERACAO') and (vVlrAnterior <> vVlrAtual) then
        Result := Result + ' ' + vCampo + ' de ' + TratarVazio(vVlrAnterior) + ' para ' + TratarVazio(vVlrAtual) + '.';
    end;
  end;

end;

function TrazComparacaoDivergente(pQuery: TFDQuery; pCriaRx: Boolean = True): string;
var
  vItem: Integer;
begin
  // Quando o componente já estiver e for cria novamente
  if (vRxCompDive <> nil) and (pCriaRx) then
  begin
    vRxCompDive := Nil;
    vRxCompDive.Free;
  end; // If (vRxCompDive <> nil) And

  if (vRxCompDive = nil) or (pCriaRx) then
    vRxCompDive := TJvMemoryData.Create(Nil);

  Result := '';
  if vRxCompDive.RecordCount <= 0 then // Verifica se existe registro na Memory Data
  begin
    vRxCompDive.EmptyTable;
    vRxCompDive.LoadFromDataSet(pQuery, 0, lmCopy); // Copia a estrutura e todos registros da query p/ a Memory Data
  end
  else // If pRx.RecordCount <= 0 Then
  begin
    with vRxCompDive.Fields do
    begin
      // Se q quandidade de campos do 2º select estiver diferente com a do 1º select cai fora
      if Count <> pQuery.Fields.Count then
        Exit;

      for vItem := 0 to Count - 1 do
        if Fields[vItem].AsString <> pQuery.Fields[vItem].AsString then // Compara o conteúdo dos campos
          Result := Result + '(' + Fields[vItem].FieldName + ') de ' + IfThen(Trim(Fields[vItem].AsString) = '', '<vazio>', Fields[vItem].AsString) + ' para ' + IfThen(Trim(pQuery.Fields.Fields[vItem].AsString) = '', '<vazio>', pQuery.Fields.Fields[vItem].AsString) + ', ';

      // Se achou alguma diferença, retira a ultima virgula.
      Result := IfThen(Trim(Result) <> '', Copy(Result, 1, Length(Trim(Result)) - 1), '');

      vRxCompDive := Nil; // Iguala a Nil pq o componente só é liberado da memoria quando o mesmo esta em um Form.
      vRxCompDive.Free; // Apenas p/ garantir que foi liberado da memoria
    end; // With vRxCompDive.Fields do
  end; // End Else
end; // TrazComparacaodivergente(pQuery : TFDQuery) : String;   ,

procedure PreencherParametrosQuery(var AQueryOrigem: TFDQuery; var AQueryDestino: TFDQuery);
var
  i: Integer;
begin

  for i := 0 to AQueryOrigem.FieldCount - 1 do
  begin
    if AQueryOrigem.Fields[i].FieldKind <> fkData then
      continue;
    if AQueryDestino.ParamByName('P' + AQueryOrigem.Fields.Fields[i].FieldName) <> nil then
    begin
      AQueryDestino.ParamByName('P' + AQueryOrigem.Fields.Fields[i].FieldName).DataType := AQueryOrigem.Fields.Fields[i].DataType;
      if AQueryOrigem.Fields.Fields[i].isNull then
      begin
        AQueryDestino.ParamByName('P' + AQueryOrigem.Fields.Fields[i].FieldName).Value := null;
      end
      else
        AQueryDestino.ParamByName('P' + AQueryOrigem.Fields.Fields[i].FieldName).Value := AQueryOrigem.Fields.Fields[i].Value
    end
  end;
end;

procedure MontaFiltroIn(pQuery: TFDQuery; pCampo: string; plista: TStrings);
const
  cQuantidaMaxima: Integer = 999;
var
  vContador: Integer;
  vListaContasAux: TStringList;

  procedure InsereFiltro;
  begin

    pQuery.Sql.Add(IfThen(vContador > cQuantidaMaxima, ' OR ', EmptyStr) + pCampo + ' IN (' + vListaContasAux.CommaText + ')');

  end;

begin

  vListaContasAux := TStringList.Create;

  if (AnsiContainsStr(pQuery.Sql.Text, ' AND ')) then
    pQuery.Sql.Add(' AND ');

  pQuery.Sql.Add(' ( ');

  for vContador := 0 to plista.Count - 1 do
  begin

    vListaContasAux.Add(plista.Strings[vContador]);

    if (vListaContasAux.Count < cQuantidaMaxima) then
      Continue;

    InsereFiltro;
    vListaContasAux.Clear;

  end;

  InsereFiltro;
  pQuery.Sql.Add(' ) ');
  FreeAndNil(vListaContasAux);

end;

function ReturnSQL(Str, DataBas: string): Boolean;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.ConnectionName := DataBas;
  qry.Sql.Text := Str;
  qry.Open;
  Result := not qry.IsEmpty;
  qry.Free;
end;
end.

