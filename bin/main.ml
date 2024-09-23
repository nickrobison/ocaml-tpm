open Lwt_result.Syntax
open Lwt.Infix
open Tpm2
open Tpm2_unix
module CH = Command_handler.Make (Linux_device)

let get_random () =
  let device = Linux_device.make "/dev/tpmrm0" in
  let tpm = CH.make device in
  let op = Get_random_bytes.make 10 in
  let+ res = CH.run_operation tpm op in
  print_endline (Get_random_response.get_bytes res)

let () =
  let f =
    get_random () >>= fun r ->
    match r with Ok () -> Lwt.return_unit | Error _e -> Lwt.return_unit
  in
  Lwt_main.run f
