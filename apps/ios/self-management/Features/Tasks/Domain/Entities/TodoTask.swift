//
//  TodoTask.swift
//  self-management
//
//  LEARNING: Domain Entity (Tasks)
//

import Foundation

/// Represents a task in the self-management system
/// This is a Domain Entity - pure business logic only
struct TodoTask: Identifiable, Equatable {

    // MARK: - Properties

    /// Unique identifier for the task
    let id: UUID

    /// ID of the user who owns the task
    let userId: UUID

    /// Title of the task
    var title: String

    /// Optional description of the task
    var description: String?

    /// Whether the task is completed
    var isCompleted: Bool

    /// When the task was created
    let createdAt: Date

    /// When the task was deleted (soft delete)
    let deletedAt: Date?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        userId: UUID,
        title: String,
        description: String? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        deletedAt: Date? = nil
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.deletedAt = deletedAt
    }

    // MARK: - Business Logic

    /// Marks the task as completed
    func completed() -> TodoTask {
        TodoTask(
            id: id,
            userId: userId,
            title: title,
            description: description,
            isCompleted: true,
            createdAt: createdAt,
            deletedAt: deletedAt
        )
    }
}
