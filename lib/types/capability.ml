type t =
  | Algorithms of Algorithm_id.t
  | Handles
  | Tpm_properties of Tpm_property.t
[@@deriving sexp, show]
