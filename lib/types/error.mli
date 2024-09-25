type t = [ `Bad_tag of Command_code.t | `Tpm_error of Error_code.t ]
[@@deriving show, sexp, eq]

val validate_command : Command_code.t -> Response_code.t -> t option
