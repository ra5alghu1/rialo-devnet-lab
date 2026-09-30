# Rialo DevNet Lab

My personal learning log while exploring Rialo DevNet.

I'm not a Rust or blockchain developer. I started this repo to understand how Rialo works by actually running things instead of only reading about them.

I use AI as a learning / pair-programming tool to help me understand errors, Rust syntax and the Rialo toolchain.

Some things worked immediately. Some definitely didn't. A lot of this repo came from fixing those problems one by one.

## What I've tried so far

- Installed Rialo CLI and connected to DevNet
- Created DevNet wallets and used the faucet
- Queried DevNet block height from a small Rust program
- Sent a DevNet RLO transaction from Rust
- Experimented with the Venus DSL
- Generated WIT and a Venus manifest
- Built a PolkaVM artifact
- Deployed a small Venus counter program
- Invoked it on DevNet

## Experiments

### `examples/devnet-info`

My first small Rust/Rialo CDK experiment.

It connects to DevNet and reads the current block height.

### `examples/devnet-transfer`

A slightly more interesting experiment.

It creates a temporary wallet, gets test RLO from the faucet and sends a small DevNet transaction.

### `examples/venus-counter`

This one took considerably more trial and error.

It's a tiny stateful Venus workflow with a counter.

I used it to learn the basic flow:

```text
Venus source
   ↓
WIT / manifest
   ↓
PolkaVM artifact
   ↓
DevNet deploy
   ↓
invoke
```


### `examples/venus-kv-store`

A small state-persistence experiment after the counter.

It starts with a deliberately bounded single key/value slot: `set` mutates
workflow state, `get` observes it on a later invocation, and `clear` resets
the slot. The first version uses primitive state so the DevNet behaviour can be
verified before experimenting with collection-shaped state.

## Build smoke checks

The Rust examples are separate crates with their own lockfiles. Run the repository-wide compile smoke check with:

```bash
bash scripts/check-all.sh
```

It runs locked Cargo checks for all four examples. The Venus examples are checked with the `implementation` feature enabled so their implementation code is compiled too.

GitHub Actions runs the same checks on pushes and pull requests. These are compile-time checks only: they do not use the faucet, submit transactions, deploy programs, or require DevNet credentials.

## Notes

There may be rough edges here.

This repository is intentionally a record of me learning the tooling, not a production application or an example of best-practice Rust development.

One useful lesson already: some examples and documentation I found didn't exactly match Rialo 0.18.1, so I ended up looking directly through the installed crate sources to understand the current Venus DSL.

## Environment

This lab originally started on Windows 11 + WSL2 and is now continued on native Ubuntu.

Current validated environment:

- Ubuntu 26.04 LTS
- Rust via rustup
- rialoman 0.3.0
- Rialo CLI 0.18.1
- Rialo CDK 0.18.1
- Rialo Venus 0.18.1
- rialo-rust 0.0.3

## Security

DevNet only.

No seed phrases, private keys or production credentials should ever be committed here.

## Why this repo exists

Mostly curiosity.

I'm learning what Rialo can do and documenting the experiments that actually worked.
