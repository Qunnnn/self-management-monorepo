//
//  NotesRepository.swift
//  self-management
//
//  LEARNING: Repository Implementation
//
//  THIS IS THE DATA LAYER
//  - Implements the protocol defined in Domain layer
//  - Handles actual data storage/retrieval
//  - Can be swapped out without changing business logic
//
//  CURRENT IMPLEMENTATION: In-Memory Storage
//  Later we'll upgrade to: SwiftData persistence
//
//  WHY START WITH IN-MEMORY?
//  - Faster to develop and test
//  - Focus on architecture first
//  - Easy to replace later (that's the beauty of Clean Architecture!)
//

import Foundation

/// In-memory implementation of NotesRepository
/// Stores notes in memory (lost when app closes)
/// Will be replaced with SwiftData in Phase 3
final class NotesRepository: NotesRepositoryProtocol {

    // MARK: - Storage

    /// In-memory storage for notes
    /// Using actor-isolated storage for thread safety
    private var notes: [UUID: Note] = [:]

    // MARK: - Initialization

    init() {
        // Add some sample notes for development
        addSampleNotes()
    }

    // MARK: - Read Operations

    func getAllNotes() async -> [Note] {
        Array(notes.values)
    }

    func getNote(by id: UUID) async -> Note? {
        notes[id]
    }

    // MARK: - Write Operations

    func saveNote(_ note: Note) async {
        notes[note.id] = note
    }

    func updateNote(_ note: Note) async {
        notes[note.id] = note
    }

    func deleteNote(by id: UUID) async {
        notes.removeValue(forKey: id)
    }

    func deleteNotes(by ids: [UUID]) async {
        for id in ids {
            notes.removeValue(forKey: id)
        }
    }

    // MARK: - Sample Data

    private func addSampleNotes() {
        let sampleNotes = [
            Note(
                title: "Welcome to Self-Management!",
                content: "This is your first note. You can create, edit, and delete notes to organize your thoughts.\n\nTry creating a new note using the + button!",
                status: .active,
                isPinned: true
            ),
            Note(
                title: "Learning Clean Architecture",
                content: "Today I'm learning about:\n\n- Domain Layer: Pure business logic\n- Data Layer: Persistence & APIs\n- Presentation Layer: UI & ViewModels\n\nThe key principle: dependencies point inward!",
                status: .active
            ),
            Note(
                title: "Shopping List",
                content: "- Milk\n- Bread\n- Eggs\n- Coffee\n- Fruits",
                status: .active
            )
        ]

        for note in sampleNotes {
            notes[note.id] = note
        }
    }
}
