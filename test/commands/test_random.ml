open Lwt.Syntax
module T = Testutils
module CH = Tpm2.Command_handler.Make (Mssim)

let simple_test _switch () = Lwt.return_unit

let get_random sim =
  let ch = CH.make sim in
  let+ _resp = CH.run_operation ch (Tpm2.Get_random_bytes.make 4) in
  Alcotest.(check int) "Should have len 4" 4 (String.length "hello")

let v =
  let open Alcotest_lwt in
  ( "Random",
    [
      test_case "Get Random" `Quick simple_test;
      test_case "Get 4 random" `Quick (T.Simulator.with_simulator get_random);
    ] )
