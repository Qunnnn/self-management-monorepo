//
//  NoteRowView.swift
//  self-management
//
//  LEARNING: Reusable View Component
//
//  This is a small, focused component that displays a single note row.
//  Keeping components small makes them:
//  - Easy to test
//  - Easy to reuse
//  - Easy to understand
//

import SwiftUI

struct NoteRowView: View {

    let note: Note

    var body: some View {
        HStack(spacing: AppDesignSystem.spacing.md) {
            // Status Indicator Circle
            Circle()
                .fill(note.status.color)
                .frame(width: 8, height: 8)
                .padding(.top, 6)
                .frame(maxHeight: .infinity, alignment: .top)

            VStack(alignment: .leading, spacing: AppDesignSystem.spacing.xxs) {
                // Title
                HStack {
                    Text(note.title)
                        .font(AppDesignSystem.typography.title)
                        .foregroundStyle(AppDesignSystem.colors.textPrimary)
                        .lineLimit(1)

                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .font(AppDesignSystem.typography.caption)
                            .foregroundStyle(AppDesignSystem.colors.warning)
                    }
                }

                // Preview
                if !note.preview.isEmpty {
                    Text(note.preview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                // Date
                Text(note.updatedAt.formatted(date: .abbreviated, time: .shortened))
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
        NoteRowView(note: Note(
            title: "Sample Note",
            content: "This is a sample note with some content that might be quite long and need truncation.",
            status: .active,
            isPinned: true
        ))

        NoteRowView(note: Note(
            title: "Another Note",
            content: "Short content",
            status: .active,
            isPinned: false
        ))
    }
}
