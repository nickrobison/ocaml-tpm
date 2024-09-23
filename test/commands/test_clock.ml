open Lwt.Syntax
module T = Testutils
module CH = Tpm2.Command_handler.Make (Mssim)

let get_clock sim =
  let ch = CH.make sim in
  let+ resp = CH.run_operation ch Tpm2.Read_clock_op.instance in
  let resp' = resp |> Result.get_ok in
  Alcotest.(check int) "Should have 0 restarts" 0 resp'.restarts;
  Alcotest.(check int) "Should have 0 resets" 0 resp'.resets;
  Alcotest.(check bool)
    "Should have time greater than 0" true
    Int64.(resp'.time > zero);
  Alcotest.(check bool)
    "Should have clock greater than 0" true
    Int64.(resp'.clock > zero)

let v =
  let open Alcotest_lwt in
  ( "Clock",
    [ test_case "Read Clock" `Quick (T.Simulator.with_simulator get_clock) ] )
