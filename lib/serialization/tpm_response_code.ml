[%%cenum type t = TpmNotInitialized [@id 0x100] [@@uint32_t]]

let t_to_error = function TpmNotInitialized -> Error.NotInitialized
