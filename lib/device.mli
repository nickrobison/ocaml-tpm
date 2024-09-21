(** TPM Device signature *)

type error = [ `Disconnected ]
(** The type of error for TPM IO operations*)

val pp_error : error Fmt.t
(** [pp_error] pretty-print errors*)

type write_error = [ error | `Truncated_write ]
(** The type for write errors*)

val pp_write_error : write_error Fmt.t
(** [pp_write_error] pretty-print write errors*)

module type S = sig
  type nonrec error = private [> error ]
  (** The type for TPM IO errors*)

  val pp_error : error Fmt.t
  (**[pp_error] pretty-print errors*)

  type nonrec write_error = private [> write_error ]
  (** The type for write errors*)

  val pp_write_error : write_error Fmt.t
  (** [pp_write_error] pretty-print write errors*)

  type t
  (** The type of the TPM Device*)

  val name : string
  (** The name of the TPM Device*)

  val initialize : t -> (unit, string) result Lwt.t
  (** [initialize device] sets up the device and handles any protocol initialization in order to be ready to receive commands*)

  val read : t -> Cstruct.t -> (unit, error) result Lwt.t
  (**[read device buffer] reads data into [buffer].
     [Ok ()] means the buffers have been filled.  [Error _] indicates an I/O
     error has happened and some of the buffers may not be filled. *)

  val write : t -> Cstruct.t -> (unit, error) result Lwt.t
  (**[write device buffer] writes data from [buffer].
     [Ok ()] means the contents of the buffers have been written. [Error _]
     indicates a partial failure in which some of the writes may not
     have happened.
      *)

  val shutdown : t -> unit Lwt.t
  (** [shutdown device] Shutdown the device and release any resources*)

  val execute : t -> Cstruct.t -> (Cstruct.t, string) result Lwt.t
  (** [execute device command] is an old command that executes things*)
end
