type t = unit

let run_command (type a) (module C : Command.S with type t = a) _t _c = "hello"
