program RustMapsAPI_Test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  RustMapsAPI in 'API\RustMapsAPI.pas',
  RustMapsAPI.Types in 'API\RustMapsAPI.Types.pas';

procedure Main;
begin
  var api := TRustMapsAPI.Create;
  try
    api.APIKey := '';

    var res := api.GetMap('dsfsdfdsfdsfdsf');
    Writeln(res.Data);
    Writeln(res.StatusCode.ToString);
    Writeln(res.StatusText);
  finally
    api.Free;
  end;
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

