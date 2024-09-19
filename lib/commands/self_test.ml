open Sexplib.Std

type args = { full_test : bool }
type config = args
type t = bool [@@deriving sexp]

let code = Command_code.SelfTest
let create args = args.full_test
let serialize _t = Result.Ok (Cstruct.of_string "hello")
