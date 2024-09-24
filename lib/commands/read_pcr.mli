type config = { hash : Hash.t; pcrs : Pcr.Id.t list }

include Command.S with type config := config
