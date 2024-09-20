let make =
  let cmd =
    Get_capabilities.create
      (Capability.Tpm_properties Tpm_property.Manufacturer)
  in
  Operation.make_operation
    (module Get_capabilities)
    (module Get_capability_response)
    cmd
