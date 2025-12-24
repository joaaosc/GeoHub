#!/usr/bin/env bash
set -euo pipefail

swift package clean
rm -rf .build
