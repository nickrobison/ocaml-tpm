type error = [ `Disconnected ]

let pp_error ppf = function
  | `Disconnected -> Fmt.string ppf "The device has been disconnected"

type write_error = [ error | `Truncated_write ]

let pp_write_error ppf = function
  | #error as e -> pp_error ppf e
  | `Truncated_write ->
      Fmt.string ppf "Not all requested bytes were written correctly"

module type S = sig
  type nonrec error = private [> error ]

  val pp_error : error Fmt.t

  type nonrec write_error = private [> write_error ]

  val pp_write_error : write_error Fmt.t

  type t

  val name : string
  val initialize : t -> (unit, string) result Lwt.t
  val read : t -> Cstruct.t -> (unit, error) result Lwt.t
  val write : t -> Cstruct.t -> (unit, error) result Lwt.t
  val shutdown : t -> unit Lwt.t
  val execute : t -> Cstruct.t -> (Cstruct.t, string) result Lwt.t
end
