open Sexplib.Std
module S = Serialization

let src = Logs.Src.create "read_clock_response"

module Log = (val Logs.src_log src : Logs.LOG)

type t = { clock : int64; time : int64; resets : int; restarts : int }
[@@deriving sexp, show]

(* Deserialize from time and clock info*)
let deserialize b =
  Log.debug (fun f -> f "Response Payload: %a" Cstruct.hexdump_pp b);
  let time = S.Tpm_read_clock.get_t_time b in
  let clock = S.Tpm_read_clock.get_t_clock b in
  let resets = S.Tpm_read_clock.get_t_reset_count b |> Int32.to_int in
  let restarts = S.Tpm_read_clock.get_t_restart_count b |> Int32.to_int in
  Ok { clock; time; resets; restarts }
