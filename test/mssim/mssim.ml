open Lwt.Syntax

type t = { platform : Lwt_unix.file_descr }

let name = "mssim"

let make_socket _host port =
  let addr = UnixLabels.inet_addr_loopback in
  let s_addr = Lwt_unix.ADDR_INET (addr, port) in
  let sock = Lwt_unix.socket Lwt_unix.PF_INET Lwt_unix.SOCK_STREAM 0 in
  let+ _ = Lwt_unix.connect sock s_addr in
  sock

let startup_platform io =
  print_endline "Doing startup";
  let cmd = Cstruct.create Platform_command.sizeof_payload in
  let _ =
    Platform_command.set_payload_command cmd
      (Platform_command.t_to_int Platform_command.PowerOn)
  in
  let* _ = Lwt_cstruct.write io cmd in
  let resp = Cstruct.create 4 in
  let* _ = Lwt_cstruct.read io resp in
  let res = Cstruct.BE.get_uint32 resp 0 in
  print_endline "Written!";
  print_endline (Int32.to_string res);
  Lwt.return_unit

let make host (_port : int) system_port =
  let* system_sock = make_socket host system_port in
  let t = { platform = system_sock } in
  let+ _ = startup_platform t.platform in
  t

let execute _ = Lwt.return "sorry"
