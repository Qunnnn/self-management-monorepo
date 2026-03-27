//
//  DependencyContainer.swift
//  self-management
//
//  LEARNING: Dependency Injection Container
//

import SwiftUI

/// Main dependency container for the application
/// Uses @Observable macro for automatic SwiftUI updates
@Observable
final class DependencyContainer {

    // MARK: - Core Services
    
    /// Global session and authentication state
    let sessionService: SessionService
    
    /// Client for public endpoints (no auth)
    let publicApiClient: APIClientProtocol
    
    /// Client for protected endpoints (uses AuthInterceptor)
    let authenticatedApiClient: APIClientProtocol

    // MARK: - Repositories

    /// Diary repository for CRUD operations on diary entries
    let diaryRepository: DiaryRepositoryProtocol
    
    /// Auth repository for authentication operations
    let authRepository: AuthRepositoryProtocol
    
    /// Tasks repository for CRUD operations on tasks
    let taskRepository: TaskRepositoryProtocol

    // MARK: - Use Cases (Diary)

    let fetchDiaryEntriesUseCase: FetchDiaryEntriesUseCase
    let createDiaryEntryUseCase: CreateDiaryEntryUseCase
    let updateDiaryEntryUseCase: UpdateDiaryEntryUseCase
    let deleteDiaryEntryUseCase: DeleteDiaryEntryUseCase
    let togglePinUseCase: TogglePinUseCase

    // MARK: - Use Cases (Auth)

    let loginUseCase: LoginUseCase
    let fetchCurrentUserUseCase: FetchCurrentUserUseCase
    
    // MARK: - Use Cases (Tasks)

    let fetchTasksUseCase: FetchTasksUseCase
    let createTaskUseCase: CreateTaskUseCase
    let completeTaskUseCase: CompleteTaskUseCase
    let deleteTaskUseCase: DeleteTaskUseCase

    // MARK: - Initialization

    init() {
        // Initialize Core Services first
        self.sessionService = SessionService()
        
        // 1. Create the Public Client
        self.publicApiClient = APIClient()
        
        // 2. Create the Authenticated Client with the Interceptor
        let authInterceptor = AuthInterceptor()
        self.authenticatedApiClient = APIClient(interceptor: authInterceptor)
        
        // Initialize repositories
        let diaryRepo = DiaryRepository()
        self.diaryRepository = diaryRepo
        
        let authRepo = AuthRepository(apiClient: self.publicApiClient)
        self.authRepository = authRepo
        
        let taskRepo = TaskRepository(apiClient: self.authenticatedApiClient)
        self.taskRepository = taskRepo

        // --- Use Cases Setup ---
        
        // Diary
        self.fetchDiaryEntriesUseCase = FetchDiaryEntriesUseCase(repository: diaryRepo)
        self.createDiaryEntryUseCase = CreateDiaryEntryUseCase(repository: diaryRepo)
        self.updateDiaryEntryUseCase = UpdateDiaryEntryUseCase(repository: diaryRepo)
        self.deleteDiaryEntryUseCase = DeleteDiaryEntryUseCase(repository: diaryRepo)
        self.togglePinUseCase = TogglePinUseCase(repository: diaryRepo)
        
        // Auth
        self.loginUseCase = LoginUseCase(repository: authRepo)
        self.fetchCurrentUserUseCase = FetchCurrentUserUseCase(repository: authRepo)
        
        // Tasks
        self.fetchTasksUseCase = FetchTasksUseCase(repository: taskRepo)
        self.createTaskUseCase = CreateTaskUseCase(repository: taskRepo)
        self.completeTaskUseCase = CompleteTaskUseCase(repository: taskRepo)
        self.deleteTaskUseCase = DeleteTaskUseCase(repository: taskRepo)
    }
}

// MARK: - Environment Key

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
    func environment(container: DependencyContainer) -> some View {
        self.environment(\.dependencyContainer, container)
    }
}
