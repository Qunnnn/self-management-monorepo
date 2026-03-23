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
        HStack(spacing: 12) {
            // Theme indicator (to be implemented later via extension)

            VStack(alignment: .leading, spacing: 4) {
                // Title
                HStack {
                    Text(note.title)
                        .font(.headline)
                        .lineLimit(1)

                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
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
