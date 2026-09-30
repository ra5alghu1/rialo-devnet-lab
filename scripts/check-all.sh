#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

checks=(
  "examples/devnet-info|"
  "examples/devnet-transfer|"
  "examples/venus-counter|--features implementation"
  "examples/venus-kv-store|--features implementation"
)

failures=0

printf 'Rialo DevNet Lab build smoke check\n'
printf 'Rust: %s\n' "$(rustc --version)"
printf 'Cargo: %s\n\n' "$(cargo --version)"

for check in "${checks[@]}"; do
  IFS='|' read -r example features <<< "$check"
  manifest="$ROOT_DIR/$example/Cargo.toml"

  if [[ ! -f "$manifest" ]]; then
    printf '[FAIL] %s: Cargo.toml not found\n' "$example"
    failures=$((failures + 1))
    continue
  fi

  printf '==> %s\n' "$example"

  args=(check --locked --manifest-path "$manifest")
  if [[ -n "$features" ]]; then
    read -r -a feature_args <<< "$features"
    args+=("${feature_args[@]}")
  fi

  if cargo "${args[@]}"; then
    printf '[OK]   %s\n\n' "$example"
  else
    printf '[FAIL] %s\n\n' "$example"
    failures=$((failures + 1))
  fi
done

if (( failures > 0 )); then
  printf 'Build smoke check failed for %d example(s).\n' "$failures"
  exit 1
fi

printf 'All %d examples passed locked cargo checks.\n' "${#checks[@]}"
