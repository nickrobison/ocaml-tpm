type t =
  | SelfTest
  | Startup
  | Shutdown
  | GetCapability
  | GetRandom
  | ReadClock
  | PcrRead
[@@deriving sexp, show, eq]

val t_to_int : t -> int32
val t_to_string : t -> string
