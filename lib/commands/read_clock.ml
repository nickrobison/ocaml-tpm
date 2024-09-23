open Sexplib.Std
module S = Serialization

type config = unit

let code = Command_code.ReadClock

type t = unit [@@deriving sexp]

let create () = ()

let serialize _t =
  let header = S.Command_header.make_header (Command_code.t_to_int code) 0 in
  Ok header
