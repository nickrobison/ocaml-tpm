open Sexplib.Std
module S = Serialization

let src = Logs.Src.create "pcr_read_response"

module Log = (val Logs.src_log src : Logs.LOG)

type t = Pcr.t list [@@deriving show, sexp]

let deserialize b =
  Log.debug (fun f -> f "Response Payload: %a" Cstruct.hexdump_pp b);
  let update_count = S.Tpm_pcr_response.get_t_pcr_update_counter b in
  let pcr_selection = Cstruct.create S.Tpm_pcr_selection.sizeof_t in
  Cstruct.blit b 4 pcr_selection 0 (Cstruct.length pcr_selection);
  let count = S.Tpm_pcr_selection.get_t_size pcr_selection in
  let hash = S.Tpm_pcr_selection.get_t_hash pcr_selection |> Hash.of_int in
  Log.debug (fun f ->
      f "Recieved %i PCR values with hash: %a and update count of %a" count
        (Fmt.option Hash.pp) hash Fmt.int32 update_count);
  Ok []
