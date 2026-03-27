//
//  TaskRepositoryProtocol.swift
//  self-management
//
//  LEARNING: Repository Pattern (Tasks)
//

import Foundation

/// Protocol defining operations for managing tasks
/// This is the "port" in Hexagonal Architecture
protocol TaskRepositoryProtocol: AnyObject {
    
    // MARK: - Read Operations
    
    /// Fetches all active tasks
    /// - Parameters:
    ///   - completed: Filter by completed status (optional)
    ///   - limit: Number of tasks to fetch (optional)
    ///   - offset: Number of tasks to skip (optional)
    func fetchTasks(completed: Bool?, limit: Int?, offset: Int?) async throws -> [TodoTask]
    
    /// Fetches a single task by ID
    /// - Parameter id: The ID of the task to fetch
    func fetchTask(by id: UUID) async throws -> TodoTask?
    
    // MARK: - Write Operations
    
    /// Creates a new task for the authenticated user
    /// - Parameter title: Title of the task
    /// - Parameter description: Optional description of the task
    func createTask(title: String, description: String?) async throws -> TodoTask
    
    /// Marks a task as complete
    /// - Parameter id: The ID of the task to mark as complete
    func completeTask(by id: UUID) async throws -> TodoTask
    
    /// Deletes a task
    /// - Parameter id: The ID of the task to delete
    func deleteTask(by id: UUID) async throws -> Void
}
