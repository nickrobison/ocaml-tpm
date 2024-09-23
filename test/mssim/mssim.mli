include Tpm2.Device.S

val make : ?host:string -> ?port:int -> ?system_port:int -> unit -> t
val reset : t -> (unit, string) result Lwt.t
