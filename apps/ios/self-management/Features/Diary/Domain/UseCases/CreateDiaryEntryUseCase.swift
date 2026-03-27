//
//  CreateDiaryEntryUseCase.swift
//  self-management
//
//  LEARNING: Create Action Use Case
//

import Foundation

/// Use case for creating a new diary entry.
final class CreateDiaryEntryUseCase {

    private let repository: DiaryRepositoryProtocol

    init(repository: DiaryRepositoryProtocol) {
        self.repository = repository
    }

    /// Creates a new diary entry and saves it to the repository.
    /// - Parameters:
    ///   - title: Title of the diary entry.
    ///   - content: Content of the diary entry.
    @discardableResult
    func execute(title: String, content: String = "") async throws -> DiaryEntry {
        // Business Rule: A diary entry with an empty title can be named "Untitled" if needed 
        // (already handled in view model, but good to have here too)
        let entryTitle = title.trimmingCharacters(in: .whitespaces).isEmpty ? "Untitled" : title

        let entry = DiaryEntry(
            title: entryTitle,
            content: content
        )
        try await repository.saveEntry(entry)
        return entry
    }
}
