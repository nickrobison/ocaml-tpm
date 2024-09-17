module type S = sig
  type t

  val name : string
  val execute : string -> string Lwt.t
end
