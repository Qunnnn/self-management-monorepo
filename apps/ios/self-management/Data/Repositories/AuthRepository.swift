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
    
    // MARK: - Initialization
    
    init() {
        // Mocking an initial state - optional
    }
    
    // MARK: - Repository Methods

    /// Login implementation
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    /// - Returns: A tuple with the logged-in User and authentication tokens
    func login(email: String, password: String) async throws -> (User, AuthTokens) {
        // MOCK: Simulate network call
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        // Mock validation: any email with "password" as password succeeds
        if !email.isEmpty && password == "password" {
            let mockUser = User(
                email: email,
                name: "John Doe",
                profilePictureUrl: URL(string: "https://placekitten.com/200/200")
            )
            
            // MOCK: Generate fake tokens
            let mockTokens = AuthTokens(
                accessToken: "mock_access_token_\(UUID().uuidString)",
                refreshToken: "mock_refresh_token_\(UUID().uuidString)"
            )
            
            return (mockUser, mockTokens)
        } else {
            throw AuthError.invalidCredentials
        }
    }
    
    /// Logout implementation
    func logout() async throws {
        // MOCK: Simulate network call
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
    }
    
    /// Fetch the current user profile using an access token
    /// - Parameter accessToken: A valid access token
    /// - Returns: Current logged-in User if the token is valid
    func fetchCurrentUser(accessToken: String) async -> User? {
        // MOCK: Simulate network call
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // MOCK: If we have a non-empty access token, return a mock user
        guard !accessToken.isEmpty else { return nil }
        
        return User(
            email: "restored@example.com",
            name: "John Doe",
            profilePictureUrl: URL(string: "https://placekitten.com/200/200")
        )
    }
}
