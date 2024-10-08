unit RustMapsAPI;

interface

uses
  System.SysUtils, System.DateUtils, System.Classes, REST.Client, Rest.Types,
  RustMapsAPI.Types;

type // Rate Limit Response
  TRMRateLimit = record
    RateLimit: string;
    RateLimitRemaining: Integer;
    RateLimitReset: TDateTime;
  end;

type // Generic Response Type
  TRMAPIResponse<T> = record
  public
    HasParsedData: Boolean;
    ParsedData: T;
    RawData: string;
    StatusCode: Integer;
    StatusText: string;
    RateLimit: TRMRateLimit;
  end;

type // TRustMapsAPI Class
  TRustMapsAPI = class
  private
  { Private Const }
    const
      API_BASEURL = 'https://api.rustmaps.com';
      DEFAULT_USERAGENT = 'RustMapsDelphiAPI/1.0';
  private
  { Private Variables }
    FAPIKey: string;
    FUserAgent: string;
    FTimeout: Integer;
    FOrgeID: string;
  private
  { Private Methods }
    function SetupRest: TRESTRequest;
    function ParseRateLimitHeaders(const Headers: TStrings): TRMRateLimit;
  public
  { Public Methods }
    constructor Create(const APIKey: string = '');
  public
  { API Methods }
    // Maps
    function RequestMapGeneration(const Size, Seed: Integer; const Staging: boolean): TRMAPIResponse<TRMReqMapGenResponse>;
    function GetMap(const MapID: string): TRMAPIResponse<TRMGetMapResponse>; overload;
    function GetMap(const Seed, Size: Integer; const Staging: boolean): TRMAPIResponse<TRMGetMapResponse>; overload;
    // Misc
    function GetMapGenLimits: TRMAPIResponse<TRMGetMapGenLimitsResponse>;
  published
  { Published Properties }
    property APIKey: string read FAPIKey write FAPIKey;
    property UserAgent: string read FUserAgent write FUserAgent;
    property Timeout: Integer read FTimeout write FTimeout;
    property OrgID: string read FOrgeID write FOrgeID;
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

function TRustMapsAPI.GetMap(const MapID: string): TRMAPIResponse<TRMGetMapResponse>;
begin
  Result.HasParsedData := False;

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
    Result.RateLimit := Self.ParseRateLimitHeaders(rest.Response.Headers);
    Result.RawData := rest.Response.Content;
    Result.StatusCode := rest.Response.StatusCode;
    Result.StatusText := rest.Response.StatusText;

    // Parsed Data
    if rest.Response.StatusCode = 200 then // Map Exists and data was returned
    begin
      Result.ParsedData.MapID := rest.Response.JSONValue.GetValue<string>('data.id');
      Result.ParsedData.MapType := rest.Response.JSONValue.GetValue<string>('data.type');
      Result.ParsedData.Seed := rest.Response.JSONValue.GetValue<Integer>('data.seed');
      Result.ParsedData.Size := rest.Response.JSONValue.GetValue<Integer>('data.size');
      Result.ParsedData.URL := rest.Response.JSONValue.GetValue<string>('data.url');
      Result.ParsedData.RawImageURL := rest.Response.JSONValue.GetValue<string>('data.rawImageUrl');
      Result.ParsedData.ImageURL := rest.Response.JSONValue.GetValue<string>('data.imageUrl');
      Result.ParsedData.ImageIconURL := rest.Response.JSONValue.GetValue<string>('data.imageIconUrl');
      Result.ParsedData.ThumbnailURL := rest.Response.JSONValue.GetValue<string>('data.thumbnailUrl');
      Result.ParsedData.IsStaging := rest.Response.JSONValue.GetValue<Boolean>('data.isStaging');
      Result.ParsedData.IsCustomMap := rest.Response.JSONValue.GetValue<Boolean>('data.isCustomMap');
      Result.ParsedData.CanDownload := rest.Response.JSONValue.GetValue<Boolean>('data.canDownload');
      Result.ParsedData.DownloadURL := rest.Response.JSONValue.GetValue<string>('data.downloadUrl');
      Result.ParsedData.TotalMonuments := rest.Response.JSONValue.GetValue<Integer>('data.totalMonuments');
      Result.ParsedData.LandPercentageOfMap := rest.Response.JSONValue.GetValue<Integer>('data.landPercentageOfMap');
      Result.ParsedData.IslandsCount := rest.Response.JSONValue.GetValue<Integer>('data.islands');
      Result.ParsedData.MountainCount := rest.Response.JSONValue.GetValue<Integer>('data.mountains');
      Result.ParsedData.IceLakeCount := rest.Response.JSONValue.GetValue<Integer>('data.iceLakes');
      Result.ParsedData.RiverCount := rest.Response.JSONValue.GetValue<Integer>('data.rivers');

      Result.HasParsedData := True;
    end;
  finally
    rest.Free;
  end;
