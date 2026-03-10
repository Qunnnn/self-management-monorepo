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
    
    // MARK: - Initialization
    
    init(viewModel: @autoclosure @escaping () -> LoginViewModel) {
        self._viewModel = State(wrappedValue: viewModel())
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                headerSection
                
                formSection
                
                errorMessage
                
                loginButton
                
                Spacer()
                
                footerSection
            }
            .padding()
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                // MOCK Navigation - actual transition handled by RootView
                Text("Main App Content")
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            Image(systemName: "shield.check.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundStyle(.blue.gradient)
            
            Text("Self Management")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Welcome back, please login to your account")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 50)
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            AuthField(
                label: "Email Address",
                placeholder: "name@example.com",
                text: $viewModel.email,
                keyboardType: .emailAddress
            )
            
            AuthField(
                label: "Password",
                placeholder: "••••••••",
                text: $viewModel.password,
                isSecure: true
            )
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var errorMessage: some View {
        if let error = viewModel.errorMessage {
            Text(error)
                .font(.footnote)
                .foregroundStyle(.red)
                .padding(.horizontal)
                .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    private var loginButton: some View {
        Button {
            Task {
                await viewModel.performLogin()
            }
        } label: {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .padding(.trailing, 5)
                }
                
                Text(viewModel.isLoading ? "Logging in..." : "Continue")
                    .fontWeight(.semibold)
            }
            .authButtonStyle(isLoading: viewModel.isLoading)
        }
        .disabled(viewModel.isLoading || viewModel.email.isEmpty || viewModel.password.isEmpty)
        .padding(.horizontal)
    }
    
    private var footerSection: some View {
        HStack {
            Text("Don't have an account?")
                .foregroundStyle(.secondary)
            Button("Sign Up") {
                // FUTURE: Navigate to SignUp
            }
            .fontWeight(.bold)
        }
        .font(.footnote)
        .padding(.bottom, 20)
    }
}

// MARK: - Subviews & Modifiers

private struct AuthField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(.roundedBorder)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled()
            }
        }
    }
}

private extension View {
    func authButtonStyle(isLoading: Bool) -> some View {
        self.frame(maxWidth: .infinity)
            .padding()
            .background(isLoading ? Color.gray : Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(
        useCase: LoginUseCase(repository: AuthRepository()),
        sessionService: SessionService()
    ))
}
