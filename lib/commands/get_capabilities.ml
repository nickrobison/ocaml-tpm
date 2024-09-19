module S = Serialization

type config = Capability.t
type t = { capability : Capability.t } [@@deriving sexp]

let code = Command_code.GetCapability
let create args = { capability = args }

let make_payload (cap : Capability.t) =
  let b = Cstruct.create S.Tpm_get_capability.sizeof_c in
  match cap with
  | Algorithms _id ->
      let prop = S.Tpm_algorithm_id.t_to_int S.Tpm_algorithm_id.RSA in
      let cap = S.Tpm_capability.t_to_int S.Tpm_capability.CapabilityAlgs in
      let _ = S.Tpm_get_capability.set_c_capability b cap in
      let _ =
        Serialization.Tpm_get_capability.set_c_property b (Int32.of_int prop)
      in
      let _ =
        Serialization.Tpm_get_capability.set_c_property_count b Int32.max_int
      in
      b
  | Handles -> failwith "Not supported"

let serialize t =
  let payload = make_payload t.capability in
  let header = Cstruct.create S.Command_header.sizeof_t in
  let cmd_size = S.Command_header.sizeof_t + S.Tpm_get_capability.sizeof_c in
  let _ = S.Command_header.set_t_command_size header (Int32.of_int cmd_size) in
  let _ =
    S.Command_header.set_t_command_code header (Command_code.t_to_int code)
  in
  let _ =
    S.Command_header.set_t_tag header
      (S.Struct_tag.t_to_int S.Struct_tag.NoSessions)
  in
  let ppp = Cstruct.append header payload in
  Ok ppp
