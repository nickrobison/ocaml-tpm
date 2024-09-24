open Sexplib.Std

module Id = struct
  type t = int [@@deriving show, sexp]

  let of_int i = i
  let to_int t = t
end

type pcr_value = Hash.t * string [@@deriving show, sexp]
type t = { id : Id.t; values : pcr_value list } [@@deriving show, sexp]

let make id values = { id; values }
let id t = t.id

let value t hash =
  List.find_map
    (fun (h, v) -> if Hash.equal hash h then Some v else None)
    t.values

let values t = t.values
