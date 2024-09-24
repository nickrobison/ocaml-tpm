[%%cenum
type t = SHA1 [@id 0x0004] | SHA256 [@id 0x000b] | SHA512 [@id 0x000d]
[@@uint16_t] [@@sexp]]

let name = t_to_string
let of_int = int_to_t
let pp ppf t = Fmt.string ppf (name t)
let show = name
let algorithm_id = t_to_int
let digest_length = function SHA1 -> 20 | SHA256 -> 32 | SHA512 -> 64
let equal l r = t_to_int l == t_to_int r
