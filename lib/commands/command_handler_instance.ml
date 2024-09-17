module type H = sig
  module C : Command.S

  val this : C.t
end
