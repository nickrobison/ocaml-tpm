[%%cenum
type t =
  | PowerOn [@id 1]
  | SendCommand [@id 8]
  | NVOn [@id 11]
  | Reset [@id 17]
  | SessionEnd [@id 20]
  | Stop [@id 21]
[@@uint32_t]]
[@@deriving show]

[%%cstruct type payload = { command : uint32_t } [@@big_endian]]
