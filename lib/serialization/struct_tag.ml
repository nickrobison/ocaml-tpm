[%%cenum
type t =
  | Response [@id 0x00c4]
  | NoSessions [@id 0x8001]
  | Sessions [@id 0x8002]
[@@uint16_t]]
