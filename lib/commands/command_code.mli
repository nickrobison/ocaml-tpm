[%%cenum
type t = SelfTest | Startup | Shutdown | GetCapability | GetRandom | ReadClock
[@@uint32_t] [@@sexp]]
[@@deriving show]
