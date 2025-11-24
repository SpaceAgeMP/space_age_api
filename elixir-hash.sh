#!/usr/bin/env bash
set -euo pipefail

if [ ! -f flake.nix ]; then
  echo 'No flake.nix detected, assuming this is not a nix repository'
  exit 0
fi
if [ ! -f deps-hash.txt ]; then
  echo 'No deps-hash.txt detected, assuming this is not a nix repository using elixir-nix-hash'
  exit 0
fi

echo 'sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=' > deps-hash.txt
RESULT="$((nix build '.#packages.x86_64-linux.default.mixFodDeps' || true) 2>&1 | grep -F ' got: ' | cut -d':' -f2 | tr -d ' ' || true)"
if [ -z "$RESULT" ]; then
  echo "Failed to compute vendor hash, running build again for debug"
  nix build '.#packages.x86_64-linux.default.mixFodDeps'
  exit 1
fi
echo "$RESULT" > deps-hash.txt
