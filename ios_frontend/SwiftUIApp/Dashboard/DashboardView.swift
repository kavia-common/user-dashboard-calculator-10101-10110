import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var auth: AuthViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header

                CalculatorCardView()

                Card {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Account")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(AppTheme.text)

                        Text("Signed in as")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondary)

                        Text(auth.currentUser?.email ?? "—")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.text)

                        SubtleButton(title: "Log Out") {
                            auth.logout()
                        }
                        .padding(.top, 6)
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Hi, \(auth.currentUser?.name ?? "there")")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(AppTheme.text)

            Text("Use the calculator below—available after login.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 2)
    }
}
