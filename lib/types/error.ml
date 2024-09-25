type t = [ `Bad_tag of Command_code.t | `Tpm_error of Error_code.t ]
[@@deriving show, sexp, eq]

let validate_command c (r_code : Response_code.t) =
  match r_code with
  | ResponseSuccess -> None
  | ResponseBadTag -> Some (`Bad_tag c)
