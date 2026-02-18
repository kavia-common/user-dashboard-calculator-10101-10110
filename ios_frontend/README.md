# ios_frontend (Swift)

This container currently contains a **Swift Package Manager (SwiftPM)** scaffold so Swift code can exist and be visible in VS Code and compile/test in the Linux CI environment.

## Where are the Swift files?
- `Package.swift`
- `Sources/CalculatorCore/Calculator.swift`
- `Sources/Demo/main.swift`
- `Tests/CalculatorCoreTests/CalculatorCoreTests.swift`

## SwiftUI UI Screens (Login / Sign-Up / Dashboard + Calculator)
The full SwiftUI screen source files live under:

- `ios_frontend/SwiftUIApp/**`

These files are intentionally kept **outside** SwiftPM `Sources/` so the Linux CI build stays headless, while still making the iOS UI code fully visible/editable in VS Code Explorer.

### Running the SwiftUI app in Xcode (recommended)
1. On macOS, open Xcode → **File → New → Project… → iOS App**
2. Add this Swift package to your app:
   - Xcode → Project → Package Dependencies → **Add** → “Add Local…”
   - Select: `user-dashboard-calculator-10101-10110/ios_frontend`
3. Add the SwiftUI sources to your app target:
   - Drag `ios_frontend/SwiftUIApp/` into your Xcode project (check your app target)
4. Build & Run.
   - The UI uses a simple local (UserDefaults) auth store for demo purposes.
   - The calculator screen uses `CalculatorCore` when present.

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
