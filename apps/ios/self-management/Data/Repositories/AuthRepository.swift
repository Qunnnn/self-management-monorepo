//
//  AuthRepository.swift
//  self-management
//
//  LEARNING: Repository Implementation (Auth)
//

import Foundation

/// Implementation of authentication operations
/// This is a Data Adapter - implementation detail of the Domain Repository Port
final class AuthRepository: AuthRepositoryProtocol {
    
    // MARK: - Local State
    
    /// User session token or identifier
    private var currentUser: User?
    
    // MARK: - Initialization
    
    init() {
        // Mocking an initial state - optional
    }
    
    // MARK: - Repository Methods

    /// Login implementation
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    /// - Returns: A result with the logged in User or an error
    func login(email: String, password: String) async throws -> User {
        // MOCK: Simulate network call
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        // Mock validation: any email with "password" as password succeeds
        if !email.isEmpty && password == "password" {
            let mockUser = User(
                email: email,
                name: "John Doe",
                profilePictureUrl: URL(string: "https://placekitten.com/200/200")
            )
            self.currentUser = mockUser
            return mockUser
        } else {
            throw AuthError.invalidCredentials
        }
    }
    
    /// Logout implementation
    func logout() async throws {
        // MOCK: Simulate network call
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        self.currentUser = nil
    }
    
    /// Check for an existing session
    /// - Returns: Current logged-in User if session exists
    func getCurrentUser() async -> User? {
        return self.currentUser
    }
}
