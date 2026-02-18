import SwiftUI

struct RootView: View {
    @EnvironmentObject private var auth: AuthViewModel
    @State private var showSignUp: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()

                Group {
                    if auth.isAuthenticated {
                        DashboardView()
                    } else {
                        authFlow
                    }
                }
            }
        }
    }

    private var authFlow: some View {
        Group {
            if showSignUp {
                SignUpView(showSignUp: $showSignUp)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Back") { showSignUp = false }
                                .foregroundStyle(AppTheme.primary)
                        }
                    }
            } else {
                LoginView(showSignUp: $showSignUp)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}
