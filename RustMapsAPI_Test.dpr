program RustMapsAPI_Test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  RustMapsAPI in 'API\RustMapsAPI.pas',
  RustMapsAPI.Types in 'API\RustMapsAPI.Types.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
