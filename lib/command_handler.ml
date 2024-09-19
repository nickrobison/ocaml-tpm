open Lwt.Syntax

let src = Logs.Src.create "command_handler"

module Log = (val Logs_lwt.src_log src : Logs_lwt.LOG)

module Make (D : Device.S) = struct
  type device = D.t
  type t = { device : D.t }

  let make device = { device }

  let run_command (type a) (module C : Command.S with type t = a) t c =
    let serialized = C.serialize c |> Result.get_ok in
    let* _ =
      Log.info (fun f -> f "Serialized to: %a" Cstruct.hexdump_pp serialized)
    in
    let* _res = D.execute t.device serialized in
    let* _ = Log.info (fun f -> f "Received response: ") in
    Lwt.return_ok "hello"
end
