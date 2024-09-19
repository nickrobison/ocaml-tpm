[%%cenum type t = CapabilityAlgs | CapabilityHandles [@@uint32_t]]

let t_of_capability (cap : Capability.t) =
  match cap with Algorithms _ -> CapabilityAlgs | Handles -> CapabilityHandles
