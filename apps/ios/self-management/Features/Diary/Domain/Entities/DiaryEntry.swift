//
//  DiaryEntry.swift
//  self-management
//
//  LEARNING: Domain Entity
//
//  WHAT IS AN ENTITY?
//  - Pure business object with no dependencies
//  - Represents a concept in your business domain
//  - Contains business rules and validation
//
//  RULES:
//  - NO UI code (no SwiftUI imports)
//  - NO persistence code (no SwiftData)
//  - NO network code
//  - Just pure Swift data structures
//

import Foundation

/// Represents a diary entry in the self-management system
/// This is a Domain Entity - pure business logic only
struct DiaryEntry: Identifiable, Equatable {

    // MARK: - Properties

    /// Unique identifier for the diary entry
    let id: UUID

    /// Title of the diary entry
    var title: String

    /// Content/body of the diary entry
    var content: String

    /// When the diary entry was created
    let createdAt: Date

    /// When the diary entry was last modified
    var updatedAt: Date

    /// Whether the diary entry is pinned to top
    var isPinned: Bool

    /// Mood of the entry (e.g., "productive", "tired", "happy")
    var mood: DiaryMood?

    /// Latitude of where the entry was created
    var latitude: Double?

    /// Longitude of where the entry was created
    var longitude: Double?

    /// Attachments associated with the entry
    var attachments: [DiaryAttachment]

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        title: String,
        content: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isPinned: Bool = false,
        mood: DiaryMood? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        attachments: [DiaryAttachment] = []
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isPinned = isPinned
        self.mood = mood
        self.latitude = latitude
        self.longitude = longitude
        self.attachments = attachments
    }

    // MARK: - Business Logic

    /// Check if the diary entry is empty (no title and no content)
    var isEmpty: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Get a preview of the content (first 100 characters)
    var preview: String {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count <= 100 {
            return trimmed
        }
        return String(trimmed.prefix(100)) + "..."
    }

    /// Create an updated copy with new modification date
    func updated(
        title: String? = nil,
        content: String? = nil,
        isPinned: Bool? = nil,
        mood: DiaryMood? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        attachments: [DiaryAttachment]? = nil
    ) -> DiaryEntry {
        DiaryEntry(
            id: self.id,
            title: title ?? self.title,
            content: content ?? self.content,
            createdAt: self.createdAt,
            updatedAt: Date(),
            isPinned: isPinned ?? self.isPinned,
            mood: mood ?? self.mood,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            attachments: attachments ?? self.attachments
        )
    }
}
