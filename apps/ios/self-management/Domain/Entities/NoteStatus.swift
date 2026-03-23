//
//  NoteStatus.swift
//  self-management
//
//  LEARNING: Domain Value Object
//
//  This represents the lifecycle status of a note.
//  Colors and themes will be derived from this status in the UI layer
//  via extensions, keeping the entity focused on business state.
//

import Foundation

/// Represents the current status/state of a note
enum NoteStatus: String, CaseIterable, Codable {
    case active
    case archived
    case draft
    
    /// Display name for the status
    var displayName: String {
        switch self {
        case .active: return "Active"
        case .archived: return "Archived"
        case .draft: return "Draft"
        }
    }
}
