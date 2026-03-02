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

    // MARK: - Repositories

    /// Notes repository for CRUD operations on notes
    let notesRepository: NotesRepositoryProtocol

    // MARK: - Use Cases

    /// Use case for managing notes
    let notesUseCase: NotesUseCase

    // MARK: - Initialization

    init() {
        // Initialize repositories first
        let notesRepo = NotesRepository()
        self.notesRepository = notesRepo

        // Then initialize use cases with their dependencies
        self.notesUseCase = NotesUseCase(repository: notesRepo)
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
    func environment(_ container: DependencyContainer) -> some View {
        self.environment(\.dependencyContainer, container)
    }
}
