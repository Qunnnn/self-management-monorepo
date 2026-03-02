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
            // Color indicator
            if note.colorTag != .none {
                Circle()
                    .fill(colorForTag(note.colorTag))
                    .frame(width: 8, height: 8)
            }

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

    // MARK: - Helpers

    private func colorForTag(_ tag: NoteColor) -> Color {
        switch tag {
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

// MARK: - Preview

#Preview {
    List {
        NoteRowView(note: Note(
            title: "Sample Note",
            content: "This is a sample note with some content that might be quite long and need truncation.",
            colorTag: .blue,
            isPinned: true
        ))

        NoteRowView(note: Note(
            title: "Another Note",
            content: "Short content",
            colorTag: .none,
            isPinned: false
        ))
    }
}
