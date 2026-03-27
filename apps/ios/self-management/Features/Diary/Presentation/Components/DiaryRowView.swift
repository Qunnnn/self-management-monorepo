//
//  DiaryRowView.swift
//  self-management
//
//  LEARNING: Reusable View Component
//

import SwiftUI

struct DiaryRowView: View {

    let entry: DiaryEntry

    var body: some View {
        HStack(spacing: AppDesignSystem.spacing.md) {
            VStack(alignment: .leading, spacing: AppDesignSystem.spacing.xxs) {
                // Title
                HStack {
                    Text(entry.title)
                        .font(AppDesignSystem.typography.title)
                        .foregroundStyle(AppDesignSystem.colors.textPrimary)
                        .lineLimit(1)

                    if entry.isPinned {
                        Image(systemName: "pin.fill")
                            .font(AppDesignSystem.typography.caption)
                            .foregroundStyle(AppDesignSystem.colors.warning)
                    }
                }

                // Preview
                if !entry.preview.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        if let mood = entry.mood {
                            Text("\(mood.emoji) \(mood.displayName)")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(.secondary.opacity(0.1)))
                                .foregroundStyle(.secondary)
                        }
                        
                        Text(entry.preview)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }

                // Date
                Text(entry.updatedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

}

// MARK: - Preview

#Preview {
    List {
        DiaryRowView(entry: DiaryEntry(
            title: "Sample Entry",
            content: "This is a sample diary entry with some content that might be quite long and need truncation.",
            isPinned: true
        ))

        DiaryRowView(entry: DiaryEntry(
            title: "Another Entry",
            content: "Short content",
            isPinned: false
        ))
    }
}
