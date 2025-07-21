# enrollment

Write validators in the `validators` folder, and supporting functions in the `lib` folder using `.ak` as a file extension.

```aiken
validator my_first_validator {
  spend(_datum: Option<Data>, _redeemer: Data, _output_reference: Data, _context: Data) {
    True
  }
}
```

## Building

```sh
aiken build
```

## Configuring

**aiken.toml**
```toml
[config.default]
network_id = 41
```

Or, alternatively, write conditional environment modules under `env`.

## Testing

You can write tests in any module using the `test` keyword. For example:

```aiken
use config

test foo() {
  config.network_id + 1 == 42
}
```

To run all tests, simply do:

```sh
aiken check
```

To run only tests matching the string `foo`, do:

```sh
aiken check -m foo
```

## Documentation

If you're writing a library, you might want to generate an HTML documentation for it.

Use:

```sh
aiken docs
```

## Resources

Find more on the [Aiken's user manual](https://aiken-lang.org).
# Ayllu Enrollment Smart Contracts (AIken Version)

This project contains a fully on-chain implementation of a **student enrollment system** written in [Aiken](https://aiken-lang.org), targeting the Cardano blockchain and replacing an original Plutus-based version.

---

## З Narrative (EN)

The smart contracts in this folder implement the following logic:

1.  A student sends the **tuition amount** to the `registration_validator`.
2.  This transaction is validated by:
   - the registrar's signature,
   - an exact amount of tuition + min ADA,
   - a valid student identity.
3.  An **enrollment token (NFT)** is minted and **delivered to the student's address**.
4.  The tuition amount is transferred to the **Registrar鈥檚 wallet**.
5.  Only the **Registrar** is authorized to consume the funds in the registration script.

> The student provides their address for NFT delivery in the same transaction as the tuition payment. This allows use cases like gifts or batch enrollments.

---

## З Narrativa (ES)

Este conjunto de contratos inteligentes implementa el siguiente flujo:

1.  El estudiante env铆a el monto de la matr铆cula al `registration_validator`.
2.  Esta transacci贸n es validada si:
   - est firmada por el registrador,
   - contiene exactamente la matr铆cula + min ADA,
   - la identidad del estudiante es v谩lida.
3.  Se acu帽a un **NFT de inscripci贸n** y se entrega a la direcci贸n del estudiante.
4.  Los fondos se transfieren a la billetera del **registrador**.
5.  Solo el **registrador** puede consumir los fondos del script de inscripci贸n.

> El estudiante declara la direcci贸n donde se le entregar谩 el NFT, lo que permite regalos o inscripciones masivas.

---

##  File Structure

```bash
enrollment/
├── validators/
│   ├── registration_validator.ak
│   ├── mint_validator.ak
│   └── delivery_validator.ak
├── lib/
│   ├── types.ak
│   └── aiken.toml
└── README.md


---

## И Usage

After cloning the repository:

```bash
aiken check
```

To compile and test the contracts.

---

##  Validators

### Ь `registration_validator.ak`

- Ensures registrar signature.
- Checks UTxO identity and student matching.
- Validates tuition ADA value.
- Locks funds at the script until delivered.

###  `mint_validator.ak`

- Ensures 1 NFT is minted per student.
- Validates UTxO consumption and token name.
- Authorizes minting by registrar only.

###  `delivery_validator.ak`

- Delivers the NFT to the student's wallet.
- Transfers ADA to the registrar.
- Checks redeemer, minting policy, and output destinations.

---

##  To Do

- [ ] Add off-chain endpoints in JavaScript or Python.
- [ ] Integrate Aiken CLI deployment with `lucid` or `cardano-cli`.
- [ ] Write tests with `aiken test` and scenario coverage.

---

##  Learning Resources

- [Aiken Documentation](https://aiken-lang.org)
- [Plutus Pioneer Program](https://plutus-pioneer-program.github.io/)
- [Cardano Docs](https://docs.cardano.org)

---

