//
//  DiaryStatus+SwiftUI.swift
//  self-management
//
//  Extension for mapping DiaryStatus to SwiftUI Colors.
//

import SwiftUI

extension DiaryStatus {
    /// Maps DiaryStatus to a thematic color for UI indicators.
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
