[%%cenum
type t =
  | SelfTest
  | Startup
  | Shutdown
  | GetCapability
  | GetRandom
  | ReadClock
  | PcrRead
[@@uint32_t] [@@sexp]]
[@@deriving show]
