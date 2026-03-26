//
//  LoginViewModel.swift
//  self-management
//
//  LEARNING: ViewModel (Login)
//

import SwiftUI

/// ViewModel for Login screen
/// Follows MVVM pattern with @Observable
@Observable
@MainActor
final class LoginViewModel {
    
    // MARK: - Properties
    
    private let loginUseCase: LoginUseCase
    private let sessionService: SessionService
    
    // MARK: - UI State
    
    /// User input fields
    var email = ""
    var password = ""
    
    /// UI Indicators
    var isLoading = false
    var errorMessage: String?
    
    /// Local navigation state
    var isLoggedIn = false
    
    // MARK: - Initialization
    
    init(useCase: LoginUseCase, sessionService: SessionService) {
        self.loginUseCase = useCase
        self.sessionService = sessionService
    }
    
    // MARK: - Actions
    
    /// Perform login operation
    func performLogin() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let (user, tokens) = try await loginUseCase.execute(email: email, password: password)
            
            // Persist tokens and update auth state
            sessionService.startSession(tokens: tokens, user: user)
            
            // Mark local login success
            isLoggedIn = true
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "An unexpected error occurred."
        }
        
        isLoading = false
    }
    
    /// Reset screen state
    func reset() {
        email = ""
        password = ""
        errorMessage = nil
        isLoggedIn = false
    }
}
