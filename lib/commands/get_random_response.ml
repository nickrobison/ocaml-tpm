open Sexplib.Std
module S = Serialization

let src = Logs.Src.create "get_random_response"

module Log = (val Logs.src_log src : Logs.LOG)

type t = { algorithm : int; random_bytes : string } [@@deriving sexp, show]

let deserialize b =
  Log.debug (fun f -> f "Response Payload: %a" Cstruct.hexdump_pp b);
  let size = S.Tpm_random.get_t_size b in
  let tpm_alg = S.Tpm_random.get_t_hash_alg b in
  Log.debug (fun f -> f "Received %i of random using %i" size tpm_alg);
  (* TODO: We need to read out only the maximum algorithm size.*)
  let random_bytes = S.Tpm_random.copy_t_digest b in
  Ok { algorithm = tpm_alg; random_bytes = String.sub random_bytes 0 size }
