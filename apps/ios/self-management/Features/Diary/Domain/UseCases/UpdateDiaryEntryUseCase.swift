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

    @discardableResult
    func execute(entry: DiaryEntry) async throws -> DiaryEntry {
        let updatedEntry = entry.updated()
        try await repository.updateEntry(updatedEntry)
        return updatedEntry
    }
}
