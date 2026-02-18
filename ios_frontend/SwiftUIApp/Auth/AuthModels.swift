import Foundation

struct User: Codable, Equatable, Identifiable {
    var id: String { email }

    let name: String
    let email: String
    let passwordHash: String
    let createdAt: Date
}

enum AuthError: LocalizedError, Equatable {
    case invalidEmail
    case passwordTooShort(minLength: Int)
    case passwordMismatch
    case userAlreadyExists
    case invalidCredentials
    case storageFailure
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address."
        case .passwordTooShort(let minLength):
            return "Password must be at least \(minLength) characters."
        case .passwordMismatch:
            return "Passwords do not match."
        case .userAlreadyExists:
            return "An account with this email already exists."
        case .invalidCredentials:
            return "Incorrect email or password."
        case .storageFailure:
            return "Could not save your account. Please try again."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
