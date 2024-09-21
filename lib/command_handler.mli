module Make (D : Device.S) :
  Command_handler_intf.S
    with type device = D.t
     and type error = [ `IO_error of D.error | `Msg of string ]
