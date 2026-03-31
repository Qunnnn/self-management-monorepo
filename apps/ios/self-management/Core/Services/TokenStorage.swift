//
//  TokenStorage.swift
//  self-management
//
//  CORE SERVICE: Local Token Persistence
//

import Foundation

/// Service responsible for persisting authentication tokens locally.
/// Uses UserDefaults for simplicity in a learning project.
/// NOTE: For production apps, use Keychain for secure token storage.
nonisolated
final class TokenStorage: Sendable {
    
    // MARK: - Constants
    
    private enum Keys {
        static let accessToken = "auth_access_token"
        static let refreshToken = "auth_refresh_token"
    }
    
    // MARK: - Dependencies
    
    private let defaults: UserDefaults
    
    // MARK: - Initialization
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    // MARK: - Save
    
    /// Save authentication tokens locally after a successful login
    /// - Parameter tokens: The access and refresh tokens to persist
    func saveTokens(_ tokens: AuthTokens) {
        defaults.set(tokens.accessToken, forKey: Keys.accessToken)
        defaults.set(tokens.refreshToken, forKey: Keys.refreshToken)
    }
    
    // MARK: - Load
    
    /// Load previously saved authentication tokens from local storage
    /// - Returns: The stored AuthTokens if available, nil otherwise
    func loadTokens() -> AuthTokens? {
        guard let accessToken = defaults.string(forKey: Keys.accessToken),
              let refreshToken = defaults.string(forKey: Keys.refreshToken)
        else {
            return nil
        }
        
        return AuthTokens(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    // MARK: - Clear
    
    /// Remove all stored tokens (on logout)
    func clearTokens() {
        defaults.removeObject(forKey: Keys.accessToken)
        defaults.removeObject(forKey: Keys.refreshToken)
    }
}
