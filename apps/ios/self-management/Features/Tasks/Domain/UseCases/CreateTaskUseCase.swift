//
//  CreateTaskUseCase.swift
//  self-management
//
//  LEARNING: Create Action Use Case (Tasks)
//

import Foundation

/// Use case handles creating a new task.
final class CreateTaskUseCase {

    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    /// Creates a new task for the currently authenticated user.
    /// - Parameters:
    ///   - title: The title of the task.
    ///   - description: An optional description.
    /// - Returns: The newly created TodoTask entity.
    func execute(title: String, description: String? = nil) async throws -> TodoTask {
        // Business Rule: A task cannot have an empty title.
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw NSError(domain: "CreateTaskUseCase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Task title cannot be empty"])
        }
        
        return try await repository.createTask(title: title, description: description)
    }
}
