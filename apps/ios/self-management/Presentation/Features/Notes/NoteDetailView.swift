//
//  NoteDetailView.swift
//  self-management
//
//  LEARNING: Detail/Edit View
//
//  This view demonstrates:
//  - Editing existing data
//  - State management with @State
//  - Navigation with @Environment
//  - Confirmation dialogs
//

import SwiftUI

struct NoteDetailView: View {

    // MARK: - Properties

    let note: Note
    let viewModel: NotesViewModel

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    @State private var editedTitle: String
    @State private var editedContent: String
    @State private var editedColorTag: NoteColor
    @State private var showingDeleteConfirmation = false
    @State private var hasChanges = false

    // MARK: - Initialization

    init(note: Note, viewModel: NotesViewModel) {
        self.note = note
        self.viewModel = viewModel
        self._editedTitle = State(initialValue: note.title)
        self._editedContent = State(initialValue: note.content)
        self._editedColorTag = State(initialValue: note.colorTag)
    }

    // MARK: - Body

    var body: some View {
        Form {
            Section("Title") {
                TextField("Note title", text: $editedTitle)
                    .onChange(of: editedTitle) { checkForChanges() }
            }

            Section("Content") {
                TextEditor(text: $editedContent)
                    .frame(minHeight: 200)
                    .onChange(of: editedContent) { checkForChanges() }
            }

            Section("Color Tag") {
                Picker("Color", selection: $editedColorTag) {
                    ForEach(NoteColor.allCases, id: \.self) { color in
                        HStack {
                            if color != .none {
                                Circle()
                                    .fill(colorForTag(color))
                                    .frame(width: 12, height: 12)
                            }
                            Text(color.displayName)
                        }
                        .tag(color)
                    }
                }
                .onChange(of: editedColorTag) { checkForChanges() }
            }

            Section("Info") {
                LabeledContent("Created", value: note.createdAt.formatted())
                LabeledContent("Modified", value: note.updatedAt.formatted())
            }

            Section {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    HStack {
                        Spacer()
                        Text("Delete Note")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Edit Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    saveChanges()
                }
                .disabled(!hasChanges)
            }
        }
        .confirmationDialog(
            "Delete Note?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deleteNote()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }

    // MARK: - Helpers

    private func checkForChanges() {
        hasChanges = editedTitle != note.title ||
                     editedContent != note.content ||
                     editedColorTag != note.colorTag
    }

    private func saveChanges() {
        let updatedNote = note.updated(
            title: editedTitle,
            content: editedContent,
            colorTag: editedColorTag
        )

        Task {
            await viewModel.updateNote(updatedNote)
            dismiss()
        }
    }

    private func deleteNote() {
        Task {
            await viewModel.deleteNote(note)
            dismiss()
        }
    }

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
    NavigationStack {
        NoteDetailView(
            note: Note(
                title: "Sample Note",
                content: "This is the content of the sample note.",
                colorTag: .blue
            ),
            viewModel: NotesViewModel(
                useCase: NotesUseCase(
                    repository: NotesRepository()
                )
            )
        )
    }
}
