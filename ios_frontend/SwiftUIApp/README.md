# SwiftUIApp (Login / Sign-Up / Dashboard + Calculator)

This folder contains the full SwiftUI UI implementation for:
- Login
- Sign-Up
- Dashboard (with Calculator)

It is kept **outside** SwiftPM `Sources/` so the existing Linux CI build remains headless, while keeping the UI code visible in the repo.

## How to run in Xcode (macOS)
1. Create an iOS app in Xcode (iOS 16+ recommended).
2. Add the local Swift package dependency:
   - Project → Package Dependencies → Add → “Add Local…”
   - Select: `user-dashboard-calculator-10101-10110/ios_frontend`
3. Add these sources to your app target:
   - Drag `ios_frontend/SwiftUIApp/` into your Xcode project
   - Ensure the app target is checked
4. Build & Run.

## Notes
- Authentication is local-only (UserDefaults) to keep this repo self-contained.
- The calculator uses `CalculatorCore` if the package dependency is added; otherwise it falls back to an internal implementation.
