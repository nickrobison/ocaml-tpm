let make hash pcrs =
  let cmd = Read_pcr.create { hash; pcrs } in
  Operation.make_operation (module Read_pcr) (module Pcr_values) cmd
