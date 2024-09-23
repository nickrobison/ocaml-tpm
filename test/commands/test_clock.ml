open Lwt.Syntax
module T = Testutils
module CH = Tpm2.Command_handler.Make (Mssim)

let get_clock sim =
  let ch = CH.make sim in
  let+ resp = CH.run_operation ch Tpm2.Read_clock_op.instance in
  let resp' = resp |> Result.get_ok in
  Alcotest.(check int64)
    "Should have len 4" Int64.zero
    (Read_clock_response.get_time resp')

let v =
  let open Alcotest_lwt in
  ( "Clock",
    [ test_case "Read Clock" `Quick (T.Simulator.with_simulator get_clock) ] )
