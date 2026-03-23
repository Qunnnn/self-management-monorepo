//
//  NoteStatus+SwiftUI.swift
//  self-management
//
//  Extension for mapping NoteStatus to SwiftUI Colors.
//

import SwiftUI

extension NoteStatus {
    /// Maps NoteStatus to a thematic color for UI indicators.
    var color: Color {
        switch self {
        case .active:
            return AppDesignSystem.colors.primary
        case .archived:
            return AppDesignSystem.colors.textTertiary
        case .draft:
            return AppDesignSystem.colors.warning
        }
    }
}
