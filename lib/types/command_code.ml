[%%cenum
type t =
  | SelfTest [@id 0x00000143]
  | Startup [@id 0x00000144]
  | Shutdown [@id 0x00000145]
  | GetCapability [@id 0x0000017A]
  | GetRandom [@id 0x0000017B]
  | ReadClock [@id 0x00000181]
  | PcrRead [@id 0x0000017E]
[@@uint32_t] [@@sexp]]
[@@deriving show]

let pp ppf t = Fmt.string ppf (t_to_string t)
let show = t_to_string
let equal l r = t_to_int l == t_to_int r
