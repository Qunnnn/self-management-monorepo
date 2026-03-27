//
//  TogglePinUseCase.swift
//  self-management
//
//  LEARNING: Specific Action Use Case
//

import Foundation

/// Use case for toggling the pinned status of a diary entry.
final class TogglePinUseCase {

    private let repository: DiaryRepositoryProtocol

    init(repository: DiaryRepositoryProtocol) {
        self.repository = repository
    }

    /// Toggles the pinned status of a diary entry in the repository.
    /// - Parameter entry: The diary entry to toggle the pinned status for.
    /// - Returns: The updated diary entry.
    @discardableResult
    func execute(entry: DiaryEntry) async throws -> DiaryEntry {
        let updatedEntry = entry.updated(isPinned: !entry.isPinned)
        try await repository.updateEntry(updatedEntry)
        return updatedEntry
    }
}
