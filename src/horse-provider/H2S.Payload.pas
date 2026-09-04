unit H2S.Payload;

interface

uses
  REST.Json,
  REST.Json.Types;

type
  KVString = String;

  TKVStringArray = TArray<KVString>;

  TRawRequestData = record
    [JSONName('b')]     Body: String;
    [JSONName('q_s')]   QueryString: String;
    [JSONName('c_t')]   ContentType: String;
    [JSONName('c_l')]   ContentLength: Integer;
    [JSONName('p_i')]   PathInfo: String;
    [JSONName('m_t')]   MethodType: String;
    [JSONName('q_kv')]  Queries: TKVStringArray;
    [JSONName('h_kv')]  Headers: TKVStringArray;
    [JSONName('p_v')]   ProtocolVersion: String;
    [JSONName('l_p')]   LocalPort: Integer;
    [JSONName('l_h')]   LocalHost: String;
    [JSONName('r_a')]   RemoteAddress: String;
    [JSONName('r_p')]   RemotePort: Integer;
    [JSONName('f_p')]   FullPath: String;
    [JSONName('c_kv')]  Cookies: TKVStringArray;
  end;

  TRawResponseData = record
    [JSONName('b')]   Body: String;
    [JSONName('c_t')] ContentType: String;
    [JSONName('s_c')] StatusCode: Integer;
  end;

implementation end.
