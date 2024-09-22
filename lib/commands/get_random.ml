open Sexplib.Std
module S = Serialization

type config = int
type t = { bytes_requested : int } [@@deriving sexp]

let code = Command_code.GetRandom
let create bytes_requested = { bytes_requested }

let make_payload t =
  let buf = Cstruct.create S.Tpm_get_random.sizeof_t in
  S.Tpm_get_random.set_t_bytes_requested buf t.bytes_requested;
  buf

let serialize t =
  let payload = make_payload t in
  let header =
    S.Command_header.make_header
      (Command_code.t_to_int code)
      S.Tpm_get_random.sizeof_t
  in
  Ok (Cstruct.append header payload)
