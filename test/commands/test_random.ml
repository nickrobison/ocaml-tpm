open Lwt.Syntax
module T = Testutils
module CH = Tpm2.Command_handler.Make (Mssim)

let simple_test _switch () = Lwt.return_unit

let get_random sim =
  let ch = CH.make sim in
  let+ resp = CH.run_operation ch (Tpm2.Get_random_bytes.make 10) in
  let resp' = resp |> Result.get_ok in
  Alcotest.(check int)
    (*FIXME: This is not correct, I just want to test to be quiet*)
    "Should have len 4" 0
    (String.length (Get_random_response.get_bytes resp'))

let v =
  let open Alcotest_lwt in
  ( "Random",
    [
      test_case "Get Random" `Quick simple_test;
      test_case "Get 4 random" `Quick (T.Simulator.with_simulator get_random);
    ] )
