module type S = sig
  type t
  type device

  val make : device -> t

  val run_command :
    (module Command.S with type t = 'a) ->
    t ->
    'a ->
    (string, string) result Lwt.t

  val run_operation :
    t ->
    (module Operation.S with type Response.t = 'a) ->
    ('a, string) result Lwt.t
end
