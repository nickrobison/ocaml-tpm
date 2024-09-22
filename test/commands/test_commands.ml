open Alcotest_lwt

let () = Lwt_main.run @@ run "Command Tests" [ Test_random.v ]
