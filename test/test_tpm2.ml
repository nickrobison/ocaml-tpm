let test_ok () = Alcotest.(check string) "same string" "hello" "hello"

let test_connect () =
  let made = Mssim.make "localhost" 2321 2322 in
  let _ = Lwt_main.run made in
  ()

let () =
  let open Alcotest in
  run "Tests"
    [
      ( "tests",
        [
          test_case "TestIt" `Quick test_ok;
          test_case "TestLWT" `Quick test_connect;
        ] );
    ]
