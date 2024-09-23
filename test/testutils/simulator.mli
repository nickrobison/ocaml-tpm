type test = Mssim.t -> unit Lwt.t

val with_simulator : test -> Lwt_switch.t -> unit -> unit Lwt.t
