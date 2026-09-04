unit H2S.Response;

interface

uses
{$IF DEFINED(FPC)}
  SysUtils,
{$ELSE}
  System.SysUtils,
{$ENDIF}
  H2S.Payload,
  Horse.Provider.RawAdapters,
  Horse.Provider.RawInterfaces;

type
  TServletAdaptedRawResponse = class(TInterfacedObject, IHorseRawResponse)
    public
    { IHorseRawResponse }
    procedure SetCustomHeader(const AName, AValue: string);
    end;

  TServletAdaptedWebResponseAdapter = class(TInterfacedWebResponse)
    strict private
      FContent: TWebString;
      FStatusCode: Integer;
    public
      function  GetContent(): TWebString; override;
      procedure SetContent(const Value: TWebString); override;

      function  GetStatusCode: Integer; override;
      procedure SetStatusCode(Value: Integer); override;
    public
      constructor Create(); reintroduce;
    end;

implementation

procedure TServletAdaptedRawResponse.SetCustomHeader(const AName, AValue: string);
begin end;

{ TServletAdaptedWebResponseAdapter }

constructor TServletAdaptedWebResponseAdapter.Create();
begin
  inherited Create(TServletAdaptedRawResponse.Create());
end;

function TServletAdaptedWebResponseAdapter.GetContent(): TWebString;
begin
  Result := FContent;
end;

function TServletAdaptedWebResponseAdapter.GetStatusCode(): Integer;
begin
  Result := FStatusCode;
end;

procedure TServletAdaptedWebResponseAdapter.SetContent(const Value: TWebString);
begin
  FContent := Value;
end;

procedure TServletAdaptedWebResponseAdapter.SetStatusCode(Value: Integer);
begin
  FStatusCode := Value;
end;

end.
