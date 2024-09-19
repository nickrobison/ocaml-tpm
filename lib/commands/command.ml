module type S = sig
  type t [@@deriving sexp]
  type config

  val code : Command_code.t
  val create : config -> t
  val serialize : t -> (Cstruct.t, Serialization.Serialization_error.t) result
end
