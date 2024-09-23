let instance =
  let cmd = Read_clock.create () in
  Operation.make_operation (module Read_clock) (module Clock) cmd
