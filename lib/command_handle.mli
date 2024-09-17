type t

val run_command : (module Command.S with type t = 'a) -> t -> 'a -> string
