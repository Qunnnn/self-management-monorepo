//
//  CompleteTaskUseCase.swift
//  self-management
//
//  LEARNING: Specific Action Use Case (Tasks)
//

import Foundation

/// Use case handles marking a task as complete.
final class CompleteTaskUseCase {

    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    /// Marks a specific task as complete.
    /// - Parameter taskId: The UUID of the task to complete.
    /// - Returns: An updated TodoTask entity.
    func execute(taskId: UUID) async throws -> TodoTask {
        return try await repository.completeTask(by: taskId)
    }
}
