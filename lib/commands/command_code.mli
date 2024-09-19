[%%cenum
type t = SelfTest | Startup | Shutdown | GetCapability [@@uint32_t] [@@sexp]]
[@@deriving show]
