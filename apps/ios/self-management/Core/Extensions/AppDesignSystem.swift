//
//  AppDesignSystem.swift
//  self-management
//
//  The central design system for the application.
//  Encapsulates colors, typography, spacing, and shapes.
//

import SwiftUI

/// Main design system namespace
public struct AppDesignSystem {
    // Design system tokens are organized as static namespaces
    public static let colors = Colors()
    public static let spacing = Spacing()
    public static let typography = Typography()
    public static let shapes = Shapes()
}

// MARK: - Colors Namespace
extension AppDesignSystem {
    public struct Colors {
        /// Semantic brand colors
        public let primary = Color.appTheme.primary
        public let secondary = Color.appTheme.secondary
        
        /// Functional semantic colors
        public let success = Color.appTheme.success
        public let warning = Color.appTheme.warning
        public let error = Color.appTheme.error
        public let info = Color.appTheme.info
        
        /// UI Foundation
        public let background = Color.appTheme.background
        public let surface = Color.appTheme.surface
        public let border = Color.appTheme.border
        
        /// Text
        public let textPrimary = Color.appTheme.textPrimary
        public let textSecondary = Color.appTheme.textSecondary
        public let textTertiary = Color.appTheme.textTertiary
    }
}

// MARK: - Spacing Namespace
extension AppDesignSystem {
    public struct Spacing {
        /// Tiny: 4px
        public let xxs: CGFloat = 4
        /// Extra Small: 8px
        public let xs: CGFloat = 8
        /// Small: 12px
        public let sm: CGFloat = 12
        /// Medium (Default): 16px
        public let md: CGFloat = 16
        /// Large: 24px
        public let lg: CGFloat = 24
        /// Extra Large: 32px
        public let xl: CGFloat = 32
        /// XXL: 48px
        public let xxl: CGFloat = 48
    }
}

// MARK: - Typography Namespace
extension AppDesignSystem {
    public struct Typography {
        /// Large Title for screens
        public let titleLarge = Font.appTheme.titleLarge
        /// Regular Title
        public let title = Font.appTheme.title
        /// Small metadata
        public let caption = Font.appTheme.caption
        /// Body text
        public let body = Font.appTheme.body
    }
}

// MARK: - Shapes Namespace (Corner Radii)
extension AppDesignSystem {
    public struct Shapes {
        /// Small corner radius (8pt)
        public let small = RoundedRectangle.appTheme.radiusSmall
        /// Medium corner radius (16pt)
        public let medium = RoundedRectangle.appTheme.radiusMedium
        /// Large corner radius (24pt)
        public let large = RoundedRectangle.appTheme.radiusLarge
    }
}

// MARK: - Design System Extensions (Internal Palette)

extension Color {
    /// Minimalist Design System Color Palette (Raw Tokens)
    public enum appTheme {
        // High-contrast clean accent
        public static let primary = Color.black
        public static let secondary = Color.gray
        
        // Pure Neutrals for a clean UI
        public static let background = Color.white
        public static let surface = Color(hex: "F9F9F9")
        public static let border = Color(hex: "E5E7EB")
        
        // Refined Semantic Text Colors
        public static let textPrimary = Color(hex: "111111")
        public static let textSecondary = Color(hex: "6B7280")
        public static let textTertiary = Color(hex: "9CA3AF")
        
        // Muted status colors (less vibrant, more professional)
        public static let success = Color(hex: "27C485")
        public static let warning = Color(hex: "EAB308")
        public static let error = Color(hex: "CC2B2B")
        public static let info = Color(hex: "4B5563")  // Muted blue-grey for info
    }
}

extension Font {
    /// Minimalist Design System Typography & Colors
    public enum appTheme {
        // Large Title
        public static let titleLarge = Font.system(size: 34, weight: .bold, design: .rounded)
        public static let titleLargeColor = Color.appTheme.textPrimary
        
        // Sub-titles
        public static let title = Font.system(size: 22, weight: .semibold, design: .rounded)
        public static let titleColor = Color.appTheme.textPrimary
        
        // Main Body text
        public static let body = Font.system(size: 16, weight: .regular, design: .default)
        public static let bodyColor = Color.appTheme.textSecondary
        
        // Small Captions
        public static let caption = Font.system(size: 12, weight: .medium, design: .default)
        public static let captionColor = Color.appTheme.textTertiary
    }
}

extension RoundedRectangle {
    /// Design System Shape Tokens (Raw Tokens)
    public enum appTheme {
        public static let radiusSmall = RoundedRectangle(cornerRadius: 8, style: .continuous)
        public static let radiusMedium = RoundedRectangle(cornerRadius: 16, style: .continuous)
        public static let radiusLarge = RoundedRectangle(cornerRadius: 24, style: .continuous)
    }
}

// MARK: - Hex Utility
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
