#!/usr/bin/env bash
set -euo pipefail

if ! command -v swift-format >/dev/null 2>&1; then
  echo "swift-format não está instalado."
  echo "Opção: brew install swift-format"
  exit 0
fi

swift-format format -r Sources Tests
