unit RustMapsAPI.Types;

interface

{ Maps }

type // RequestMapGeneration Response
  TRMReqMapGenResponse = record
    MapID: string;
    QueuePosition: Integer;
    State: string;
  end;

type // GetMap Response
  TRMGetMapResponse = record
    MapID: string;
    MapType: string;
    Seed: Integer;
    Size: Integer;
    URL: string;
    RawImageURL: string;
    ImageURL: string;
    ImageIconURL: string;
    ThumbnailURL: string;
    IsStaging: boolean;
    IsCustomMap: Boolean;
    CanDownload: Boolean;
    DownloadURL: string;
    TotalMonuments: Integer;
    LandPercentageOfMap: Integer;
    IslandsCount: Integer;
    MountainCount: Integer;
    IceLakeCount: Integer;
    RiverCount: Integer;
  end;

implementation

end.

