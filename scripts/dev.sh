#!/usr/bin/env bash
set -euo pipefail

if ! command -v entr >/dev/null 2>&1; then
  echo "entr não está instalado. Instale com: brew install entr"
  exit 1
fi

echo "Watching Swift sources and restarting server on changes..."
find Sources -name '*.swift' | entr -r swift run
