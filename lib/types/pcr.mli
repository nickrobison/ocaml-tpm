module Id : sig
  type t [@@deriving show, sexp]

  val of_int : int -> t
  val to_int : t -> int
end

type t [@@deriving sexp, show]
type pcr_value = Hash.t * string [@@deriving sexp, show]

val id : t -> Id.t
val value : t -> Hash.t -> string option
val values : t -> pcr_value list
val make : Id.t -> pcr_value list -> t
