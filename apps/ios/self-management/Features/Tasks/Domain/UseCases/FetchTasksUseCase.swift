//
//  FetchTasksUseCase.swift
//  self-management
//
//  LEARNING: Single-Action Use Case (Tasks)
//

import Foundation

/// Use case for fetching tasks.
final class FetchTasksUseCase {

    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    /// Fetches all active tasks for the current authenticated user.
    /// - Parameters:
    ///   - completed: Optional filter for completed/incomplete tasks.
    ///   - limit: Optional limit for the number of results.
    ///   - offset: Optional skip for the results.
    /// - Returns: An array of TodoTask entities.
    func execute(completed: Bool? = nil, limit: Int? = nil, offset: Int? = nil) async throws -> [TodoTask] {
        return try await repository.fetchTasks(completed: completed, limit: limit, offset: offset)
    }

    /// Fetches a single task by ID.
    /// - Parameter taskId: The UUID of the task.
    /// - Returns: A TodoTask if found, otherwise nil.
    func fetchById(taskId: UUID) async throws -> TodoTask? {
        return try await repository.fetchTask(by: taskId)
    }
}
