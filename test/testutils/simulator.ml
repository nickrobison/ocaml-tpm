open Lwt.Syntax

let src = Logs.Src.create "simulator"

module Log = (val Logs.src_log src : Logs.LOG)

type test = Mssim.t -> unit Lwt.t

module CH = Tpm2.Command_handler.Make (Mssim)

let initialized = ref false
let sim = Mssim.make ~host:"localhost" ~port:2321 ~system_port:2322 ()
let debug msg = Log.debug (fun f -> f "%s" msg)

let reset sim =
  (*Restart sequence is Shutdown(Clear) -> Reset() -> Startup(Clear)*)
  let shutdown =
    Shutdown.create { clear = true } |> Shutdown.serialize |> Result.get_ok
  in
  let* _ = Mssim.execute sim shutdown in
  let startup =
    Startup.create { clear = true } |> Startup.serialize |> Result.get_ok
  in
  Mssim.execute sim startup

let start_or_reset sim =
  match !initialized with
  | true ->
      let+ _ = reset sim in
      ()
  | false ->
      let+ _ = Mssim.initialize sim in
      initialized := true

let with_simulator test _switch () =
  let ch = CH.make sim in
  debug "Doing init";
  let* _ = start_or_reset sim in
  debug "Initeded";
  debug "Do startup";
  let* _ =
    CH.run_command (module Startup) ch (Startup.create { clear = true })
  in
  debug "Started up";
  test sim
