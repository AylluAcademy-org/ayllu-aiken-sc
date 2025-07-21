# Ayllu Smart Contracts – Aiken Implementation

This repository contains the Aiken-based smart contracts for the Ayllu Academy ecosystem. It includes Plutus validators, CLI scripts, and supporting components designed for secure and transparent interactions on the Cardano blockchain.

---

## 📁 Project Structure

```
ayllu-contracts/
├── aiken.toml                  # Aiken project configuration
├── validators/                 # On-chain Plutus V2 smart contracts written in Aiken
├── build/
│   ├── cli-scripts/           # CLI-based transaction scripts (bash + cardano-cli)
│   ├── wallets/               # (Ignored) Wallet keys and addresses
│   └── policy/                # Minting policies and related CBORs
└── scripts/                   # Auxiliary setup or utility scripts
```

---

## 🛠 Requirements

- [Aiken](https://aiken-lang.org/) (latest version)
- [Cardano CLI](https://docs.cardano.org/cardano-testnet/tools/cardano-cli/)
- Local Cardano node (Preview or Preprod recommended)
- Ubuntu or WSL (recommended for scripting)
- `jq` for JSON manipulation
- `git`, `bash`, and common CLI tools

---

## 🔐 Wallet Setup (excluded from versioning)

To interact with the blockchain, wallet keys must be generated manually:

```bash
mkdir -p build/wallets/enterprise

cardano-cli address key-gen \
  --verification-key-file build/wallets/enterprise.vkey \
  --signing-key-file build/wallets/enterprise.skey

cardano-cli address build \
  --payment-verification-key-file build/wallets/enterprise.vkey \
  --testnet-magic 2 \
  --out-file build/wallets/enterprise.addr
```

🚫 The `wallets/` directory is excluded from version control via `.gitignore`.

---

## ⚙️ Compile Aiken Contracts

```bash
aiken build
```

Compiled scripts are output to the `plutus.json` file and other CBOR files in the `build/` folder.

---

## 🚀 Transaction Workflow

Each CLI script is modularized and performs a defined step in a blockchain operation. Example folders include:

- `register/`: Validator for student registration.
- `mint/`: Minting NFTs or fungible tokens with reference scripts.
- `burn/`: Token destruction policies.

All scripts follow this structure:
- Load validator or policy.
- Prepare datum and redeemer.
- Build transaction.
- Sign and submit.

---

## 🧪 Testing

You can use `aiken check` to verify type correctness:

```bash
aiken check
```

Unit tests can be written inside the `validators/` folder using Aiken’s built-in testing features.

---

## 📄 License

This codebase is maintained by the Ayllu Academy team and is currently in active development. All contributions and forks must retain credit to original authors.

---

## ✍️ Authors

- [David Tacuri](https://github.com/neielv) – Lead Developer
- Ayllu Academy – Blockchain Education for Latin America
