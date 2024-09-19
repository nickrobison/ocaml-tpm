[%%cstruct
type payload = {
  command : uint32_t;
  locality : uint8_t;
  payload_size : uint32_t;
}
[@@big_endian]]

[%%cstruct type response = { output_size : uint32_t } [@@big_endian]]
