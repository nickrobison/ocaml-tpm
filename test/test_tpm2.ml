open Lwt.Syntax
module CH = Tpm2.Command_handler.Make (Mssim)

let _test_ok () = Alcotest.(check string) "same string" "hello" "hello"

let _test_connect () =
  let made = Mssim.make ~host:"localhost" ~port:2321 ~system_port:2322 () in
  let _ = Lwt_main.run (Mssim.initialize made) in
  ()

let get_hashes _switch () =
  print_endline "Made";
  let sim = Mssim.make ~host:"localhost" ~port:2321 ~system_port:2322 () in
  let ch = CH.make sim in
  print_endline "Doing init";
  let* _ = Mssim.initialize sim in
  print_endline "Initeded";
  print_endline "Do startup";
  let* _ =
    CH.run_command (module Startup) ch (Startup.create { clear = true })
  in
  print_endline "Started up";
  let+ _ =
    CH.run_command
      (module Get_capabilities)
      ch
      (Get_capabilities.create
         (Capability.Tpm_properties Tpm_property.Manufacturer))
  in
  ()

let () =
  let open Alcotest_lwt in
  Lwt_main.run
  @@ run "Tests"
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
