//
//  RootView.swift
//  self-management
//
//  LEARNING: Root View & Navigation
//

import SwiftUI

/// Main navigation container for the app
struct RootView: View {

    // MARK: - Dependencies

    @Environment(\.dependencyContainer) private var container

    @State private var viewModel: RootViewModel

    // Store dependencies for creating LoginViewModel
    private let loginUseCase: LoginUseCase
    private let fetchCurrentUserUseCase: FetchCurrentUserUseCase
    private let sessionService: SessionService

    // MARK: - State

    @State private var selectedTab: Tab = .diary

    // MARK: - Initialization

    init(
        loginUseCase: @autoclosure @escaping () -> LoginUseCase,
        fetchCurrentUserUseCase: @autoclosure @escaping () -> FetchCurrentUserUseCase,
        sessionService: @autoclosure @escaping () -> SessionService
    ) {
        let loginUC = loginUseCase()
        let fetchUC = fetchCurrentUserUseCase()
        let service = sessionService()
        
        self.loginUseCase = loginUC
        self.fetchCurrentUserUseCase = fetchUC
        self.sessionService = service
        self._viewModel = State(wrappedValue: RootViewModel(
            loginUseCase: loginUC,
            fetchCurrentUserUseCase: fetchUC,
            sessionService: service
        ))
    }

    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.isCheckingSession {
                splashView
            } else if !viewModel.isAuthenticated {
                authFlow
            } else {
                mainAppFlow
            }
        }
        .task {
            // Check for existing session on startup
            await viewModel.checkSession()
        }
    }
    
    // MARK: - View Sections
    
    private var splashView: some View {
        ProgressView {
            Text("Starting up...")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var authFlow: some View {
        LoginView(viewModel: LoginViewModel(
            useCase: loginUseCase,
            sessionService: sessionService
        ))
    }
    
    private var mainAppFlow: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases) { tab in
                Group {
                    switch tab {
                    case .tasks:
                        TasksListView()
                    case .diary:
                        DiaryListView()
                    default:
                        ComingSoonView(feature: tab.title)
                    }
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
        .transition(.opacity) // Smooth transition after login
    }
}

// MARK: - Tab Definition

enum Tab: String, CaseIterable, Identifiable {
    case diary, tasks, finance
    
    var id: String { rawValue }
    
    var title: String {
        self.rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .diary: return "book.fill"
        case .tasks: return "checkmark.circle"
        case .finance: return "dollarsign.circle"
        }
    }
}

// MARK: - Preview

#Preview {
    RootView(
        loginUseCase: LoginUseCase(repository: AuthRepository()),
        fetchCurrentUserUseCase: FetchCurrentUserUseCase(repository: AuthRepository()),
        sessionService: SessionService()
    )
    .environment(DependencyContainer())
}
