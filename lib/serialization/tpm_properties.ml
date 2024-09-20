[%%cenum
type t =
  | PropetyFamilyIndicator [@id 0x100]
  | PropertyManufacturer [@id 0x105]
  | PropertyVendorString1 [@id 0x106]
[@@uint32_t]]

let t_of_property (prop : Tpm_property.t) =
  match prop with
  | Manufacturer -> PropertyManufacturer
  | VendorString1 -> PropertyVendorString1
