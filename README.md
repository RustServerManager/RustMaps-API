# RustMaps API

Delphi Implementation of the Rust Maps API.

* [RustMaps API Documentation](https://api.rustmaps.com/docs/index.html?url=/swagger/v4-public/swagger.json#/)
* [RustMaps API Key](https://rustmaps.com/dashboard)

## Generic Response Data

All API Calls will have the following response data.

```delphi
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
    RawData: string; // Unparsed json data
    StatusCode: Integer; // Used to view the state of the API request. See RustMaps API Documentation
    StatusText: string;
    RateLimit: TRMRateLimit;
  end;
```

* `HasParsedData: Boolean;` - True / False depending if `ParsedData` is available. If not you will have to manually parse the `RawData` (JSON).
* `ParsedData: T;` - Contains a parsed record type of data for the API call. This is not available for all api calls.

The `StatusCode` value must be used to check the result of the API call. Each status code has a different meaning for each API call. I have done this in the "Request Map Generation" API example below and will not show it in others. The status codes for each API call can be viewed in the [RustMaps API Documentation](https://api.rustmaps.com/docs/index.html?url=/swagger/v4-public/swagger.json#/).

## Maps API

### Request Map Generation `[POST] /v4/maps`

```delphi
procedure RequestMapGen;
begin
  var api := TRustMapsAPI.Create;
  try
    api.APIKey := API_KEY; // Rust Maps API Key

                                       //Size,   Seed   , Staging
    var resp := api.RequestMapGeneration(3123, 613511321, False);

    // Handle Status Codes
    case resp.StatusCode of
      200:
        Writeln('Map Already Exists!');
      201:
        begin
          Writeln('Map generation request successful');

          if resp.HasParsedData then
          begin
            // Status code 200 contains all parsed data
            Writeln(resp.ParsedData.MapID);
            Writeln(resp.ParsedData.QueuePosition);
            Writeln(resp.ParsedData.State);
          end;
        end;
      400:
        Writeln('Bad Request');
      401:
        Writeln('Unauthorized');
      403:
        Writeln('Forbidden');
      409:
        begin
          Writeln('Map already exists, but is not ready yet');

          if resp.HasParsedData then
          begin
            // Status code 409 only contains the map id
            Writeln(resp.ParsedData.MapID);
          end;
        end;
    end;

    // Generic Data
    Writeln(resp.StatusCode.ToString); // Check RustMaps API Documentation on code meanings
    Writeln(resp.StatusText);
    Writeln(resp.RawData); // Unparsed Raw JSON Data

    // Rate Limit Data
    Writeln(resp.RateLimit.RateLimit);
    Writeln(resp.RateLimit.RateLimitRemaining);
    Writeln(DateTimeToStr(resp.RateLimit.RateLimitReset));
  finally
    api.Free;
  end;
end;
```

### Get a map by ID `[GET] /v4/maps/{mapId}`

```delphi
procedure GetMapByID;
begin
  var api := TRustMapsAPI.Create;
  try
    api.APIKey := API_KEY;

    var res := api.GetMap('30e4c14b699a4999a2c3c088a4f0c7b6');

    // Parsed Data
    if res.HasParsedData then
    begin
      Writeln(res.ParsedData.RawImageURL);
      // There's more not shown here.
      // See TRMGetMapResponse in the RustMapsAPI.Types unit
    end;

    // Generic Data
    Writeln(res.StatusCode.ToString);
    Writeln(res.StatusText);
    Writeln(res.RawData);

    // Rate Limit Data
    Writeln(res.RateLimit.RateLimit);
    Writeln(res.RateLimit.RateLimitRemaining);
    Writeln(DateTimeToStr(res.RateLimit.RateLimitReset));
  finally
    api.Free;
  end;
end;
```

### Get a map by seed, size and staging `[GET] /v4/maps/{size}/{seed}`

```delphi
procedure GetMapBySizeSeed;
begin
  var api := TRustMapsAPI.Create;
  try
    api.APIKey := API_KEY;

    var res := api.GetMap(1495858156, 4000, False);

    // Parsed Data
    if res.HasParsedData then
    begin
      Writeln(res.ParsedData.RawImageURL);
      // There's more not shown here.
      // See TRMGetMapResponse in the RustMapsAPI.Types unit
    end;

    // Generic Data
    Writeln(res.StatusCode.ToString);
    Writeln(res.StatusText);
    Writeln(res.RawData);

    // Rate Limit Data
    Writeln(res.RateLimit.RateLimit);
    Writeln(res.RateLimit.RateLimitRemaining);
    Writeln(DateTimeToStr(res.RateLimit.RateLimitReset));
  finally
    api.Free;
  end;
end;
```
