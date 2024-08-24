unit RustMapsAPI.Types;

interface

{ Maps }
  // RequestMapGeneration Response

type
  TRMReqMapGenResponse = record
    MapID: string;
    QueuePosition: Integer;
    State: string;
  end;

implementation

end.

