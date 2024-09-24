open Sexplib.Std
module S = Serialization

let src = Logs.Src.create "read_pcr"

module Log = (val Logs.src_log src : Logs.LOG)

type config = { hash : Hash.t; pcrs : Pcr.Id.t list }
type t = { hash : Hash.t; pcrs : Pcr.Id.t list } [@@deriving sexp, show]

let code = Command_code.PcrRead
let create (config : config) = { hash = config.hash; pcrs = config.pcrs }

let pcr_to_bitmap bitmap pcr =
  let id = Pcr.Id.to_int pcr in
  Fmt.pf Fmt.stdout "Id: %i\n" id;
  let octet = id / 8 in
  Fmt.(pf stdout "Octet: %i\n" octet);
  let to_extend = octet - Bytes.length bitmap in
  let b' = if to_extend > 0 then Bytes.extend bitmap 0 to_extend else bitmap in
  let bit = id mod 8 in
  Fmt.(pf stdout "Bit: %i and value %i\n" bit (1 lsl bit));
  let old = Bytes.get_uint8 b' octet in
  let updated = old + (1 lsl bit) in
  Bytes.set_uint8 b' octet updated;
  b'

let make_payload t =
  Log.debug (fun f ->
      f "Reading PCR: [%a] with hash: %a"
        (Fmt.list ~sep:Fmt.comma Pcr.Id.pp)
        t.pcrs Hash.pp t.hash);
  (* Temporarily set min size to 3, which should be sufficient for now.*)
  let b = Bytes.make 3 '0' in
  let bitmap = List.fold_left pcr_to_bitmap b t.pcrs in
  let bitmap_sz = Bytes.length bitmap in
  Log.debug (fun f ->
      f "Serialized bitmap: %s with size: %i" (Bytes.to_string bitmap) bitmap_sz);
  let bitmap_sz = Bytes.length bitmap in
  (* Store the data in a TPMS_PCR_SELECTION struct*)
  let bm_struct = Cstruct.create 24 in
  Cstruct.blit_from_bytes bitmap 0 bm_struct 0 bitmap_sz;
  let tpms = Cstruct.create S.Tpm_pcr_selection.sizeof_t in
  let h_id = Hash.algorithm_id t.hash in
  Log.debug (fun f -> f "With hashId: %i" h_id);
  S.Tpm_pcr_selection.set_t_hash tpms (Hash.algorithm_id t.hash);
  S.Tpm_pcr_selection.set_t_size tpms bitmap_sz;
  (* Manually set selection here, because Cstruct_ppx doesn't allow us to copy in a custom struct length*)
  Cstruct.blit_from_bytes bitmap 0 tpms 3 bitmap_sz;
  (* Create the TPML_PCR_SELECTION payload, which is a uint32_t followed by the TPMS structend*)
  let payload = Cstruct.create (S.Tpm_pcr_selection.sizeof_t + 4) in
  Cstruct.BE.set_uint32 payload 0 (Int32.of_int (List.length t.pcrs));
  Cstruct.append payload tpms

let serialize t =
  let payload = make_payload t in
  let header =
    S.Command_header.make_header
      (Command_code.t_to_int code)
      (Cstruct.length payload)
  in
  Ok (Cstruct.append header payload)
