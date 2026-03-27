//
//  DiaryMood.swift
//  self-management
//

import Foundation

/// Represents the emotional state associated with a diary entry.
public enum DiaryMood: String, CaseIterable, Codable {
    case happy      = "happy"
    case productive = "productive"
    case tired      = "tired"
    case neutral    = "neutral"
    
    /// Display name for the mood
    public var displayName: String {
        self.rawValue.capitalized
    }
    
    /// Emoji associated with the mood
    public var emoji: String {
        switch self {
        case .happy: return "😊"
        case .productive: return "🚀"
        case .tired: return "😴"
        case .neutral: return "😐"
        }
    }
}
