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
        entries = await fetchUseCase.execute()
        isLoading = false
    }

    @MainActor
    func createEntry(title: String, content: String = "") async {
        await createUseCase.execute(title: title, content: content)
        await loadEntries()
    }

    @MainActor
    func updateEntry(_ entry: DiaryEntry) async {
        await updateUseCase.execute(entry: entry)
        await loadEntries()
    }

    @MainActor
    func togglePin(_ entry: DiaryEntry) async {
        await togglePinUseCase.execute(entry: entry)
        await loadEntries()
    }

    @MainActor
    func deleteEntry(_ entry: DiaryEntry) async {
        await deleteUseCase.execute(entry: entry)
        await loadEntries()
    }

    @MainActor
    func deleteEntries(_ entries: [DiaryEntry]) async {
        await deleteUseCase.execute(entries: entries)
        await loadEntries()
    }
}
