module type S = sig
  type t

  val name : string
  val initialize : t -> (unit, string) result Lwt.t
  val shutdown : t -> unit Lwt.t
  val execute : t -> Cstruct.t -> (Cstruct.t, string) result Lwt.t
end
