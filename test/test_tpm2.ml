module CH = Tpm2.Command_handler.Make (Mssim)

let _test_ok () = Alcotest.(check string) "same string" "hello" "hello"

let _test_connect () =
  let made = Mssim.make ~host:"localhost" ~port:2321 ~system_port:2322 () in
  let _ = Lwt_main.run (Mssim.initialize made) in
  ()

let get_hashes () =
  print_endline "Getting?";
  let made = Mssim.make ~host:"localhost" ~port:2321 ~system_port:2322 () in
  let handler = CH.make made in
  let result =
    CH.run_command
      (module Get_capabilities)
      handler
      (Get_capabilities.create (Capability.Algorithms Algorithm_id.RSA))
  in
  let _ = Lwt_main.run result in
  ()

let () =
  let open Alcotest in
  run "Tests"
    [
      ( "tests",
        [
          (*
          test_case "TestIt" `Quick test_ok;
          test_case "TestLWT" `Quick test_connect;
            *)
          test_case "Hashes" `Quick get_hashes;
        ] );
    ]
