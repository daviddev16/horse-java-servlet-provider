unit H2S.Pipeline;

interface

uses
  H2S.Payload,
  Horse.Request,
  Horse.Response;

type
  TRequestPipelineContext = class
    strict private
      FRawRequestData: TRawRequestData;
      FHorseRequest: THorseRequest;
      FHorseResponse: THorseResponse;
    public
      procedure SetRequestData(const Value: TRawRequestData);
      function GetRawResponseData(): TRawResponseData;

      function GetHorseRequest(): THorseRequest;
      function GetHorseResponse(): THorseResponse;

      constructor Create(const RawRequestData: TRawRequestData);
      destructor Destroy(); override;
    public
      property Response: THorseResponse read GetHorseResponse;
      property Request: THorseRequest read GetHorseRequest;
      property RawResponse: TRawResponseData read GetRawResponseData;
    end;

implementation

uses
  Horse,
  H2S.Request,
  H2S.Response,
  System.SysUtils;

{ TRequestPipelineContext }

constructor TRequestPipelineContext.Create(const RawRequestData: TRawRequestData);
begin
  FRawRequestData := RawRequestData;
end;

function TRequestPipelineContext.GetHorseRequest(): THorseRequest;
begin
  if not Assigned(FHorseRequest) then
    FHorseRequest := THorseRequest.Create(TServletAdaptedWebRequestAdapter.Create(FRawRequestData));

  Result := FHorseRequest;
end;

function TRequestPipelineContext.GetHorseResponse(): THorseResponse;
begin
  if not Assigned(FHorseResponse) then
    FHorseResponse := THorseResponse.Create(TServletAdaptedWebResponseAdapter.Create());

  Result := FHorseResponse;
end;

function TRequestPipelineContext.GetRawResponseData(): TRawResponseData;
begin
  Result.Body := FHorseResponse.RawWebResponse.Content;
  Result.StatusCode := FHorseResponse.RawWebResponse.StatusCode;
end;

procedure TRequestPipelineContext.SetRequestData(const Value: TRawRequestData);
begin
  FRawRequestData := Value;
end;


destructor TRequestPipelineContext.Destroy();
begin
  if Assigned(FHorseRequest) then
    FreeAndNil(FHorseRequest);

  if Assigned(FHorseResponse) then
    FreeAndNil(FHorseResponse);
  inherited;
end;

end.
