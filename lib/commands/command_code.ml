[%%cenum
type t =
  | SelfTest [@id 0x00000143]
  | Startup [@id 0x00000144]
  | Shutdown [@id 0x00000145]
  | GetCapability [@id 0x0000017A]
[@@uint32_t] [@@sexp]]
[@@deriving show]
