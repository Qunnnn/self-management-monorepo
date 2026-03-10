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
    /// - Returns: A result with the logged in User or an error
    func login(email: String, password: String) async throws -> User
    
    /// Logout current user
    func logout() async throws
    
    /// Check for an existing session
    /// - Returns: Current logged-in User if session exists
    func getCurrentUser() async -> User?
}
