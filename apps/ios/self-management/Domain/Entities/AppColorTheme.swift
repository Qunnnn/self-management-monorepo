//
//  AppColorTheme.swift
//  self-management
//
//  LEARNING: Shared Domain Value Object
//
//  This represents the available semantic themes across the entire application.
//  Using semantic types (like .important or .warning) instead of literal colors
//  (like .red) keeps the domain focused on business meaning rather than presentation.
//

import Foundation

/// Application-wide semantic theme options
/// Used to represent status or severity that map to colors in the UI layer
public enum AppColorTheme: String, CaseIterable, Codable {
    case none
    case primary
    case secondary
    case success
    case warning
    case error
    case info

    /// Display name for the theme
    var displayName: String {
        switch self {
        case .none: return "None"
        case .primary: return "Primary"
        case .secondary: return "Secondary"
        case .success: return "Success"
        case .warning: return "Warning"
        case .error: return "Error"
        case .info: return "Info"
        }
    }
}
