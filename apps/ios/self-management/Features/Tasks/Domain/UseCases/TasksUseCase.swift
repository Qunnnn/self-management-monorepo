//
//  TasksUseCase.swift
//  self-management
//
//  LEARNING: Use Case Pattern (Tasks)
//

import Foundation

/// Use case handles the business logic for managing tasks.
/// Decouples the presentation layer from the repository's underlying data storage mechanism.
final class TasksUseCase {
    
    // MARK: - Properties
    
    private let repository: TaskRepositoryProtocol
    
    // MARK: - Initialization
    
    /// Initializes a TasksUseCase with a specific repository.
    /// - Parameter repository: An object conforming to TaskRepositoryProtocol.
    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Business Logic Methods
    
    /// Fetches all active tasks for the current user.
    /// - Parameters:
    ///   - userId: The ID of the user whose tasks to fetch.
    ///   - completed: Optional filter for completed/incomplete tasks.
    ///   - limit: Optional limit for the number of results.
    ///   - offset: Optional skip for the results.
    /// - Returns: An array of TodoTask entities.
    func getTasks(for userId: String, completed: Bool? = nil, limit: Int? = nil, offset: Int? = nil) async throws -> [TodoTask] {
        guard let userUUID = UUID(uuidString: userId) else {
            throw NSError(domain: "TasksUseCase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid User ID format"])
        }
        return try await repository.fetchTasks(for: userUUID, completed: completed, limit: limit, offset: offset)
    }
    
    /// Fetches a single task by ID.
    /// - Parameter taskId: The UUID of the task.
    /// - Returns: A TodoTask if found, otherwise nil.
    func getTask(by taskId: UUID) async throws -> TodoTask? {
        return try await repository.fetchTask(by: taskId)
    }
    
    /// Creates a new task for the user.
    /// - Parameters:
    ///   - title: The title of the task.
    ///   - description: An optional description.
    ///   - userId: The ID of the creating user.
    /// - Returns: The newly created TodoTask entity.
    func addTask(title: String, description: String? = nil, for userId: String) async throws -> TodoTask {
        // Business Rule: A task cannot have an empty title.
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw NSError(domain: "TasksUseCase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Task title cannot be empty"])
        }
        
        guard let userUUID = UUID(uuidString: userId) else {
            throw NSError(domain: "TasksUseCase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid User ID format"])
        }
        
        return try await repository.createTask(title: title, description: description, for: userUUID)
    }
    
    /// Marks a specific task as complete.
    /// - Parameter taskId: The UUID of the task to complete.
    /// - Returns: An updated TodoTask entity.
    func markTaskAsComplete(taskId: UUID) async throws -> TodoTask {
        return try await repository.completeTask(by: taskId)
    }
    
    /// Deletes a task by ID.
    /// - Parameter taskId: The UUID of the task to delete.
    func deleteTask(taskId: UUID) async throws {
        try await repository.deleteTask(by: taskId)
    }
}
