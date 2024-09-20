module type S = sig
  type t [@@deriving show, sexp]

  val deserialize : Cstruct.t -> (t, Serialization.Serialization_error.t) result
end
