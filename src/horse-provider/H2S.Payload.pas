unit H2S.Payload;

interface

uses
  Neon.Core.Attributes;

type
  KVString = String;

  TKVStringArray = TArray<KVString>;

  TRawRequestData = record
    [NeonProperty('b')]     Body: String;
    [NeonProperty('q_s')]   QueryString: String;
    [NeonProperty('c_t')]   ContentType: String;
    [NeonProperty('c_l')]   ContentLength: Integer;
    [NeonProperty('p_i')]   PathInfo: String;
    [NeonProperty('m_t')]   MethodType: String;
    [NeonProperty('q_kv')]  Queries: TKVStringArray;
    [NeonProperty('h_kv')]  Headers: TKVStringArray;
    [NeonProperty('p_v')]   ProtocolVersion: String;
    [NeonProperty('l_p')]   LocalPort: Integer;
    [NeonProperty('l_h')]   LocalHost: String;
    [NeonProperty('r_a')]   RemoteAddress: String;
    [NeonProperty('r_p')]   RemotePort: Integer;
    [NeonProperty('f_p')]   FullPath: String;
    [NeonProperty('c_kv')]  Cookies: TKVStringArray;
  end;

  TRawResponseData = record
    [NeonProperty('b')]   Body: String;
    [NeonProperty('c_t')] ContentType: String;
    [NeonProperty('c_l')] ContentLength: Integer;
    [NeonProperty('s_c')] StatusCode: Integer;
  end;

implementation end.
