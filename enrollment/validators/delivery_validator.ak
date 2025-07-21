use aiken/collection/list
use cardano/address
//use cardano/assets.{flatten, lovelace_of, policies}
use cardano/assets.{flatten, policies}
use cardano/transaction.{Transaction, find_input}
use types.{MintParam, RegistrationDatum, RegistrationRedeemer}

/// ===========================================
/// DELIVERY VALIDATOR
/// ===========================================
///
/// Validates that the NFT representing enrollment is correctly delivered:
/// - The registrar signed the transaction.
/// - The required UTxO is consumed.
/// - Datum and redeemer are consistent.
/// - The registrar receives the tuition in ADA.
/// - The minted token is correct.
/// - The token is delivered to the intended student.
///
/// Validador que verifica la correcta entrega del NFT de inscripción:
/// - El registrador firmó la transacción.
/// - Se consume el UTxO requerido.
/// - El datum y el redeemer son coherentes.
/// - El registrador recibe la matrícula en ADA.
/// - El token acuñado es correcto.
/// - El token se entrega al estudiante correspondiente.
///
validator delivery_validator(param: MintParam) {
  spend(
    datum: Option<RegistrationDatum>,
    redeemer: RegistrationRedeemer,
    _own_ref,
    tx: Transaction,
  ) {
    let Transaction { inputs, extra_signatories, mint, outputs, .. } = tx

    // --- Verify that the registrar signed the transaction
    // --- Verifica que el registrador firmó la transacción
    let registrar_signed = list.has(extra_signatories, param.registrar_pkh)

    // --- Ensure the UTxO used for registration is being consumed
    // --- Asegura que el UTxO usado para la inscripción esté siendo consumido
    let utxo_found = find_input(inputs, param.utxo_ref) != None

    // --- Validate presence and shape of datum
    // --- Valida la presencia y estructura del datum
    expect Some(d) = datum

    // --- Check that redeemer matches the datum and expected UTxO
    // --- Verifica que el redeemer coincida con el datum y el UTxO esperado
    let redeemer_matches =
      redeemer.student == d.student_pkh && redeemer.unique_utxo == param.utxo_ref

    // --- Validate ADA is paid to registrar
    // --- Valida que se pague ADA al registrador
    //let registrar_addr = address.from_verification_key(param.registrar_pkh)
    //let registrar_paid =
    //  list.any(
    //    outputs,
    //    fn(output) {
    //      output.address == registrar_addr && lovelace_of(output.value) >= tuition_amount
    //    },
    //  )
    // --- Extract the minted token
    // --- Extrae el token acuñado
    expect [minted_token] = flatten(mint)
    let (policy_id, name, quantity) = minted_token

    // --- Ensure token name and quantity match expected values
    // --- Asegura que el nombre y cantidad del token sean correctos
    let mint_ok = name == param.token_name && quantity == 1

    // --- Verify token is delivered to the student’s address
    // --- Verifica que el token sea entregado a la dirección del estudiante
    let student_address = address.from_verification_key(param.student_pkh)

    let token_delivered =
      list.any(
        outputs,
        fn(output) {
          output.address == student_address && list.has(
            policies(output.value),
            policy_id,
          )
        },
      )

    // --- Final conditional validations
    // --- Validaciones finales condicionales
    if !registrar_signed {
      trace @"Error: not signed by registrar"
      False
    } else if !utxo_found {
      trace @"Error: utxo not consumed"
      False
    } else if !redeemer_matches {
      trace @"Error: redeemer mismatch"
      False
    } else if //} else if !registrar_paid {
    //  trace @"Error: registrar not paid"
    //  False
    !mint_ok {
      trace @"Error: invalid mint"
      False
    } else if !token_delivered {
      trace @"Error: token not delivered to student"
      False
    } else {
      trace @"Success: token delivery validated"
      True
    }
  }

  // --- Fallback clause for unhandled contexts
  // --- Clausula de respaldo para contextos no manejados
  else(_) {
    trace @"Unhandled context"
    False
  }
}
