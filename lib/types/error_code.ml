[%%cenum
type t =
  | ErrorInitialize
  | ErrorFailure
  | ErrorSequence [@id 0x03]
  | ErrorDisabled [@id 0x20]
  | ErrorExclusive
  | ErrorAuthType [@id 0x24]
  | ErrorAuthMissing
  | ErrorPolicy
  | ErrorPCR
  | ErrorPCRChanged
  | ErrorUpgrade [@id 0x2d]
  | ErrorTooManyContexts
  | ErrorAuthUnavailable
  | ErrorReboot [@id 0x30]
  | ErrorUnbalanced
  | ErrorCommandSize [@id 0x42]
  | ErrorCommandCode
  | ErrorAuthSize
  | ErrorAuthContext
  | ErrorNVRange
  | ErrorNVSize
  | ErrorNVLocked
  | ErrorNVAuthorization
  | ErrorNVUninitialized
  | ErrorNVSpace
  | ErrorNVDefined
  | ErrorBadContext [@id 0x50]
  | ErrorCpHash
  | ErrorParent
  | ErrorNeedsTest
  | ErrorNoResult
  | ErrorSensitive
  | ErrorAsymmetric [@id 0x81]
  | ErrorAttributes
  | ErrorHash
  | ErrorValue
  | ErrorHierarchy
  | ErrorKeySize [@id 0x87]
  | ErrorMGF
  | ErrorMode
  | ErrorType
  | ErrorHandle
  | ErrorKDF
  | ErrorRange
  | ErrorAuthFail
  | ErrorNonce
  | ErrorPP
  | ErrorScheme [@id 0x92]
  | ErrorSize [@id 0x95]
  | ErrorSymmetric
  | ErrorTag
  | ErrorSelector
  | ErrorInsufficient [@id 0x9a]
  | ErrorSignature
  | ErrorKey
  | ErrorPolicyFail
  | ErrorIntegrity [@id 0x9f]
  | ErrorTicket
  | ErrorReservedBits
  | ErrorBadAuth
  | ErrorExpired
  | ErrorPolicyCC
  | ErrorBinding
  | ErrorCurve
  | ErrorECCPoint
[@@uint8_t]]

let to_int = t_to_int
let of_int = int_to_t

let to_hex t =
  let i = t_to_int t in
  Fmt.str "0x%04x" i
