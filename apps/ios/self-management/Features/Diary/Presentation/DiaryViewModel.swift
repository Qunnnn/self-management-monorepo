//
//  DiaryViewModel.swift
//  self-management
//
//  LEARNING: ViewModel (MVVM Pattern)
//

import SwiftUI

/// ViewModel for Diary feature
@Observable
final class DiaryViewModel {

    // MARK: - Dependencies

    private let fetchUseCase: FetchDiaryEntriesUseCase
    private let createUseCase: CreateDiaryEntryUseCase
    private let updateUseCase: UpdateDiaryEntryUseCase
    private let deleteUseCase: DeleteDiaryEntryUseCase
    private let togglePinUseCase: TogglePinUseCase

    // MARK: - State

    var entries: [DiaryEntry] = []
    var searchQuery: String = ""
    var selectedEntry: DiaryEntry?
    var isLoading: Bool = false
    var errorMessage: String?

    // MARK: - Computed Properties

    var filteredEntries: [DiaryEntry] {
        guard !searchQuery.isEmpty else { return entries }
        let query = searchQuery.lowercased()
        return entries.filter { entry in
            entry.title.lowercased().contains(query) ||
            entry.content.lowercased().contains(query)
        }
    }

    var pinnedEntries: [DiaryEntry] {
        filteredEntries.filter { $0.isPinned }
    }

    var unpinnedEntries: [DiaryEntry] {
        filteredEntries.filter { !$0.isPinned }
    }

    // MARK: - Initialization

    init(
        fetchUseCase: FetchDiaryEntriesUseCase,
        createUseCase: CreateDiaryEntryUseCase,
        updateUseCase: UpdateDiaryEntryUseCase,
        deleteUseCase: DeleteDiaryEntryUseCase,
        togglePinUseCase: TogglePinUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.createUseCase = createUseCase
        self.updateUseCase = updateUseCase
        self.deleteUseCase = deleteUseCase
        self.togglePinUseCase = togglePinUseCase
    }

    // MARK: - Actions

    @MainActor
    func loadEntries() async {
        isLoading = true
        errorMessage = nil
        do {
            entries = try await fetchUseCase.execute()
        } catch {
            errorMessage = "Failed to load diary entries."
        }
        isLoading = false
    }

    @MainActor
    func createEntry(title: String, content: String = "") async {
        do {
            try await createUseCase.execute(title: title, content: content)
            await loadEntries()
        } catch {
            errorMessage = "Failed to create diary entry."
        }
    }

    @MainActor
    func updateEntry(_ entry: DiaryEntry) async {
        do {
            try await updateUseCase.execute(entry: entry)
            await loadEntries()
        } catch {
            errorMessage = "Failed to update diary entry."
        }
    }

    @MainActor
    func togglePin(_ entry: DiaryEntry) async {
        do {
            try await togglePinUseCase.execute(entry: entry)
            await loadEntries()
        } catch {
            errorMessage = "Failed to pin/unpin entry."
        }
    }

    @MainActor
    func deleteEntry(_ entry: DiaryEntry) async {
        do {
            try await deleteUseCase.execute(entry: entry)
            await loadEntries()
        } catch {
            errorMessage = "Failed to delete diary entry."
        }
    }

    @MainActor
    func deleteEntries(_ entries: [DiaryEntry]) async {
        do {
            try await deleteUseCase.execute(entries: entries)
            await loadEntries()
        } catch {
            errorMessage = "Failed to delete diary entries."
        }
    }
}
