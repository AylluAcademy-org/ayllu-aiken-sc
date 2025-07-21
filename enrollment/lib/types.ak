use aiken/crypto.{VerificationKeyHash}
use cardano/transaction.{OutputReference}

/// Parameters for the registration validator.
/// Specifies the public key hash of the registrar authorized to approve enrollments.
///
/// Parámetros para el validador de registro.
/// Especifica el hash de clave pública del registrador autorizado para aprobar inscripciones.
pub type RegParam {
  registrar_pkh: VerificationKeyHash,
}

/// Datum associated with a registration UTxO.
/// Contains the student's public key hash for identity verification.
///
/// Datum asociado a un UTxO de registro.
/// Contiene el hash de clave pública del estudiante para verificación de identidad.
pub type RegistrationDatum {
  student_pkh: VerificationKeyHash,
}

/// Redeemer used during the consumption of the registration UTxO.
/// Defines the action to perform, the student’s identity, and the UTxO to spend.
///
/// Redeemer utilizado durante el gasto del UTxO de registro.
/// Define la acción a realizar, la identidad del estudiante y el UTxO a gastar.
pub type RegistrationRedeemer {
  action: Action,
  student: VerificationKeyHash,
  unique_utxo: OutputReference,
}

/// Parameters for the mint and delivery validators.
/// Includes the registrar who signs, the token name, the UTxO used as anchor,
/// and the public key hash of the student receiving the token.
///
/// Parámetros para los validadores de mint y entrega.
/// Incluye el registrador que firma, el nombre del token, el UTxO usado como ancla,
/// y el hash de clave pública del estudiante que recibirá el token.
pub type MintParam {
  registrar_pkh: ByteArray,
  token_name: ByteArray,
  utxo_ref: OutputReference,
  student_pkh: VerificationKeyHash,
}

/// Redeemer for minting logic. Only used as a unit value to authorize minting.
///
/// Redeemer para la lógica de acuñación. Solo se usa como valor unitario para autorizar la acuñación.
pub type MintRedeemer {
  MintUnit
}

/// Actions allowed during registration.
///
/// Acciones permitidas durante el registro.
pub type Action {
  Register
  /// Register a student / Registrar a un estudiante
  Cancel
}

/// Cancel registration / Cancelar el registro
/// Tuition cost in lovelace (1 ADA = 1_000_000 lovelace).
/// Used as the base registration fee.
///
/// Costo de matrícula en lovelace (1 ADA = 1_000_000 lovelace).
/// Usado como la tarifa base de inscripción.
/// Para POC el monto es de 0 ADA, pero se define un monto simbólico para pruebas.
///pub const tuition_amount: Int = 13_000_000
/// Token name for the enrollment NFT issued upon successful registration.
///
/// Nombre del token para el NFT de inscripción emitido tras una matrícula exitosa.
pub const enrollment_token_name: ByteArray = "ENROLLED"

/// Minimum ADA required in a UTxO to comply with Cardano ledger rules.
///
/// ADA mínima requerida en un UTxO para cumplir con las reglas del ledger de Cardano.
pub const min_ada: Int = 2_000_000

/// Total value expected in the registration UTxO: tuition + min ADA.
///
/// Valor total esperado en el UTxO de registro: matrícula + ADA mínima.
///pub const total_required: Int = tuition_amount + min_ada
pub const total_required: Int = min_ada
