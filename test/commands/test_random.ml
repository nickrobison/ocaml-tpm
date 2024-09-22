let simple_test _switch () = Lwt.return_unit

let v =
  let open Alcotest_lwt in
  ("Random", [ test_case "Get Random" `Quick simple_test ])
