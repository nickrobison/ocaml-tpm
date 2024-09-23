type t = { clock : int64; time : int64; resets : int; restarts : int }

include Response.S with type t := t
