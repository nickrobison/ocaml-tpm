[%%cenum
type t = RSA [@id 1] | TDES [@id 3] | SHA1 [@id 4] [@@uint16_t] [@@sexp]]
[@@deriving show]
