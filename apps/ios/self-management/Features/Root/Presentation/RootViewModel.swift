//
//  RootViewModel.swift
//  self-management
//
//  LEARNING: App Root State Management
//

import SwiftUI

/// ViewModel for managing the main application state
/// Responsible for determining if the user should see Auth or Main App
@Observable
@MainActor
final class RootViewModel {
    
    // MARK: - Properties
    
    private let loginUseCase: LoginUseCase
    private let sessionService: SessionService
    
    // MARK: - App State
    
    /// Loading state for initial session check
    var isCheckingSession = true
    
    /// True if the user is authenticated (Derived from sessionService)
    var isAuthenticated: Bool {
        sessionService.isAuthenticated
    }
    
    // MARK: - Initialization
    
    init(loginUseCase: LoginUseCase, sessionService: SessionService) {
        self.loginUseCase = loginUseCase
        self.sessionService = sessionService
    }
    
    // MARK: - Actions
    
    /// Check if a user session already exists
    /// Session is already restored from stored tokens in SessionService.init
    func checkSession() async {
        isCheckingSession = true
        
        // Brief delay to prevent flicker if session check is instant
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        if isAuthenticated, let tokens = sessionService.restoreTokens() {
            // Restore current user profile
            if let user = await loginUseCase.fetchCurrentUser(accessToken: tokens.accessToken) {
                sessionService.updateCurrentUser(user)
            } else {
                // Token might be invalid or expired
                sessionService.endSession()
            }
        }
        
        isCheckingSession = false
    }
    
    /// Log out the user
    func logout() {
        sessionService.endSession()
    }
}
