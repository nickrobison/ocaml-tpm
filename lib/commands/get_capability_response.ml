open Sexplib.Std
module S = Serialization

type t = { capability : Capability.t; data : string } [@@deriving sexp, show]

let get_vendor t = t.data

let deserialize b =
  let sss = Cstruct.to_string b in
  print_endline
    ("I have resp: `" ^ sss ^ "` of length: " ^ string_of_int (Cstruct.length b));
  Result.ok
    {
      capability = Capability.Tpm_properties Tpm_property.Manufacturer;
      data = Cstruct.to_string b;
    }
