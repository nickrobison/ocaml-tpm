type t = string

let name = "linux"
let execute _ _ = Lwt.return_ok "hello"
let initialize _ = Lwt.return_ok ()
let shutdown _ = Lwt.return_unit
