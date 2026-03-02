//
//  NoteColor+SwiftUI.swift
//  self-management
//
//  LEARNING: Extensions
//
//  WHY USE EXTENSIONS?
//  - Add functionality to existing types
//  - Keep domain models pure (no SwiftUI in Domain layer)
//  - Single Responsibility: each file has one purpose
//
//  This extension adds SwiftUI Color mapping to NoteColor
//  The domain entity stays pure, UI-specific code lives here
//

import SwiftUI

extension NoteColor {

    /// Convert NoteColor to SwiftUI Color
    var color: Color {
        switch self {
        case .none: return .clear
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        }
    }
}
