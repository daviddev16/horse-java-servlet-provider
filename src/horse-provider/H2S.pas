unit H2S;
interface
uses
  H2S.Payload,
  Horse.Provider.Abstract,
  System.SysUtils;
type
  THorseProviderH2S = class(THorseProviderAbstract)
    private
      class procedure InternalListen(); static;
    public
      class procedure Listen(); overload; override;
      class procedure Listen(const ACallback: TProc); reintroduce; overload; static;
    end;
  THorseProvider = THorseProviderH2S;
  TH2S = class
    private
      class function HandleRawRequest(const RequestStr: String): String;
    end;
var
  GH2SInitializeProc: TProc;
implementation
uses
  Horse,
  Horse.Exception,
  Horse.Exception.Interrupted,
  H2S.Pipeline,
  Core.Mapper,
  System.JSON.Serializers;
{ TH2S }
class function TH2S.HandleRawRequest(
  const RequestStr: String): String;
var
  Ctx: TRequestPipelineContext;
begin
  Ctx := TRequestPipelineContext.Create(
    TMapper.MapToAny<TRawRequestData>(RequestStr));
  try
    try
      THorse.Execute(Ctx.Request, Ctx.Response);

      Result := TMapper.RecordToJSON<TRawResponseData>(
        Ctx.GetRawResponseData());
    except
      on HEx: EHorseCallbackInterrupted do
      begin
        Result := TMapper.RecordToJSON<TRawResponseData>(
          Ctx.GetRawResponseData());
      end;
      on HEx0: EHorseException do
      begin
        var ResponseData: TRawResponseData;
        ResponseData.Body := HEx0.ToJSON();
        ResponseData.ContentType := 'application/json; charset=utf-8';
        ResponseData.StatusCode := Ord(HEx0.Status());
        Result := TMapper.RecordToJSON<TRawResponseData>(ResponseData);
      end;
      on Ex: Exception do
      begin
        var ResponseData: TRawResponseData;
        ResponseData.Body := ex.ClassName + ': ' + ex.Message + '=';
        ResponseData.ContentType := 'application/json; charset=utf-8';
        ResponseData.StatusCode := 569;
        Result := TMapper.RecordToJSON<TRawResponseData>(ResponseData);
      end;
    end;
  finally
    Ctx.Free();
  end;
end;
{ THorseProviderH2S }
class procedure THorseProviderH2S.InternalListen();
begin
  TriggerBeforeListen();
  DoOnListen();
end;
class procedure THorseProviderH2S.Listen();
begin
  inherited;
  InternalListen();
end;
class procedure THorseProviderH2S.Listen(const ACallback: TProc);
begin
  inherited;
  SetOnListen(ACallback);
  InternalListen;
end;
{$REGION 'Native Bridges'}
function FF_Initialize(): Integer; cdecl;
begin
  Result := 0;
  try
    if @GH2SInitializeProc <> nil then
      GH2SInitializeProc();
  except
    Result := -1;
  end;
end;
function FF_HandleRequest(RequestUtf8: PUTF8Char): PUTF8Char; cdecl;
var
  RequestStr, ResponseStr: String;
  RespUtf8: UTF8String;
  Len: Integer;
begin
  Result := nil;
  try
    RequestStr := UTF8ToString(RequestUtf8);
    ResponseStr := TH2S.HandleRawRequest(RequestStr);
    RespUtf8 := UTF8Encode(ResponseStr);
    Len := Length(RespUtf8);
    GetMem(Result, Len + 1); // +1 para o terminador nulo
    if Len > 0 then
      Move(PAnsiChar(RespUtf8)^, Result^, Len);
    PByte(Result)[Len] := 0;
  except
    on E: Exception do
    begin
      if Result <> nil then
        FreeMem(Result);
      Result := nil;
    end;
  end;
end;
procedure FF_ReclaimMemory(P: PUTF8Char); cdecl;
begin
  if P <> nil then
    FreeMem(P);
end;
exports
  FF_Initialize,
  FF_HandleRequest,
  FF_ReclaimMemory;
{$ENDREGION 'Native Bridges'}
  
end.
