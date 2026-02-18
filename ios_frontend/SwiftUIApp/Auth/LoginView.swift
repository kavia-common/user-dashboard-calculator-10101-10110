import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var auth: AuthViewModel

    @Binding var showSignUp: Bool

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 16) {
            header

            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Email")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.secondary)

                    TextField("you@example.com", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .padding(12)
                        .background(Color.black.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    Text("Password")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.secondary)

                    SecureField("••••••••", text: $password)
                        .textInputAutocapitalization(.never)
                        .padding(12)
                        .background(Color.black.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    if let message = auth.errorMessage {
                        Text(message)
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(AppTheme.error)
                            .padding(.top, 4)
                            .accessibilityLabel("Error: \(message)")
                    }

                    PrimaryButton(title: "Log In", isLoading: auth.isBusy) {
                        auth.login(email: email, password: password)
                    }
                    .padding(.top, 6)

                    HStack(spacing: 6) {
                        Text("No account?")
                            .foregroundStyle(AppTheme.secondary)
                        Button("Sign Up") {
                            auth.clearError()
                            showSignUp = true
                        }
                        .foregroundStyle(AppTheme.primary)
                        .font(.subheadline.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(20)
        .foregroundStyle(AppTheme.text)
        .onAppear { auth.clearError() }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Welcome back")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(AppTheme.text)

            Text("Log in to access your dashboard and calculator.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }
}
