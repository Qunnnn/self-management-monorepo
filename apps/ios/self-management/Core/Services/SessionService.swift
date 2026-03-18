//
//  SessionService.swift
//  self-management
//
//  CORE SERVICE: Global Session Management
//

import SwiftUI

/// Observable service that tracks the current user session
/// Shared throughout the application via Dependency Injection
@Observable
final class SessionService {
    
    // MARK: - Dependencies
    
    private let tokenStorage: TokenStorage
    
    // MARK: - App State
    
    /// Global authentication status (based on token existence)
    private(set) var isAuthenticated = false
    
    // MARK: - Initialization
    
    init(tokenStorage: TokenStorage = TokenStorage()) {
        self.tokenStorage = tokenStorage
        self.isAuthenticated = tokenStorage.loadTokens() != nil
    }
    
    // MARK: - Actions
    
    /// Start a new user session (usually called after login)
    /// Saves the authentication tokens locally for persistence across app launches
    /// - Parameter tokens: The access and refresh tokens to persist
    func startSession(tokens: AuthTokens) {
        tokenStorage.saveTokens(tokens)
        withAnimation(.default) {
            self.isAuthenticated = true
        }
    }
    
    /// Restore the saved tokens from local storage
    /// - Returns: The stored AuthTokens if a saved session exists, nil otherwise
    func restoreTokens() -> AuthTokens? {
        return tokenStorage.loadTokens()
    }
    
    /// End the current session (Logout)
    /// Clears the locally stored tokens
    func endSession() {
        tokenStorage.clearTokens()
        withAnimation(.default) {
            self.isAuthenticated = false
        }
    }
}
