unit RustMapsAPI;

interface

uses
  System.SysUtils, REST.Client, Rest.Types, RustMapsAPI.Types;

type // Generic Response Type
  TRMAPIResponse<T> = record
    Data: T;
    RawData: string;
    StatusCode: Integer;
    StatusText: string;
  end;

type // TRustMapsAPI Class
  TRustMapsAPI = class
  private
  { Private Const }
    const
      API_BASEURL = 'https://api.rustmaps.com';
  private
  { Private Variables }
    FAPIKey: string;
    FTimeout: Integer;
  private
  { Private Methods }
    function SetupRest: TRESTRequest;
  public
  { Public Methods }
    constructor Create(const APIKey: string = '');
  public
  { API Methods }
    // Maps
    function RequestMapGeneration(const Size, Seed: Integer; const Staging: boolean): TRMAPIResponse<string>;
    function GetMap(const MapID: string): TRMAPIResponse<string>;
  published
  { Published Properties }
    property APIKey: string read FAPIKey write FAPIKey;
    property Timeout: Integer read FTimeout write FTimeout;
  end;

implementation

{ TRustMapAPI }

constructor TRustMapsAPI.Create(const APIKey: string);
begin
  inherited Create;

  // Defaults
  Self.FAPIKey := '';
  Self.FTimeout := 10000;

  // Assign API Key if provided
  if not FAPIKey.Trim.IsEmpty then
    FAPIKey := APIKey;
end;

function TRustMapsAPI.GetMap(const MapID: string): TRMAPIResponse<string>;
begin
  var rest := Self.SetupRest;
  try
    { Setup }
    rest.Resource := '/v4/maps/{mapId}';
    rest.Method := TRESTRequestMethod.rmGET;

    // Params
    rest.AddParameter('mapId', MapID, TRESTRequestParameterKind.pkURLSEGMENT);

    { Execute }
    rest.Execute;

    { Response }
    Result.RawData := rest.Response.Content;
    Result.Data := rest.Response.Content;
    Result.StatusCode := rest.Response.StatusCode;
    Result.StatusText := rest.Response.StatusText;
  finally
    rest.Free;
  end;
end;

function TRustMapsAPI.RequestMapGeneration(const Size, Seed: Integer; const Staging: boolean): TRMAPIResponse<string>;
begin
  var rest := Self.SetupRest;
  try
    { Setup }
    rest.Resource := '/v4/maps';
    rest.Method := TRESTRequestMethod.rmPOST;

    { Body }
    rest.Body.JSONWriter.WriteStartObject;

    // Size
    rest.Body.JSONWriter.WritePropertyName('size');
    rest.Body.JSONWriter.WriteValue(Size);

    // Seed
    rest.Body.JSONWriter.WritePropertyName('seed');
    rest.Body.JSONWriter.WriteValue(Seed);

    // Staging
    rest.Body.JSONWriter.WritePropertyName('staging');
    rest.Body.JSONWriter.WriteValue(Staging);

    rest.Body.JSONWriter.WriteEndObject;

    { Execute }
    rest.Execute;

    { Response }
    Result.RawData := rest.Response.Content;
    Result.Data := rest.Response.Content;
    Result.StatusCode := rest.Response.StatusCode;
    Result.StatusText := rest.Response.StatusText;
  finally
    rest.Free;
  end;
end;

function TRustMapsAPI.SetupRest: TRESTRequest;
begin
  // Create Rest components
  Result := TRESTRequest.Create(nil);
  Result.Client := TRESTClient.Create(Result);
  Result.Response := TRESTResponse.Create(Result);

  // Setup
  Result.Client.BaseURL := API_BASEURL;
  Result.Client.RaiseExceptionOn500 := False;
  Result.Timeout := FTimeout;

  // Auth
  Result.AddParameter('X-API-Key', FAPIKey, TRESTRequestParameterKind.pkHTTPHEADER);
end;

end.

