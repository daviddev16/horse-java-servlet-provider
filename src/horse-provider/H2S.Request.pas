unit H2S.Request;

interface

uses
  Horse.Request,
  Horse.Provider.RawAdapters,
  Horse.Provider.RawInterfaces,
  H2S.Payload,
  System.Classes,
  System.SysUtils;

type
  TServletAdaptedRawRequest = class(TInterfacedObject, IHorseRawRequest)
    strict private
      FBodyStream: TStream;
      FRequestData: TRawRequestData;
    private
      procedure PopulateWith(const Strings: TStrings; const KVStringArray: TKVStringArray);
    public
      constructor Create(const RequestData: TRawRequestData);
      destructor Destroy(); override;

      { IHorseRawRequest }
      function  GetMethod: String;
      function  GetProtocolVersion: String;
      function  GetURL: String;
      function  GetPathInfo: String;
      function  GetQueryString: String;
      function  GetHost: String;
      function  GetRemoteAddr: String;
      function  GetServerPort: Integer;
      function  GetContentType: String;
      function  GetContent: String;
    {$IF DEFINED(FPC)}
      function  GetContentLength: Integer;
    {$ELSEIF CompilerVersion >= 32.0}
      function  GetContentLength(): Int64;
    {$ELSE}
      function  GetContentLength(): Integer;
    {$IFEND}
      function  GetFieldByName(const AName: String): String;
      procedure PopulateHeaders(ADest: TStrings);
      procedure PopulateQueryFields(ADest: TStrings);
      procedure PopulateContentFields(ADest: TStrings);
      procedure PopulateCookieFields(ADest: TStrings);
      function  ReadBody(var Buffer; Count: Integer): Integer;
    end;

  TServletAdaptedWebRequestAdapter = class(TInterfacedWebRequest)
    public
      constructor Create(const RequestData: TRawRequestData); reintroduce;
    end;

implementation

{ TServletAdaptedRawRequest }

constructor TServletAdaptedRawRequest.Create(const RequestData: TRawRequestData);
begin
  FRequestData := RequestData;
end;

function TServletAdaptedRawRequest.GetContent(): String;
begin
  Result := FRequestData.Body;
end;

{$IF DEFINED(FPC)}
  function  TServletAdaptedRawRequest.GetContentLength(): Integer;
{$ELSEIF CompilerVersion >= 32.0}
  function  TServletAdaptedRawRequest.GetContentLength(): Int64;
{$ELSE}
  function  TServletAdaptedRawRequest.GetContentLength(): Integer;
{$IFEND}
begin
  Result := FRequestData.ContentLength;
end;

function TServletAdaptedRawRequest.GetContentType(): String;
begin
  Result := FRequestData.ContentType;
end;

function TServletAdaptedRawRequest.GetFieldByName(const AName: String): String;
begin
  for var HeaderPairStr in FRequestData.Headers do
  begin
    var Pair := HeaderPairStr.Split(['=']);
    if Pair[0] = AName then
      Exit(Pair[1]);
  end;

  Result := '';
end;

function TServletAdaptedRawRequest.GetHost(): String;
begin
  Result := FRequestData.LocalHost;
end;

function TServletAdaptedRawRequest.GetMethod(): String;
begin
  Result := FRequestData.MethodType;
end;

function TServletAdaptedRawRequest.GetPathInfo(): String;
begin
  Result := FRequestData.PathInfo;
end;

function TServletAdaptedRawRequest.GetProtocolVersion(): String;
begin
  Result := FRequestData.ProtocolVersion;
end;

function TServletAdaptedRawRequest.GetQueryString(): String;
begin
  Result := FRequestData.QueryString;
end;

function TServletAdaptedRawRequest.GetRemoteAddr(): String;
begin
  Result := FRequestData.RemoteAddress;
end;

function TServletAdaptedRawRequest.GetServerPort(): Integer;
begin
  Result := FRequestData.LocalPort;
end;

function TServletAdaptedRawRequest.GetURL(): String;
begin
  Result := FRequestData.FullPath;
end;

procedure TServletAdaptedRawRequest.PopulateContentFields(ADest: TStrings);
begin
  PopulateWith(ADest, FRequestData.Queries);
end;

procedure TServletAdaptedRawRequest.PopulateCookieFields(ADest: TStrings);
begin
  PopulateWith(ADest, FRequestData.Cookies);
end;

procedure TServletAdaptedRawRequest.PopulateHeaders(ADest: TStrings);
begin
  PopulateWith(ADest, FRequestData.Headers);
end;

procedure TServletAdaptedRawRequest.PopulateQueryFields(ADest: TStrings);
begin
  PopulateWith(ADest, FRequestData.Queries);
end;

procedure TServletAdaptedRawRequest.PopulateWith(const Strings: TStrings;
  const KVStringArray: TKVStringArray);
begin
  for var KVString in KVStringArray do
  begin
    var Pair := KVString.Split(['=']);
    Strings.AddPair(Pair[0], Pair[1]);
  end;
end;

function TServletAdaptedRawRequest.ReadBody(var Buffer; Count: Integer): Integer;
begin
  if FBodyStream = nil then
    FBodyStream := TStringStream.Create(FRequestData.Body);

  Result := FBodyStream.Read(Buffer, Count);
end;

destructor TServletAdaptedRawRequest.Destroy();
begin
  if Assigned(FBodyStream) then
    FreeAndNil(FBodyStream);
  inherited;
end;

{ TServletAdaptedWebRequestAdapter }

constructor TServletAdaptedWebRequestAdapter.Create(const RequestData: TRawRequestData);
begin
  inherited Create(TServletAdaptedRawRequest.Create(RequestData));
end;

end.
