// @validator: Mint

use aiken/collection/list
use cardano/assets.{flatten}
use cardano/transaction.{Transaction, find_input}
use types.{MintParam}

/// ===========================================
/// MINT VALIDATOR
/// ===========================================
///
/// Ensures that the minting of the enrollment token is authorized:
/// - The registrar signed the transaction.
/// - The specified UTxO is consumed.
/// - The correct token is minted.
///
/// Validador que asegura que la acuñación del token de inscripción esté autorizada:
/// - El registrador firmó la transacción.
/// - Se consume el UTxO especificado.
/// - Se acuña correctamente el token esperado.
///
validator mint_validator(param: MintParam) {
  mint(_redeemer: Data, _policy_id: ByteArray, tx: Transaction) {
    let Transaction { extra_signatories, mint, inputs, .. } = tx

    // --- Registrar must have signed the transaction
    // --- El registrador debe haber firmado la transacción
    expect list.has(extra_signatories, param.registrar_pkh)

    // --- Verify the specific UTxO was consumed (proof of enrollment)
    // --- Verifica que se consumió el UTxO específico (prueba de inscripción)
    let utxo_found = find_input(inputs, param.utxo_ref) != None
    expect utxo_found

    // --- Ensure only one token is minted, with the expected name and quantity
    // --- Asegura que se acuñó solo un token, con el nombre y cantidad esperados
    expect [(_pid, name, quantity)] = flatten(mint)
    expect name == param.token_name
    expect quantity == 1

    True
  }

  // --- Fallback for non-mint contexts
  // --- Fallback para contextos que no son de acuñación

  else(_) {
    False
  }
}
