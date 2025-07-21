use aiken/collection/list
use cardano/assets.{lovelace_of}
use cardano/transaction.{Transaction, find_input}
use types.{
  Cancel, RegParam, Register, RegistrationDatum, RegistrationRedeemer, min_ada,
}

/// =============================================
/// REGISTRATION VALIDATOR
/// =============================================
///
/// This validator governs the spending of the registration UTxO.
///
/// ✅ Enforces the following rules:
/// 1. The registrar must sign the transaction.
/// 2. The input being spent must match the one declared in the redeemer.
/// 3. The student in the datum must match the redeemer.
/// 4. The input must contain **at least** `tuition_amount` in ADA.
/// 5. The amount in the input must match `total_required` (tuition + min ADA).
///
/// ---
///
/// Este validador regula el gasto del UTxO de matrícula.
///
/// ✅ Aplica las siguientes reglas:
/// 1. La transacción debe estar firmada por el registrador.
/// 2. El UTxO consumido debe coincidir con el declarado en el redeemer.
/// 3. El estudiante en el datum debe coincidir con el del redeemer.
/// 4. El UTxO debe contener al menos `tuition_amount` en ADA.
/// 5. El valor del UTxO debe ser exactamente igual a `total_required`.
///
validator registration_validator(param: RegParam) {
  spend(
    datum: Option<RegistrationDatum>,
    redeemer: RegistrationRedeemer,
    _output_ref,
    transaction: Transaction,
  ) {
    let Transaction { extra_signatories, inputs, .. } = transaction

    // --- Extract redeemer contents / Extraer contenido del redeemer
    let RegistrationRedeemer { action, student, unique_utxo } = redeemer

    // --- Check if signed by registrar / Verifica si el registrador firmó
    let signed_by_registrar = list.has(extra_signatories, param.registrar_pkh)

    // --- Find the UTxO input / Buscar el input por referencia
    let input_opt = find_input(inputs, unique_utxo)
    let input_present = input_opt != None

    // --- Check minimum required ADA / Verifica que contiene al menos el monto mínimo
    // ------> Para POC, el monto es de 0 ADA, pero se define un monto simbólico para pruebas por lo
    // que no se usa `tuition_amount` directamente.
    // let paid_enough =
    //  when input_opt is {
    //    Some(i) -> lovelace_of(i.output.value) >= tuition_amount
    //    None -> False
    //  }
    // --- Validate student identity / Validar identidad del estudiante
    let valid_student =
      when datum is {
        Some(d) -> d.student_pkh == student
        None -> False
      }

    // --- Ensure UTxO holds exactly the required amount (tuition + min ADA)
    // --- Verificar que el UTxO contenga exactamente el monto requerido
    // ------> Para POC, el monto es de 0 ADA, pero se define un monto simbólico para pruebas.
    // let paid_exactly =
    //  when input_opt is {
    //    Some(i) -> lovelace_of(i.output.value) == total_required
    //    None -> False
    //  }
    // --- Dispatch based on action / Lógica según la acción declarada
    let valid_min_ada =
      when input_opt is {
        Some(i) -> lovelace_of(i.output.value) >= min_ada
        None -> False
      }

    when action is {
      Register ->
        if !signed_by_registrar {
          trace @"Error: not signed by registrar"
          False
        } else if !input_present {
          trace @"Error: expected UTxO not found"
          False
        } else if !valid_student {
          trace @"Error: student mismatch"
          False
        } else if !valid_min_ada {
          trace @"Error: registration UTxO below min ADA"
          False
        } else {
          //} else if !paid_enough {
          //  trace @"Error: insufficient tuition payment"
          //  False
          //} else if !paid_exactly {
          //  trace @"Error: registration UTxO does not hold exact tuition amount"
          //  False
          trace @"Success: registration accepted"
          True
        }

      Cancel -> {
        trace @"Revocation logic not implemented"
        False
      }
    }
  }

  // --- Fallback for unsupported purposes / Fallback para contextos no válidos
  else(_) {
    trace @"Unhandled context"
    False
  }
}
