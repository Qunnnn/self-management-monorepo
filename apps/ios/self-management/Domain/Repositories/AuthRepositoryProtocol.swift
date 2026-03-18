//
//  AuthRepositoryProtocol.swift
//  self-management
//
//  LEARNING: Repository Protocol (Auth)
//

import Foundation

/// Protocol for authentication operations
/// This is a Domain Port - defines interface for Data layer
protocol AuthRepositoryProtocol {
    
    /// Login with email and password
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    /// - Returns: A tuple with the logged-in User and authentication tokens
    func login(email: String, password: String) async throws -> (User, AuthTokens)
    
    /// Logout current user
    func logout() async throws
    
    /// Fetch the current user profile using an access token
    /// - Parameter accessToken: A valid access token
    /// - Returns: The current User if the token is valid, nil otherwise
    func fetchCurrentUser(accessToken: String) async -> User?
}
