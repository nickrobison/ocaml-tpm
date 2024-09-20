[%%cenum
type t =
  | CapabilityAlgs
  | CapabilityHandles
  | CapabilityCommands
  | CapabilityPPCommands
  | CapabilityAuditCommands
  | CapabilityPCRs
  | CapabilityTPMProperties
  | CapabilityPCRProperties
  | CapabilityECCurves
  | CapabilityAuthPolicies
[@@uint32_t]]

let t_of_capability (cap : Capability.t) =
  match cap with
  | Algorithms _ -> CapabilityAlgs
  | Handles -> CapabilityHandles
  | Tpm_properties _ -> CapabilityTPMProperties
