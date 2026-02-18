# ios_frontend (Swift)

This container currently contains a **Swift Package Manager (SwiftPM)** scaffold so Swift code can exist and be visible in VS Code and compile/test in the Linux CI environment.

## Where are the Swift files?
- `Package.swift`
- `Sources/CalculatorCore/Calculator.swift`
- `Sources/Demo/main.swift`
- `Tests/CalculatorCoreTests/CalculatorCoreTests.swift`

## If VS Code Explorer doesn’t show new files
1. Open the correct folder:
   - Recommended: open `user-dashboard-calculator-10101-10110/` as the workspace root.
2. In Explorer, click **Refresh** (top of the Explorer panel).
3. Command Palette → **Developer: Reload Window**
4. Check exclusions:
   - Settings → `files.exclude` / `search.exclude`
   - Ensure `Sources`, `Tests`, and `Package.swift` are not excluded.

## Quick terminal checks
From the repo root:
- `ls -la user-dashboard-calculator-10101-10110/ios_frontend`
- `find user-dashboard-calculator-10101-10110/ios_frontend -name "*.swift" -print`
