//
//  LoginView.swift
//  self-management
//
//  LEARNING: Login Screen (SwiftUI)
//

import SwiftUI
import UIKit

/// Login Screen following Clean Architecture
/// Injected with LoginViewModel via Dependency Injection
struct LoginView: View {
    
    // MARK: - Dependencies
    
    @State private var viewModel: LoginViewModel
    @FocusState private var focusedField: LoginFocusField?
    
    // MARK: - Initialization
    
    init(viewModel: @autoclosure @escaping () -> LoginViewModel) {
        self._viewModel = State(wrappedValue: viewModel())
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                LoginBackgroundView()
                
                ScrollView {
                    VStack(spacing: 32) {
                        LoginHeaderView()
                        
                        LoginFormView(
                            email: $viewModel.email,
                            password: $viewModel.password,
                            focusedField: $focusedField,
                            onSubmit: {
                                Task {
                                    await viewModel.performLogin()
                                }
                            }
                        )
                        .padding(.top, 10)
                        
                        LoginErrorView(errorMessage: viewModel.errorMessage)
                        
                        LoginSubmitButton(
                            isLoading: viewModel.isLoading,
                            isValid: isValid,
                            action: {
                                focusedField = nil
                                Task {
                                    await viewModel.performLogin()
                                }
                            }
                        )
                        .padding(.top, 10)
                        
                        Spacer(minLength: 40)
                        
                        LoginFooterView()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 30)
                }
                .scrollIndicators(.hidden)
            }
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                // MOCK Navigation - actual transition handled by RootView
                Text("Main App Content")
            }
            // Dismiss keyboard on tap outside
            .onTapGesture {
                focusedField = nil
            }
        }
    }
    
    private var isValid: Bool {
        !viewModel.email.isEmpty && !viewModel.password.isEmpty
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(
        useCase: LoginUseCase(repository: AuthRepository()),
        sessionService: SessionService()
    ))
}
