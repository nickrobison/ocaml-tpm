open Lwt.Syntax

let src = Logs.Src.create "mssim"

module Log = (val Logs.src_log src : Logs.LOG)

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
  let loop = Unix.inet_addr_loopback in
  let addr = Unix.ADDR_INET (loop, port) in
  Lwt_unix.connect fd addr

let handle_execute fd payload =
  print_endline
    Fmt.(str "Sending along payload of size %i" (Cstruct.length payload));
  let* _ = Lwt_cstruct.write fd payload in
  let resp = Cstruct.create 4 in
  let* _ = Lwt_cstruct.read fd resp in
  let resp_size = Tpm_command.get_response_output_size resp |> Int32.to_int in
  print_endline (Fmt.str "Got response from MSSIM: %a" Cstruct.hexdump_pp resp);
  print_endline (Fmt.str "Mssim payload size size: %i" resp_size);
  (*I don't know why we have to read this big struct, feel really wasteful and that I'm doing something wrong.*)
  let resp' = Cstruct.create 100 in
  let+ _ = Lwt_cstruct.read fd resp' in
  print_endline "Read again";
  print_endline (Fmt.str "What did we get? %a" Cstruct.hexdump_pp resp');
  let tag =
    Serialization.Tpm_response.get_t_tag resp'
    |> Serialization.Struct_tag.int_to_t |> Option.get
  in
  let cc = Serialization.Tpm_response.get_t_response_code resp' in
  let sz = Serialization.Tpm_response.get_t_response_size resp' in
  print_endline
    (Fmt.str "Got tag %i and code %a with size: %a"
       (Serialization.Struct_tag.t_to_int tag)
       Fmt.int32 cc Fmt.int32 sz);
  print_endline
    (Fmt.str "Stringified: %s"
       (Cstruct.to_string ~off:Serialization.Tpm_response.sizeof_t
          ~len:resp_size resp'));
  Ok "nope"

let send_command fd cmd =
  print_endline
    (Fmt.str "Executing command: %s" (Platform_command.t_to_string cmd));
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
  let* _ = send_command plat Platform_command.PowerOn in
  let* _ = send_command plat Platform_command.NVOn in
  send_command plat Platform_command.Reset

let shutdown t =
  let plat = t.platform in
  let+ res = send_command plat Platform_command.Stop in
  match res with Ok _ -> () | Error _e -> ()

let execute t payload =
  let tpm = t.tpm in
  (*MSSIM requires command 8, locality and payload size, then the payload*)
  let payload_size = Cstruct.length payload |> Int32.of_int in
  print_endline (Fmt.str "TPM command paload size: %a" Fmt.int32 payload_size);
  let body = Cstruct.create Tpm_command.sizeof_payload in
  Tpm_command.set_payload_command body
    (Platform_command.t_to_int Platform_command.SendCommand);
  Tpm_command.set_payload_locality body 0;
  Tpm_command.set_payload_payload_size body payload_size;
  handle_execute tpm (Cstruct.append body payload)
