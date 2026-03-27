//
//  DeleteTaskUseCase.swift
//  self-management
//
//  LEARNING: Delete Action Use Case (Tasks)
//

import Foundation

/// Use case handles deleting a task.
final class DeleteTaskUseCase {

    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    /// Deletes a task by ID.
    /// - Parameter taskId: The UUID of the task to delete.
    func execute(taskId: UUID) async throws {
        try await repository.deleteTask(by: taskId)
    }
}
