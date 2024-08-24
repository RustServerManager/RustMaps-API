program RustMapsAPI_Test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  RustMapsAPI in 'API\RustMapsAPI.pas',
  RustMapsAPI.Types in 'API\RustMapsAPI.Types.pas';

const
  API_KEY = '';

procedure RequestMapGen;
begin
  var api := TRustMapsAPI.Create;
  try
    api.APIKey := API_KEY;

    var res := api.RequestMapGeneration(3123, 613511321, False);
    Writeln(res.ParsedData.MapID);
    Writeln(res.ParsedData.QueuePosition);
    Writeln(res.ParsedData.State);
    Writeln(res.StatusCode.ToString);
    Writeln(res.StatusText);
    Writeln(res.RawData);
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
  GetMapBySizeSeed;
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

