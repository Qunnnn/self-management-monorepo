//
//  UpdateDiaryEntryUseCase.swift
//  self-management
//
//  LEARNING: Update Action Use Case
//

import Foundation

/// Use case for updating an existing diary entry.
final class UpdateDiaryEntryUseCase {

    private let repository: DiaryRepositoryProtocol

    init(repository: DiaryRepositoryProtocol) {
        self.repository = repository
    }

    /// Updates an existing diary entry in the repository.
    /// - Parameter entry: The diary entry with updated values.
    func execute(entry: DiaryEntry) async throws {
        let updatedEntry = entry.updated()
        try await repository.updateEntry(updatedEntry)
    }
}
