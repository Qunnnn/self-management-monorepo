//
//  NotesUseCase.swift
//  self-management
//
//  LEARNING: Use Case (Interactor)
//
//  WHAT IS A USE CASE?
//  - Contains business logic for a specific action
//  - Orchestrates operations between entities and repositories
//  - Single Responsibility: one use case = one business action
//
//  WHY USE CASES?
//  - Keep business logic out of ViewModels/Views
//  - Reusable across different UI contexts
//  - Easy to test in isolation
//  - Follows Single Responsibility Principle (SOLID's "S")
//

import Foundation

/// Use case for managing notes
/// Contains all business logic related to notes
final class NotesUseCase {

    // MARK: - Dependencies

    private let repository: NotesRepositoryProtocol

    // MARK: - Initialization

    init(repository: NotesRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Use Case Methods

    /// Get all notes sorted by pinned status and update date
    /// - Returns: Sorted array of notes
    func getAllNotes() async -> [Note] {
        let notes = await repository.getAllNotes()
        return sortNotes(notes)
    }

    /// Create a new note
    /// - Parameters:
    ///   - title: Note title
    ///   - content: Note content
    ///   - colorTag: Optional color tag
    /// - Returns: The created note
    @discardableResult
    func createNote(title: String, content: String = "", colorTag: NoteColor = .none) async -> Note {
        let note = Note(
            title: title,
            content: content,
            colorTag: colorTag
        )
        await repository.saveNote(note)
        return note
    }

    /// Update an existing note
    /// - Parameter note: The note with updated values
    func updateNote(_ note: Note) async {
        let updatedNote = note.updated()
        await repository.updateNote(updatedNote)
    }

    /// Toggle pin status of a note
    /// - Parameter note: The note to toggle
    /// - Returns: The updated note
    @discardableResult
    func togglePin(_ note: Note) async -> Note {
        let updatedNote = note.updated(isPinned: !note.isPinned)
        await repository.updateNote(updatedNote)
        return updatedNote
    }

    /// Delete a single note
    /// - Parameter note: The note to delete
    func deleteNote(_ note: Note) async {
        await repository.deleteNote(by: note.id)
    }

    /// Delete multiple notes
    /// - Parameter notes: Array of notes to delete
    func deleteNotes(_ notes: [Note]) async {
        let ids = notes.map { $0.id }
        await repository.deleteNotes(by: ids)
    }

    /// Search notes by title or content
    /// - Parameter query: Search query string
    /// - Returns: Filtered and sorted notes
    func searchNotes(query: String) async -> [Note] {
        let notes = await repository.getAllNotes()
        guard !query.isEmpty else {
            return sortNotes(notes)
        }

        let lowercasedQuery = query.lowercased()
        let filtered = notes.filter { note in
            note.title.lowercased().contains(lowercasedQuery) ||
            note.content.lowercased().contains(lowercasedQuery)
        }
        return sortNotes(filtered)
    }

    // MARK: - Private Helpers

    /// Sort notes: pinned first, then by update date (newest first)
    private func sortNotes(_ notes: [Note]) -> [Note] {
        notes.sorted { first, second in
            if first.isPinned != second.isPinned {
                return first.isPinned
            }
            return first.updatedAt > second.updatedAt
        }
    }
}
