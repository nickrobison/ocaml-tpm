type t = SHA1 | SHA256 | SHA512 [@@deriving show, sexp, eq]

include Algorithm_intf.S with type t := t

val digest_length : t -> int
