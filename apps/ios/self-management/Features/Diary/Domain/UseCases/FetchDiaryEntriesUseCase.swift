//
//  FetchDiaryEntriesUseCase.swift
//  self-management
//
//  LEARNING: Single-Action Use Case
//

import Foundation

/// Use case for fetching and sorting diary entries.
final class FetchDiaryEntriesUseCase {

    private let repository: DiaryRepositoryProtocol

    init(repository: DiaryRepositoryProtocol) {
        self.repository = repository
    }

    /// Fetches all diary entries sorted by pinned status and update date.
    /// - Returns: Sorted array of diary entries.
    func execute() async throws -> [DiaryEntry] {
        let entries = try await repository.getAllEntries()
        return sortEntries(entries)
    }

    /// Search diary entries by title or content.
    /// - Parameter query: Search query string.
    /// - Returns: Filtered and sorted entries.
    func search(query: String) async throws -> [DiaryEntry] {
        let entries = try await repository.getAllEntries()
        guard !query.isEmpty else {
            return sortEntries(entries)
        }

        let lowercasedQuery = query.lowercased()
        let filtered = entries.filter { entry in
            entry.title.lowercased().contains(lowercasedQuery) ||
            entry.content.lowercased().contains(lowercasedQuery)
        }
        return sortEntries(filtered)
    }

    private func sortEntries(_ entries: [DiaryEntry]) -> [DiaryEntry] {
        entries.sorted { first, second in
            if first.isPinned != second.isPinned {
                return first.isPinned
            }
            return first.updatedAt > second.updatedAt
        }
    }
}
