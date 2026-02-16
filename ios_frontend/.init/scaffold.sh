#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/user-dashboard-calculator-10101-10110/ios_frontend"
mkdir -p "$WORKSPACE"
cd "$WORKSPACE"
# Package.swift (tools-version 5.9)
if [ ! -f "$WORKSPACE/Package.swift" ]; then
  cat > "$WORKSPACE/Package.swift" <<'PW'
// swift-tools-version:5.9
import PackageDescription
let package = Package(
  name: "CalculatorPackage",
  products: [
    .library(name: "Calculator", targets: ["Calculator"]),
    .executable(name: "demo", targets: ["Demo"]),
  ],
  targets: [
    .target(name: "Calculator", path: "Sources/Calculator"),
    .executableTarget(name: "Demo", path: "Sources/Demo"),
    .testTarget(name: "CalculatorTests", dependencies: ["Calculator"], path: "Tests/CalculatorTests"),
  ]
)
PW
fi
mkdir -p "$WORKSPACE/Sources/Calculator" "$WORKSPACE/Sources/Demo" "$WORKSPACE/Tests/CalculatorTests"
# Calculator implementation
cat > "$WORKSPACE/Sources/Calculator/Calculator.swift" <<'CS'
public struct Calculator {
  public init() {}
  public func add(_ a: Int, _ b: Int) -> Int { a + b }
}
CS
# Demo executable with portable signal handling
cat > "$WORKSPACE/Sources/Demo/main.swift" <<'DM'
import Foundation
import Dispatch
print("demo starting")
fflush(stdout)
let sem = DispatchSemaphore(value: 0)
// Use POSIX signal handlers; keep handler minimal and signal a semaphore for graceful shutdown
signal(SIGTERM) { _ in
  print("demo shutting down")
  fflush(stdout)
  sem.signal()
}
signal(SIGINT) { _ in
  print("demo interrupt")
  fflush(stdout)
  sem.signal()
}
_ = sem.wait(timeout: .distantFuture)
DM
# Unit test
cat > "$WORKSPACE/Tests/CalculatorTests/CalculatorTests.swift" <<'TS'
import XCTest
@testable import Calculator
final class CalculatorTests: XCTestCase {
  func testAdd() {
    XCTAssertEqual(Calculator().add(2,3), 5)
  }
}
TS
# Minimal helper scripts (build, start) using workspace path variable
cat > "$WORKSPACE/build.sh" <<'BS'
#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/user-dashboard-calculator-10101-10110/ios_frontend"
cd "${WORKSPACE}"
# deterministic debug build
swift build -c debug
BS
chmod +x "$WORKSPACE/build.sh"
cat > "$WORKSPACE/start.sh" <<'SS'
#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/user-dashboard-calculator-10101-10110/ios_frontend"
cd "${WORKSPACE}"
BIN_DIR=$(swift build --show-bin-path 2>/dev/null || echo ".build/debug")
exec "${BIN_DIR}/demo"
SS
chmod +x "$WORKSPACE/start.sh"
