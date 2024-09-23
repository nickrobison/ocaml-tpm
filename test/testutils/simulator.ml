open Lwt.Syntax

let src = Logs.Src.create "simulator"

module Log = (val Logs.src_log src : Logs.LOG)

type test = Mssim.t -> unit Lwt.t

module CH = Tpm2.Command_handler.Make (Mssim)

let sim = Mssim.make ~host:"localhost" ~port:2321 ~system_port:2322 ()
let debug msg = Log.debug (fun f -> f "%s" msg)

let with_simulator test _switch () =
  let ch = CH.make sim in
  debug "Doing init";
  let* _ = Mssim.initialize sim in
  debug "Initeded";
  debug "Do startup";
  let* _ =
    CH.run_command (module Startup) ch (Startup.create { clear = true })
  in
  debug "Started up";
  test sim
