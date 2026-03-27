//
//  DeleteDiaryEntryUseCase.swift
//  self-management
//
//  LEARNING: Delete Action Use Case
//

import Foundation

/// Use case for deleting a single diary entry or multiple diary entries.
final class DeleteDiaryEntryUseCase {

    private let repository: DiaryRepositoryProtocol

    init(repository: DiaryRepositoryProtocol) {
        self.repository = repository
    }

    /// Deletes a single diary entry from the repository.
    /// - Parameter entry: The diary entry to delete.
    func execute(entry: DiaryEntry) async throws {
        try await repository.deleteEntry(by: entry.id)
    }

    /// Deletes multiple diary entries from the repository.
    /// - Parameter entries: Array of diary entries to delete.
    func execute(entries: [DiaryEntry]) async throws {
        let ids = entries.map { $0.id }
        try await repository.deleteEntries(by: ids)
    }
}