end;

function TRustMapsAPI.GetMap(const Seed, Size: Integer; const Staging: boolean): TRMAPIResponse<TRMGetMapResponse>;
begin
  Result.HasParsedData := False;

  var rest := Self.SetupRest;
  try
    { Setup }
    rest.Resource := '/v4/maps/{size}/{seed}';
    rest.Method := TRESTRequestMethod.rmGET;

    // Params
    rest.AddParameter('size', Size.ToString, TRESTRequestParameterKind.pkURLSEGMENT);
    rest.AddParameter('seed', Seed.ToString, TRESTRequestParameterKind.pkURLSEGMENT);
    rest.AddParameter('staging', BoolToStr(Staging, True), TRESTRequestParameterKind.pkQUERY);

    { Execute }
    rest.Execute;

    { Response }
    Result.RateLimit := Self.ParseRateLimitHeaders(rest.Response.Headers);
    Result.RawData := rest.Response.Content;
    Result.StatusCode := rest.Response.StatusCode;
    Result.StatusText := rest.Response.StatusText;

    // Parsed Data
    if rest.Response.StatusCode = 200 then // Map Exists and data was returned
    begin
      Result.ParsedData.MapID := rest.Response.JSONValue.GetValue<string>('data.id');
      Result.ParsedData.MapType := rest.Response.JSONValue.GetValue<string>('data.type');
      Result.ParsedData.Seed := rest.Response.JSONValue.GetValue<Integer>('data.seed');
      Result.ParsedData.Size := rest.Response.JSONValue.GetValue<Integer>('data.size');
      Result.ParsedData.URL := rest.Response.JSONValue.GetValue<string>('data.url');
      Result.ParsedData.RawImageURL := rest.Response.JSONValue.GetValue<string>('data.rawImageUrl');
      Result.ParsedData.ImageURL := rest.Response.JSONValue.GetValue<string>('data.imageUrl');
      Result.ParsedData.ImageIconURL := rest.Response.JSONValue.GetValue<string>('data.imageIconUrl');
      Result.ParsedData.ThumbnailURL := rest.Response.JSONValue.GetValue<string>('data.thumbnailUrl');
      Result.ParsedData.IsStaging := rest.Response.JSONValue.GetValue<Boolean>('data.isStaging');
      Result.ParsedData.IsCustomMap := rest.Response.JSONValue.GetValue<Boolean>('data.isCustomMap');
      Result.ParsedData.CanDownload := rest.Response.JSONValue.GetValue<Boolean>('data.canDownload');
      Result.ParsedData.DownloadURL := rest.Response.JSONValue.GetValue<string>('data.downloadUrl');
      Result.ParsedData.TotalMonuments := rest.Response.JSONValue.GetValue<Integer>('data.totalMonuments');
      Result.ParsedData.LandPercentageOfMap := rest.Response.JSONValue.GetValue<Integer>('data.landPercentageOfMap');
      Result.ParsedData.IslandsCount := rest.Response.JSONValue.GetValue<Integer>('data.islands');
      Result.ParsedData.MountainCount := rest.Response.JSONValue.GetValue<Integer>('data.mountains');
      Result.ParsedData.IceLakeCount := rest.Response.JSONValue.GetValue<Integer>('data.iceLakes');
      Result.ParsedData.RiverCount := rest.Response.JSONValue.GetValue<Integer>('data.rivers');

      Result.HasParsedData := True;
    end;
  finally
    rest.Free;
  end;
