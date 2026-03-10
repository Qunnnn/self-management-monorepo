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
    
    // MARK: - App State
    
    /// The currently logged-in user (nil if guest)
    private(set) var currentUser: User?
    
    /// Global authentication status
    var isAuthenticated: Bool {
        currentUser != nil
    }
    
    // MARK: - Initialization
    
    init(user: User? = nil) {
        self.currentUser = user
    }
    
    // MARK: - Actions
    
    /// Start a new user session (usually called after login)
    /// - Parameter user: The authenticated user profile
    func startSession(for user: User) {
        withAnimation(.default) {
            self.currentUser = user
        }
    }
    
    /// End the current session (Logout)
    func endSession() {
        withAnimation(.default) {
            self.currentUser = nil
        }
    }
}
