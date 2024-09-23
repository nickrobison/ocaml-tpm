[%%cstruct
type t = {
  time : uint64_t;
  clock : uint64_t;
  reset_count : uint32_t;
  restart_count : uint32_t;
  safe : uint8_t;
}
[@@big_endian]]
(** [t] Represents the response returned by TPM2_ReadClock. It combines both TPMS_TIME_INFO and TPMS_CLOCK_INFO*)
