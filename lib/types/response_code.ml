[%%cenum
type t = ResponseSuccess | ResponseBadTag [@id 0x1e] [@@uint32_t] [@@sexp]]

let pp ppf = function
  | ResponseSuccess -> Fmt.string ppf "Success"
  | ResponseBadTag -> Fmt.string ppf "BadTag"

let show t = Fmt.str "%a" pp t
let equal l r = t_to_int l == t_to_int r
