open Lwt.Syntax

let src = Logs.Src.create "linux_device"

module Log = (val Logs.src_log src : Logs.LOG)

type error = [ Tpm2.Device.error | `Msg of string ]

let pp_error ppf = function
  | #Tpm2.Device.error as e -> Tpm2.Device.pp_error ppf e
  | `Msg s -> Fmt.string ppf s

type write_error = [ Tpm2.Device.write_error | `Msg of string ]

let pp_write_error ppf = function
  | #Tpm2.Device.write_error as e -> Tpm2.Device.pp_write_error ppf e
  | `Msg s -> Fmt.string ppf s

type t = { device : Lwt_unix.file_descr }

let name = "linux"
let initialize _t = Lwt.return_ok ()

let make device =
  let device =
    Unix.(openfile device [ O_RDWR ] 0)
    |> Lwt_unix.of_unix_file_descr ~blocking:false
  in
  { device }

let shutdown t = Lwt_unix.close t.device
let execute _t _payload = Lwt.fail (Invalid_argument "Not implemented")

let read t buffer =
  let+ _r = Lwt_cstruct.read t.device buffer in
  Ok ()

let write t buffer =
  let+ _r = Lwt_cstruct.write t.device buffer in
  Ok ()
