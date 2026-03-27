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

    /// Creates a new task for the user.
    /// - Parameters:
    ///   - title: The title of the task.
    ///   - description: An optional description.
    ///   - userId: The ID of the creating user.
    /// - Returns: The newly created TodoTask entity.
    func execute(title: String, description: String? = nil, for userId: String) async throws -> TodoTask {
        // Business Rule: A task cannot have an empty title.
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw NSError(domain: "CreateTaskUseCase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Task title cannot be empty"])
        }
        
        guard let userUUID = UUID(uuidString: userId) else {
            throw NSError(domain: "CreateTaskUseCase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid User ID format"])
        }
        
        return try await repository.createTask(title: title, description: description, for: userUUID)
    }
}
