type t = string

let name = "linux"
let execute s = Lwt.return s
let initialize _ = Lwt.return_ok ()
let shutdown _ = Lwt.return_unit
