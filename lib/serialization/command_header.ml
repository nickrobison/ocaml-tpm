[%%cstruct
type t = { tag : uint16_t; command_size : uint32_t; command_code : uint32_t }
[@@big_endian]]

let make_header code payload_size =
  let header = Cstruct.create sizeof_t in
  let cmd_size = sizeof_t + payload_size in
  set_t_command_code header code;
  set_t_tag header (Struct_tag.t_to_int Struct_tag.NoSessions);
  set_t_command_size header (Int32.of_int cmd_size);
  header
