[%%cstruct
type d = { size : uint16_t; buffer : uint8_t [@len 64] } [@@big_endian]]
(** [d] corresponds to TPM2B_Digest, with the assumpation that TPMU_HASH = 64*)

[%%cstruct type t = { count : uint32_t } [@@big_endian]]
