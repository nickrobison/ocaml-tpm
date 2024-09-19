[%%cstruct
type c = {
  capability : uint32_t;
  property : uint32_t;
  property_count : uint32_t;
}
[@@big_endian]]

[%%cstruct
type r = { more_data : uint16_t; capability_data : uint8_t [@len 4] }
[@@big_endian]]
