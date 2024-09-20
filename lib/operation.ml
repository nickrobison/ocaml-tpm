module type S = sig
  module Command : Command.S
  module Response : Response.S

  val this : Command.t
end

let make_operation (type c r) (module C : Command.S with type t = c)
    (module R : Response.S with type t = r) cmd =
  (module struct
    module Command = C
    module Response = R

    let this = cmd
  end : S
    with type Response.t = r)
