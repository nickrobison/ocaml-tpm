[%%cstruct
type t = { hash : uint16_t; size : uint8_t; selection : uint8_t [@len 24] }
[@@big_endian]]
(** [t] represents TPMS_PCR_SELECTION*)
