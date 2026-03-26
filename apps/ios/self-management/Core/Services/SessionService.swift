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
    
    /// Currently logged in user profile
    private(set) var currentUser: User?
    
    // MARK: - Initialization
    
    init(tokenStorage: TokenStorage = TokenStorage()) {
        self.tokenStorage = tokenStorage
        self.isAuthenticated = tokenStorage.loadTokens() != nil
    }
    
    // MARK: - Actions
    
    /// Start a new user session (usually called after login)
    /// Saves the authentication tokens locally for persistence across app launches
    /// - Parameters:
    ///   - tokens: The access and refresh tokens to persist
    ///   - user: The user profile of the logged-in user
    func startSession(tokens: AuthTokens, user: User) {
        tokenStorage.saveTokens(tokens)
        self.currentUser = user
        withAnimation(.default) {
            self.isAuthenticated = true
        }
    }
    
    /// Update the current user profile
    /// - Parameter user: The updated user profile
    func updateCurrentUser(_ user: User) {
        self.currentUser = user
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
        self.currentUser = nil
        withAnimation(.default) {
            self.isAuthenticated = false
        }
    }
}
