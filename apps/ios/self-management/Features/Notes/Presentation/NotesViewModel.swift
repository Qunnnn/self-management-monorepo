//
//  NotesViewModel.swift
//  self-management
//
//  LEARNING: ViewModel (MVVM Pattern)
//
//  WHAT IS A VIEWMODEL?
//  - Bridge between View and Business Logic
//  - Holds UI state
//  - Transforms data for display
//  - Handles user interactions
//
//  WHY USE VIEWMODEL?
//  - Keeps Views simple and focused on UI
//  - Makes business logic testable
//  - Separation of concerns
//

import SwiftUI

/// ViewModel for Notes feature
/// Uses @Observable macro for automatic SwiftUI updates
@Observable
final class NotesViewModel {

    // MARK: - Dependencies

    private let useCase: NotesUseCase

    // MARK: - State

    /// All notes to display
    var notes: [Note] = []

    /// Search query for filtering notes
    var searchQuery: String = ""

    /// Currently selected note for detail view
    var selectedNote: Note?

    /// Loading state
    var isLoading: Bool = false

    /// Error message if something went wrong
    var errorMessage: String?

    // MARK: - Computed Properties

    /// Filtered notes based on search query
    var filteredNotes: [Note] {
        guard !searchQuery.isEmpty else { return notes }
        let query = searchQuery.lowercased()
        return notes.filter { note in
            note.title.lowercased().contains(query) ||
            note.content.lowercased().contains(query)
        }
    }

    /// Pinned notes
    var pinnedNotes: [Note] {
        filteredNotes.filter { $0.isPinned }
    }

    /// Unpinned notes
    var unpinnedNotes: [Note] {
        filteredNotes.filter { !$0.isPinned }
    }

    // MARK: - Initialization

    init(useCase: NotesUseCase) {
        self.useCase = useCase
    }

    // MARK: - Actions

    /// Load all notes
    @MainActor
    func loadNotes() async {
        isLoading = true
        errorMessage = nil

        notes = await useCase.getAllNotes()

        isLoading = false
    }

    /// Create a new note
    @MainActor
    func createNote(title: String, content: String = "") async {
        await useCase.createNote(title: title, content: content)
        await loadNotes()
    }

    /// Update an existing note
    @MainActor
    func updateNote(_ note: Note) async {
        await useCase.updateNote(note)
        await loadNotes()
    }

    /// Toggle pin status
    @MainActor
    func togglePin(_ note: Note) async {
        await useCase.togglePin(note)
        await loadNotes()
    }

    /// Delete a note
    @MainActor
    func deleteNote(_ note: Note) async {
        await useCase.deleteNote(note)
        await loadNotes()
    }

    /// Delete multiple notes
    @MainActor
    func deleteNotes(_ notes: [Note]) async {
        await useCase.deleteNotes(notes)
        await loadNotes()
    }
}
