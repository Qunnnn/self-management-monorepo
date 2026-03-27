//
//  DiaryRepository.swift
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

import Foundation

/// In-memory implementation of DiaryRepository
/// Stores diary entries in memory (lost when app closes)
final class DiaryRepository: DiaryRepositoryProtocol {

    // MARK: - Storage

    /// In-memory storage for diary entries
    private var entries: [UUID: DiaryEntry] = [:]

    // MARK: - Initialization

    init() {
        // Add some sample entries for development
        addSampleEntries()
    }

    // MARK: - Read Operations

    func getAllEntries() async -> [DiaryEntry] {
        Array(entries.values)
    }

    func getEntry(by id: UUID) async -> DiaryEntry? {
        entries[id]
    }

    // MARK: - Write Operations

    func saveEntry(_ entry: DiaryEntry) async {
        entries[entry.id] = entry
    }

    func updateEntry(_ entry: DiaryEntry) async {
        entries[entry.id] = entry
    }

    func deleteEntry(by id: UUID) async {
        entries.removeValue(forKey: id)
    }

    func deleteEntries(by ids: [UUID]) async {
        for id in ids {
            entries.removeValue(forKey: id)
        }
    }

    // MARK: - Sample Data

    private func addSampleEntries() {
        let sampleEntries = [
            DiaryEntry(
                title: "Welcome to your Diary!",
                content: "This is your first diary entry. You can create, edit, and delete entries to organize your thoughts.\n\nTry creating a new entry using the + button!",
                status: .active,
                isPinned: true
            ),
            DiaryEntry(
                title: "Learning Clean Architecture",
                content: "Today I'm learning about:\n\n- Domain Layer: Pure business logic\n- Data Layer: Persistence & APIs\n- Presentation Layer: UI & ViewModels\n\nThe key principle: dependencies point inward!",
                status: .active
            ),
            DiaryEntry(
                title: "Morning Routine",
                content: "- Meditation\n- Exercise\n- Healthy Breakfast\n- Planning the day",
                status: .active
            )
        ]

        for entry in sampleEntries {
            entries[entry.id] = entry
        }
    }
}
