import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var auth: AuthViewModel

    @Binding var showSignUp: Bool

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        VStack(spacing: 16) {
            header

            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Name")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.secondary)

                    TextField("Your name", text: $name)
                        .textInputAutocapitalization(.words)
                        .padding(12)
                        .background(Color.black.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

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

                    SecureField("At least 8 characters", text: $password)
                        .textInputAutocapitalization(.never)
                        .padding(12)
                        .background(Color.black.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    Text("Confirm Password")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.secondary)

                    SecureField("Re-enter password", text: $confirmPassword)
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

                    PrimaryButton(title: "Create Account", isLoading: auth.isBusy) {
                        auth.signUp(
                            name: name,
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword
                        )
                    }
                    .padding(.top, 6)

                    HStack(spacing: 6) {
                        Text("Already have an account?")
                            .foregroundStyle(AppTheme.secondary)
                        Button("Log In") {
                            auth.clearError()
                            showSignUp = false
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
            Text("Create account")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(AppTheme.text)

            Text("Sign up to unlock your dashboard.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }
}
