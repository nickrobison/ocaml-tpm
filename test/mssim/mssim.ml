open Lwt.Syntax

type t = {
  host : string;
  port : int;
  system_port : int;
  platform : Lwt_unix.file_descr;
  tpm : Lwt_unix.file_descr;
}

let name = "mssim"

let make_socket () =
  let sock = Lwt_unix.socket Lwt_unix.PF_INET Lwt_unix.SOCK_STREAM 0 in
  sock

let connect fd _host port =
  let loop = Unix.inet6_addr_loopback in
  let addr = Unix.ADDR_INET (loop, port) in
  Lwt_unix.connect fd addr

let send_command fd cmd =
  let c = Cstruct.create Platform_command.sizeof_payload in
  let _ =
    Platform_command.set_payload_command c (Platform_command.t_to_int cmd)
  in
  let* _ = Lwt_cstruct.write fd c in
  let resp = Cstruct.create 4 in
  let* _ = Lwt_cstruct.read fd resp in
  if Cstruct.BE.get_uint32 resp 0 <> Int32.zero then
    Lwt.return_error "Invalid response code"
  else Lwt.return_ok ()

let make ?(host = "localhost") ?(port = 2321) ?(system_port = 2322) () =
  let sock = make_socket () in
  let system_sock = make_socket () in
  let t = { host; port; system_port; platform = system_sock; tpm = sock } in
  t

let initialize t =
  let* _ = connect t.platform t.host t.system_port in
  let* _ = connect t.tpm t.host t.port in
  let plat = t.platform in
  send_command plat Platform_command.PowerOn

let shutdown t =
  let plat = t.platform in
  let+ res = send_command plat Platform_command.Stop in
  match res with Ok _ -> () | Error _e -> ()

let execute _ = Lwt.return "sorry"
