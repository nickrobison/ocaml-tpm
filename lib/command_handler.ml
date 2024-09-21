module S = Serialization

let src = Logs.Src.create "command_handler"

module Log = (val Logs_lwt.src_log src : Logs_lwt.LOG)

module Make (D : Device.S) = struct
  type device = D.t
  type t = { device : D.t }
  type error = [ `IO_error of D.error | `Msg of string ]

  let make device = { device }

  let run_command (type a) (module C : Command.S with type t = a) t c =
    let open Lwt.Syntax in
    print_endline "Running command";
    print_endline
      (Fmt.str "Sending command %s" (Command_code.t_to_string C.code));
    let serialized = C.serialize c |> Result.get_ok in
    let* _ =
      Log.err (fun f -> f "Serialized to: %a" Cstruct.hexdump_pp serialized)
    in
    let* _res = D.execute t.device serialized in
    let* _ = Log.info (fun f -> f "Received response: ") in
    Lwt.return_ok "hello"

  let run_operation (type r) t (module O : Operation.S with type Response.t = r)
      =
    print_endline "Running operation";
    let open Lwt_result.Syntax in
    let cmd = O.this in
    Fmt.(
      pf stdout "Executing operation command: %s\n"
        (Command_code.t_to_string O.Command.code));
    let ser = O.Command.serialize cmd |> Result.get_ok in
    Fmt.pf Fmt.stdout "Serialized to %a with size %i\n" Cstruct.hexdump_pp ser
      (Cstruct.length ser);
    let do_io () =
      let buffer = Cstruct.create 100 in
      let* _w_ok = D.write t.device ser in
      (* Read out the TPM response and then get the full payload*)
      let header_size = S.Tpm_response.sizeof_t in
      let r_header = Cstruct.create header_size in
      let* _r_ok = D.read t.device r_header in
      let rc = S.Tpm_response.get_t_response_code r_header in
      let ps = S.Tpm_response.get_t_response_size r_header |> Int32.to_int in
      Fmt.pf Fmt.stdout "Got response code %a with size %i\n" Fmt.int32 rc ps;
      (*Now, read out the entire response payload*)
      let+ _r_ok = D.read t.device buffer in
      (*Now, we need just the response body which is minus the header*)
      Cstruct.sub_copy buffer header_size (ps - header_size)
    in

    let* resp_buffer = Lwt_result.map_error (fun e -> `IO_error e) (do_io ()) in
    Fmt.(
      pf stdout "I'm supposed to have a buffer, and I have: %a with size %i\n"
        Cstruct.hexdump_pp resp_buffer
        (Cstruct.length resp_buffer));
    let+ res =
      Lwt.return
        (O.Response.deserialize resp_buffer
        |> Result.map_error (fun _e -> `Msg "Deser failed"))
    in
    res
end
