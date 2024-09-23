open Sexplib.Std
module S = Serialization

let src = Logs.Src.create "read_clock_response"

module Log = (val Logs.src_log src : Logs.LOG)

type t = { current_time : int64 } [@@deriving sexp, show]

let get_time t = t.current_time

let deserialize b =
  Log.debug (fun f -> f "Response Payload: %a" Cstruct.hexdump_pp b);
  let time = S.Tpm_read_clock.get_t_time b in
  Ok { current_time = time }
