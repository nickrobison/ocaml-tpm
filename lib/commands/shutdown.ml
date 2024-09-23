open Sexplib.Std
module S = Serialization

type config = { clear : bool }
type t = { clear_tpm : bool } [@@deriving sexp]

let code = Command_code.Shutdown
let create c = { clear_tpm = c.clear }

let serialize t =
  let payload = Cstruct.create 2 in
  (*Startup type is a single uint16*)
  let startup_type = if t.clear_tpm then 0 else 1 in
  Cstruct.BE.set_uint16 payload 0 startup_type;
  let header = S.Command_header.make_header (Command_code.t_to_int code) 2 in
  let combined = Cstruct.append header payload in
  Ok combined
