unit RustMapsAPI;

interface

uses
  System.SysUtils, REST.Client, Rest.Types, RustMapsAPI.Types;

type // Generic Response Type
  TRMAPIResponse<T> = record
    Data: T;
    Success: boolean;
    Message: string;
    StatusCode: Integer;
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
  private
  { Private Methods }
    function SetupRest: TRESTRequest;
  public
  { Public Methods }
    constructor Create(const APIKey: string = '');
  public
  { API Methods }

  published
  { Published Properties }
    property APIKey: string read FAPIKey write FAPIKey;
  end;

implementation

{ TRustMapAPI }

constructor TRustMapsAPI.Create(const APIKey: string);
begin
  inherited Create;

  // Assign API Key if provided
  if not FAPIKey.Trim.IsEmpty then
    FAPIKey := APIKey;
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

  // Auth
  Result.AddParameter('X-API-Key', FAPIKey, TRESTRequestParameterKind.pkHTTPHEADER);
end;

end.

