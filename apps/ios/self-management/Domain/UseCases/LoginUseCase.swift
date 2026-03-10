//
//  LoginUseCase.swift
//  self-management
//
//  LEARNING: Use Case (Login)
//

import Foundation

/// Use case for user authentication
/// Contains all business logic related to logging in
final class LoginUseCase {
    
    // MARK: - Dependencies
    
    private let repository: AuthRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Use Case Methods
    
    /// Execute the login action
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    /// - Returns: The logged in user
    /// - Throws: Login errors from repository
    func execute(email: String, password: String) async throws -> User {
        // Business Rule: Ensure email is not empty before even calling repository
        guard !email.isEmpty else {
            throw AuthError.emptyEmail
        }
        
        // Business Rule: Ensure password is not empty before even calling repository
        guard !password.isEmpty else {
            throw AuthError.emptyPassword
        }
        
        // Call repository for actual authentication
        return try await repository.login(email: email, password: password)
    }
    
    /// Check if a user is already logged in
    /// - Returns: Current user if exists
    func checkSession() async -> User? {
        return await repository.getCurrentUser()
    }
}

// MARK: - Auth Errors

/// Domain-specific errors for authentication
enum AuthError: Error, LocalizedError {
    case emptyEmail
    case emptyPassword
    case invalidCredentials
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyEmail: return "Email cannot be empty."
        case .emptyPassword: return "Password cannot be empty."
        case .invalidCredentials: return "Invalid email or password."
        case .unknown(let message): return "An unknown error occurred: \(message)"
        }
    }
}
