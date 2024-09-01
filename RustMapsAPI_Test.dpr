program RustMapsAPI_Test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  RustMapsAPI in 'API\RustMapsAPI.pas',
  RustMapsAPI.Types in 'API\RustMapsAPI.Types.pas';

const
  API_KEY = '';

procedure GetMapGenLimits;
begin
  var api := TRustMapsAPI.Create;
  try
    api.APIKey := API_KEY;

    var resp := api.GetMapGenLimits;

    if resp.HasParsedData then
    begin
      Writeln('-- ConCurrent --');
      Writeln('Current: ', resp.ParsedData.ConCurrent.Current);
      Writeln('Allowed: ', resp.ParsedData.ConCurrent.Allowed);
      Writeln('');
      Writeln('-- Monthly --');
      Writeln('Current: ', resp.ParsedData.Monthly.Current);
      Writeln('Allowed: ', resp.ParsedData.Monthly.Allowed);
    end
    else
    begin
      Writeln(resp.RawData);
    end;
  finally
    api.Free;
  end;
end;

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

procedure GetMapBySizeSeed;
begin
  var api := TRustMapsAPI.Create;
  try
    api.APIKey := API_KEY;

    var res := api.GetMap(1495858156, 4000, False);

    Writeln(res.StatusCode.ToString);
    Writeln(res.StatusText);
    Writeln(res.RawData);
    Writeln(res.ParsedData.URL);

    Writeln('');
    Writeln(res.RateLimit.RateLimit);
    Writeln(res.RateLimit.RateLimitRemaining);
    Writeln(DateTimeToStr(res.RateLimit.RateLimitReset));
  finally
    api.Free;
  end;
end;

procedure Main;
begin
  GetMapGenLimits;
end;

begin
  try
    Main
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
    end;
  end;

  Writeln('Program End.');
  ReadLn;
end.

