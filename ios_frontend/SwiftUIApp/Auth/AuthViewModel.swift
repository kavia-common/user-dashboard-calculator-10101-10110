import Foundation
import Combine

#if canImport(CryptoKit)
import CryptoKit
#endif

@MainActor
final class AuthViewModel: ObservableObject {
    @Published private(set) var currentUser: User?
    @Published var isBusy: Bool = false
    @Published var errorMessage: String?

    private let store: AuthStore

    init(store: AuthStore = AuthStore()) {
        self.store = store
        self.currentUser = store.loadCurrentUser()
    }

    var isAuthenticated: Bool { currentUser != nil }

    func clearError() {
        errorMessage = nil
    }

    func logout() {
        store.clearCurrentUser()
        currentUser = nil
    }

    func login(email: String, password: String) {
        clearError()
        isBusy = true
        defer { isBusy = false }

        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard Self.isValidEmail(normalizedEmail) else {
            errorMessage = AuthError.invalidEmail.localizedDescription
            return
        }

        let hashed = Self.hashPassword(password)
        guard let user = store.findUser(byEmail: normalizedEmail),
              user.passwordHash == hashed else {
            errorMessage = AuthError.invalidCredentials.localizedDescription
            return
        }

        store.setCurrentUser(email: user.email)
        currentUser = user
    }

    func signUp(name: String, email: String, password: String, confirmPassword: String) {
        clearError()
        isBusy = true
        defer { isBusy = false }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter your name."
            return
        }
        guard Self.isValidEmail(normalizedEmail) else {
            errorMessage = AuthError.invalidEmail.localizedDescription
            return
        }

        let minLength = 8
        guard password.count >= minLength else {
            errorMessage = AuthError.passwordTooShort(minLength: minLength).localizedDescription
            return
        }

        guard password == confirmPassword else {
            errorMessage = AuthError.passwordMismatch.localizedDescription
            return
        }

        guard store.findUser(byEmail: normalizedEmail) == nil else {
            errorMessage = AuthError.userAlreadyExists.localizedDescription
            return
        }

        let newUser = User(
            name: trimmedName,
            email: normalizedEmail,
            passwordHash: Self.hashPassword(password),
            createdAt: Date()
        )

        do {
            try store.addUser(newUser)
            store.setCurrentUser(email: newUser.email)
            currentUser = newUser
        } catch {
            errorMessage = AuthError.storageFailure.localizedDescription
        }
    }

    private static func isValidEmail(_ email: String) -> Bool {
        // Simple validation suitable for demo UI.
        email.contains("@") && email.contains(".") && !email.contains(" ")
    }

    private static func hashPassword(_ password: String) -> String {
        #if canImport(CryptoKit)
        let data = Data(password.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
        #else
        // Fallback for environments without CryptoKit (demo only; not secure).
        return String(password.reversed())
        #endif
    }
}

final class AuthStore {
    private let usersKey = "auth.users.v1"
    private let currentUserEmailKey = "auth.current.email.v1"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadCurrentUser() -> User? {
        guard let email = defaults.string(forKey: currentUserEmailKey) else { return nil }
        return findUser(byEmail: email)
    }

    func setCurrentUser(email: String) {
        defaults.set(email, forKey: currentUserEmailKey)
    }

    func clearCurrentUser() {
        defaults.removeObject(forKey: currentUserEmailKey)
    }

    func findUser(byEmail email: String) -> User? {
        loadUsers().first { $0.email == email }
    }

    func addUser(_ user: User) throws {
        var users = loadUsers()
        users.append(user)
        try saveUsers(users)
    }

    private func loadUsers() -> [User] {
        guard let data = defaults.data(forKey: usersKey) else { return [] }
        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            // If storage is corrupted, fail gracefully (demo).
            return []
        }
    }

    private func saveUsers(_ users: [User]) throws {
        do {
            let data = try JSONEncoder().encode(users)
            defaults.set(data, forKey: usersKey)
        } catch {
            throw AuthError.storageFailure
        }
    }
}
