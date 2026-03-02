//
//  Note.swift
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

/// Represents a note in the self-management system
/// This is a Domain Entity - pure business logic only
struct Note: Identifiable, Equatable {

    // MARK: - Properties

    /// Unique identifier for the note
    let id: UUID

    /// Title of the note
    var title: String

    /// Content/body of the note
    var content: String

    /// When the note was created
    let createdAt: Date

    /// When the note was last modified
    var updatedAt: Date

    /// Color tag for visual organization
    var colorTag: NoteColor

    /// Whether the note is pinned to top
    var isPinned: Bool

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        title: String,
        content: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        colorTag: NoteColor = .none,
        isPinned: Bool = false
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.colorTag = colorTag
        self.isPinned = isPinned
    }

    // MARK: - Business Logic

    /// Check if the note is empty (no title and no content)
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
    func updated(title: String? = nil, content: String? = nil, colorTag: NoteColor? = nil, isPinned: Bool? = nil) -> Note {
        Note(
            id: self.id,
            title: title ?? self.title,
            content: content ?? self.content,
            createdAt: self.createdAt,
            updatedAt: Date(),
            colorTag: colorTag ?? self.colorTag,
            isPinned: isPinned ?? self.isPinned
        )
    }
}

// MARK: - Note Color

/// Available colors for note organization
enum NoteColor: String, CaseIterable, Codable {
    case none
    case red
    case orange
    case yellow
    case green
    case blue
    case purple

    /// Display name for the color
    var displayName: String {
        switch self {
        case .none: return "None"
        case .red: return "Red"
        case .orange: return "Orange"
        case .yellow: return "Yellow"
        case .green: return "Green"
        case .blue: return "Blue"
        case .purple: return "Purple"
        }
    }
}
