//
//  NotesRepositoryProtocol.swift
//  self-management
//
//  LEARNING: Repository Protocol (Interface)
//
//  WHY USE PROTOCOLS?
//  - Defines WHAT operations are available, not HOW they work
//  - Allows swapping implementations (memory, database, API)
//  - Essential for testing (mock implementations)
//  - Follows Interface Segregation Principle (SOLID's "I")
//  - Follows Dependency Inversion Principle (SOLID's "D")
//
//  RULE: This protocol lives in DOMAIN layer
//  The implementation lives in DATA layer
//

import Foundation

/// Protocol defining all note-related data operations
/// Domain layer defines the contract, Data layer implements it
protocol NotesRepositoryProtocol {

    // MARK: - Read Operations

    /// Fetch all notes
    /// - Returns: Array of all notes
    func getAllNotes() async -> [Note]

    /// Fetch a single note by ID
    /// - Parameter id: The note's unique identifier
    /// - Returns: The note if found, nil otherwise
    func getNote(by id: UUID) async -> Note?

    // MARK: - Write Operations

    /// Save a new note
    /// - Parameter note: The note to save
    func saveNote(_ note: Note) async

    /// Update an existing note
    /// - Parameter note: The note with updated values
    func updateNote(_ note: Note) async

    /// Delete a note by ID
    /// - Parameter id: The note's unique identifier
    func deleteNote(by id: UUID) async

    // MARK: - Batch Operations

    /// Delete multiple notes
    /// - Parameter ids: Array of note IDs to delete
    func deleteNotes(by ids: [UUID]) async
}
