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
            let entry = try await createUseCase.execute(title: title, content: content)
            withAnimation {
                entries.insert(entry, at: 0)
            }
        } catch {
            errorMessage = "Failed to create diary entry."
        }
    }

    @MainActor
    func updateEntry(_ entry: DiaryEntry) async {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        
        // Optimistic update
        let originalEntry = entries[index]
        withAnimation {
            entries[index] = entry
        }
        
        do {
            let updatedEntry = try await updateUseCase.execute(entry: entry)
            // Update with actual data from backend
            if let newIndex = entries.firstIndex(where: { $0.id == updatedEntry.id }) {
                entries[newIndex] = updatedEntry
            }
        } catch {
            // Rollback
            withAnimation {
                entries[index] = originalEntry
            }
            errorMessage = "Failed to update diary entry."
        }
    }

    @MainActor
    func togglePin(_ entry: DiaryEntry) async {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        
        // Optimistic update
        let originalEntry = entries[index]
        let targetPinnedState = !originalEntry.isPinned
        
        // Apple Notes simply snaps/updates the list natively without custom spring animations or delays.
        // Update the state instantly and let SwiftUI List handle the default structural change.
        entries[index].isPinned = targetPinnedState
        
        do {
            let updatedEntry = try await togglePinUseCase.execute(entry: entry)
            
            // Sync with backend ONLY if something changed unexpectedly or it's a significant data update.
            // If the pin state is already what we expect, we skip the immediate re-assignment 
            // to avoid interrupting the active List animation which causes 'blur cards'.
            if let newIndex = entries.firstIndex(where: { $0.id == updatedEntry.id }) {
                if entries[newIndex].isPinned != updatedEntry.isPinned {
                    entries[newIndex] = updatedEntry
                } else {
                    // Update metadata silently without full row re-rendering if possible
                    // In SwiftUI @Observable, this still triggers, but skipping it for now 
                    // is safer against flickers unless we really need the updatedAt immediately.
                    // entries[newIndex] = updatedEntry // Uncomment if metadata sync is critical
                }
            }
        } catch {
            // Rollback on failure
            if let rollbackIndex = entries.firstIndex(where: { $0.id == entry.id }) {
                entries[rollbackIndex] = originalEntry
            }
            errorMessage = "Failed to pin/unpin entry."
        }
    }

    @MainActor
    func deleteEntry(_ entry: DiaryEntry) async {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        
        // Optimistic delete
        let originalEntry = entries[index]
        let originalIndex = index
        
        _ = withAnimation {
            entries.remove(at: index)
        }
        
        do {
            try await deleteUseCase.execute(entry: entry)
        } catch {
            // Rollback
            withAnimation {
                entries.insert(originalEntry, at: originalIndex)
            }
            errorMessage = "Failed to delete diary entry."
        }
    }

    @MainActor
    func deleteEntries(_ entriesToDelete: [DiaryEntry]) async {
        let originalEntries = entries
        
        withAnimation {
            entries.removeAll { entry in
                entriesToDelete.contains(where: { $0.id == entry.id })
            }
        }
        
        do {
            try await deleteUseCase.execute(entries: entriesToDelete)
        } catch {
            // Rollback
            withAnimation {
                entries = originalEntries
            }
            errorMessage = "Failed to delete diary entries."
        }
    }
}
