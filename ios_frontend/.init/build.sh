#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/user-dashboard-calculator-10101-10110/ios_frontend"
cd "$WORKSPACE"
# Build to ensure binary exists
swift build -c debug || { echo "ERROR: build failed" >&2; exit 2; }
# Print bin path for callers
swift build --show-bin-path || true
