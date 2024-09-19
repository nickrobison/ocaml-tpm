module type S = sig
  type t
  type device

  val make : device -> t

  val run_command :
    (module Command.S with type t = 'a) ->
    t ->
    'a ->
    (string, string) result Lwt.t
end
