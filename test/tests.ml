open Alcotest_lwt

let () =
  Logs.set_level (Some Debug);
  Logs.set_reporter (Logs_fmt.reporter ())

let () = Lwt_main.run @@ run "Unit Tests" [ Test_errors.v ]
