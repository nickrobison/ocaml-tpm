[%%cstruct
type t = { size : uint16_t; hash_alg : uint16_t; digest : uint8_t [@len 8] }
[@@big_endian]]
(** [t] Represents the returned random data using the specified hash algorithm. This is a combination of TPM2B_DIGEST and TPMT_HA for the maximum sized hash*)
