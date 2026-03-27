//
//  DiaryRepositoryProtocol.swift
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

/// Protocol defining all diary-related data operations
/// Domain layer defines the contract, Data layer implements it
protocol DiaryRepositoryProtocol {

    // MARK: - Read Operations

    /// Fetch all diary entries
    /// - Returns: Array of all diary entries
    func getAllEntries() async -> [DiaryEntry]

    /// Fetch a single diary entry by ID
    /// - Parameter id: The entry's unique identifier
    /// - Returns: The entry if found, nil otherwise
    func getEntry(by id: UUID) async -> DiaryEntry?

    // MARK: - Write Operations

    /// Save a new diary entry
    /// - Parameter entry: The entry to save
    func saveEntry(_ entry: DiaryEntry) async

    /// Update an existing diary entry
    /// - Parameter entry: The entry with updated values
    func updateEntry(_ entry: DiaryEntry) async

    /// Delete a diary entry by ID
    /// - Parameter id: The entry's unique identifier
    func deleteEntry(by id: UUID) async

    // MARK: - Batch Operations

    /// Delete multiple diary entries
    /// - Parameter ids: Array of entry IDs to delete
    func deleteEntries(by ids: [UUID]) async
}
