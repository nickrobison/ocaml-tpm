let get_code ec = Error_code.to_hex ec

let test_codes () =
  Alcotest.(check string)
    "ErrorExclusive" "0x0021"
    (get_code Error_code.ErrorExclusive);
  Alcotest.(check string)
    "ErrorTooManyContexts" "0x002e"
    (get_code Error_code.ErrorTooManyContexts);
  Alcotest.(check string)
    "ErrorNVUninitialized" "0x004a"
    (get_code Error_code.ErrorNVUninitialized);
  Alcotest.(check string)
    "ErrorAsymmetric" "0x0081"
    (get_code Error_code.ErrorAsymmetric);
  Alcotest.(check string) "ErrorType" "0x008a" (get_code Error_code.ErrorType);
  Alcotest.(check string)
    "ErrorScheme" "0x0092"
    (get_code Error_code.ErrorScheme);
  Alcotest.(check string) "ErrorKey" "0x009c" (get_code Error_code.ErrorKey);
  Alcotest.(check string)
    "ErrorECCPoint" "0x00a7"
    (get_code Error_code.ErrorECCPoint)

let v =
  let open Alcotest_lwt in
  ("Errors", [ test_case_sync "Test error ID sequence" `Quick test_codes ])
