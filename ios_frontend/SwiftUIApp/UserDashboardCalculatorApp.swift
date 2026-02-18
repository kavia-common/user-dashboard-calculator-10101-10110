import SwiftUI

/// App entry point.
/// Add `SwiftUIApp/**` to an Xcode iOS App target, and add the local Swift package
/// (`ios_frontend/`) as a dependency to use `CalculatorCore` from the dashboard.
@main
struct UserDashboardCalculatorApp: App {
    @StateObject private var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
        }
    }
}
