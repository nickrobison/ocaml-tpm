module type S = sig
  type t

  val algorithm_id : t -> int
  val name : t -> string
  val of_int : int -> t option
end
