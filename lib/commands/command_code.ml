[%%cenum
type t =
  | SelfTest [@id 0x00000143]
  | Startup [@id 0x00000144]
  | Shutdown [@id 0x00000145]
  | GetCapability [@id 0x0000017A]
  | GetRandom [@id 0x0000017B]
  | ReadClock [@id 0x00000181]
[@@uint32_t] [@@sexp]]
[@@deriving show]
