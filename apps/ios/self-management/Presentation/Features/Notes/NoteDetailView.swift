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
    @State private var editedStatus: NoteStatus
    @State private var showingDeleteConfirmation = false
    @State private var hasChanges = false

    // MARK: - Initialization

    init(note: Note, viewModel: NotesViewModel) {
        self.note = note
        self.viewModel = viewModel
        self._editedTitle = State(initialValue: note.title)
        self._editedContent = State(initialValue: note.content)
        self._editedStatus = State(initialValue: note.status)
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

            Section("Status") {
                Picker("Status", selection: $editedStatus) {
                    ForEach(NoteStatus.allCases, id: \.self) { status in
                        HStack {
                            Circle()
                                .fill(status.color)
                                .frame(width: 8, height: 8)
                            Text(status.displayName)
                        }
                        .tag(status)
                    }
                }
                .font(AppDesignSystem.typography.body)
                .onChange(of: editedStatus) { checkForChanges() }
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
                     editedStatus != note.status
    }

    private func saveChanges() {
        let updatedNote = note.updated(
            title: editedTitle,
            content: editedContent,
            status: editedStatus
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

}

// MARK: - Preview

#Preview {
    NavigationStack {
        NoteDetailView(
            note: Note(
                title: "Sample Note",
                content: "This is the content of the sample note.",
                status: .active
            ),
            viewModel: NotesViewModel(
                useCase: NotesUseCase(
                    repository: NotesRepository()
                )
            )
        )
    }
}
