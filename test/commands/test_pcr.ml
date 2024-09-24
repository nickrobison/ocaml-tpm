open Lwt.Syntax
module T = Testutils
module CH = Tpm2.Command_handler.Make (Mssim)

let read_pcrs sim =
  let ch = CH.make sim in
  let pcrs = [ Pcr.Id.of_int 1; Pcr.Id.of_int 2 ] in
  let op = Tpm2.Pcr_read.make Hash.SHA1 pcrs in
  let+ resp = CH.run_operation ch op in
  let resp' = resp |> Result.get_ok in
  Alcotest.(check int) "Should have 2 PCRs" 2 (List.length resp')

let v =
  let open Alcotest_lwt in
  ( "PCR",
    [
      test_case "Read PCR Values" `Quick (T.Simulator.with_simulator read_pcrs);
    ] )
