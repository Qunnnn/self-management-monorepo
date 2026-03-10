//
//  DependencyContainer.swift
//  self-management
//
//  LEARNING: Dependency Injection Container
//
//  WHY USE THIS?
//  - Single source of truth for all dependencies
//  - Easy to swap implementations (e.g., mock for testing)
//  - Follows Dependency Inversion Principle (SOLID's "D")
//
//  HOW IT WORKS:
//  - Container creates and holds all shared services
//  - Views receive dependencies via @Environment
//  - Dependencies are created in the initializer
//

import SwiftUI

/// Main dependency container for the application
/// Uses @Observable macro for automatic SwiftUI updates
@Observable
final class DependencyContainer {

    // MARK: - Core Services
    
    /// Global session and authentication state
    let sessionService: SessionService

    // MARK: - Repositories

    /// Notes repository for CRUD operations on notes
    let notesRepository: NotesRepositoryProtocol
    
    /// Auth repository for authentication operations
    let authRepository: AuthRepositoryProtocol

    // MARK: - Use Cases

    /// Use case for managing notes
    let notesUseCase: NotesUseCase
    
    /// Use case for user authentication
    let loginUseCase: LoginUseCase

    // MARK: - Initialization

    init() {
        // Initialize Core Services first
        self.sessionService = SessionService()
        
        // Initialize repositories
        let notesRepo = NotesRepository()
        self.notesRepository = notesRepo
        
        let authRepo = AuthRepository()
        self.authRepository = authRepo

        // Then initialize use cases with their dependencies
        self.notesUseCase = NotesUseCase(repository: notesRepo)
        self.loginUseCase = LoginUseCase(repository: authRepo)
    }
}

// MARK: - Environment Key

/// Custom environment key for accessing the container
private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue: DependencyContainer? = nil
}

extension EnvironmentValues {
    var dependencyContainer: DependencyContainer? {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {
    /// Inject the dependency container into the environment
    func environment(container: DependencyContainer) -> some View {
        self.environment(\.dependencyContainer, container)
    }
}
