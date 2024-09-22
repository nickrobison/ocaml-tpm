let make requested_bytes =
  let cmd = Get_random.create requested_bytes in
  Operation.make_operation (module Get_random) (module Get_random_response) cmd
