#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/user-dashboard-calculator-10101-10110/ios_frontend"
cd "$WORKSPACE"
# Ensure env for tests
export IOS_FRONTEND_API_URL="https://mock-api.local"
export IOS_FRONTEND_AUTH_TOKEN="test-token"
export IOS_FRONTEND_TEST_DB="/tmp/ios_frontend_test_$(date +%s).db"
# Force single-threaded XCTest to avoid concurrency file races
export XCTEST_DISABLE_CONCURRENCY=1
swift test || { echo "ERROR: swift test failed" >&2; exit 4; }