end;

function TRustMapsAPI.GetMapGenLimits: TRMAPIResponse<TRMGetMapGenLimitsResponse>;
begin
  Result.HasParsedData := False;

  var rest := Self.SetupRest;
  try
    rest.Resource := '/v4/maps/limits';
    rest.Method := TRESTRequestMethod.rmGET;

    rest.Execute;

    Result.RateLimit := Self.ParseRateLimitHeaders(rest.Response.Headers);
    Result.RawData := rest.Response.Content;
    Result.StatusCode := rest.Response.StatusCode;
    Result.StatusText := rest.Response.StatusText;

    if rest.Response.StatusCode = 200 then
    begin
      // Concurrent
      Result.ParsedData.ConCurrent.Current := rest.Response.JSONValue.GetValue<Integer>('data.concurrent.current');
      Result.ParsedData.ConCurrent.Allowed := rest.Response.JSONValue.GetValue<Integer>('data.concurrent.allowed');

      // Monthly
      Result.ParsedData.Monthly.Current := rest.Response.JSONValue.GetValue<Integer>('data.monthly.current');
      Result.ParsedData.Monthly.Allowed := rest.Response.JSONValue.GetValue<Integer>('data.monthly.allowed');

      Result.HasParsedData := True;
    end;
  finally
    rest.Free;
  end;
end;

function TRustMapsAPI.ParseRateLimitHeaders(const Headers: TStrings): TRMRateLimit;
begin
  Result.RateLimit := Headers.Values['x-rate-limit-limit'];
  Result.RateLimitRemaining := Headers.Values['x-rate-limit-remaining'].ToInteger;
  Result.RateLimitReset := ISO8601ToDate(Headers.Values['x-rate-limit-reset'], True);
end;

function TRustMapsAPI.RequestMapGeneration(const Size, Seed: Integer; const Staging: boolean): TRMAPIResponse<TRMReqMapGenResponse>;
begin
  Result.HasParsedData := False;

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
    Result.RateLimit := Self.ParseRateLimitHeaders(rest.Response.Headers);
    Result.RawData := rest.Response.Content;
    Result.StatusCode := rest.Response.StatusCode;
    Result.StatusText := rest.Response.StatusText;

    // Parsed Data
    if rest.Response.StatusCode = 201 then  // Map generation request successful
    begin
      Result.ParsedData.MapID := rest.Response.JSONValue.GetValue<string>('data.mapid');
      Result.ParsedData.QueuePosition := rest.Response.JSONValue.GetValue<Integer>('data.mapid');
      Result.ParsedData.State := rest.Response.JSONValue.GetValue<string>('data.state');

      Result.HasParsedData := True;
    end
    else if rest.Response.StatusCode = 409 then // Map already exists, but is not ready yet
    begin
      Result.ParsedData.MapID := rest.Response.JSONValue.GetValue<string>('data.id');
      Result.ParsedData.QueuePosition := -1;
      Result.ParsedData.State := '';

      Result.HasParsedData := True;
    end;
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
  Result.Client.BaseURL := SELF.API_BASEURL;
  Result.Client.RaiseExceptionOn500 := False;
  Result.Timeout := Self.FTimeout;
  Result.Client.UserAgent := Self.FUserAgent;

  // Auth
  Result.AddParameter('X-API-Key', Self.FAPIKey, TRESTRequestParameterKind.pkHTTPHEADER);

  // OrgID
  if not Self.FOrgeID.Trim.IsEmpty then
  begin
    Result.AddParameter('x-org-id', Self.FOrgeID, TRESTRequestParameterKind.pkHTTPHEADER);
  end;
end;

end.

