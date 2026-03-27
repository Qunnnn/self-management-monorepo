//
//  DiaryDetailView.swift
//  self-management
//
//  LEARNING: Detail/Edit View
//

import SwiftUI

struct DiaryDetailView: View {

    // MARK: - Properties

    let entry: DiaryEntry
    let viewModel: DiaryViewModel

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    @State private var editedTitle: String
    @State private var editedContent: String
    @State private var editedMood: String
    @State private var showingDeleteConfirmation = false
    @State private var hasChanges = false

    // MARK: - Initialization

    init(entry: DiaryEntry, viewModel: DiaryViewModel) {
        self.entry = entry
        self.viewModel = viewModel
        self._editedTitle = State(initialValue: entry.title)
        self._editedContent = State(initialValue: entry.content)
        self._editedMood = State(initialValue: entry.mood ?? "")
    }

    // MARK: - Body

    var body: some View {
        Form {
            Section("Title") {
                TextField("Entry title", text: $editedTitle)
                    .onChange(of: editedTitle) { checkForChanges() }
            }

            Section("Content") {
                TextEditor(text: $editedContent)
                    .frame(minHeight: 150)
                    .onChange(of: editedContent) { checkForChanges() }
            }

            Section("Mood") {
                TextField("How are you feeling?", text: $editedMood)
                    .onChange(of: editedMood) { checkForChanges() }
            }

            Section("Info") {
                LabeledContent("Created", value: entry.createdAt.formatted())
                LabeledContent("Modified", value: entry.updatedAt.formatted())
                if let lat = entry.latitude, let lon = entry.longitude {
                    LabeledContent("Location", value: String(format: "%.4f, %.4f", lat, lon))
                }
            }

            Section {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    HStack {
                        Spacer()
                        Text("Delete Entry")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Edit Entry")
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
            "Delete Entry?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deleteEntry()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }

    // MARK: - Helpers

    private func checkForChanges() {
        hasChanges = editedTitle != entry.title ||
                     editedContent != entry.content ||
                     editedMood != (entry.mood ?? "")
    }

    private func saveChanges() {
        let updatedEntry = entry.updated(
            title: editedTitle,
            content: editedContent,
            mood: editedMood.isEmpty ? nil : editedMood
        )

        Task {
            await viewModel.updateEntry(updatedEntry)
            dismiss()
        }
    }

    private func deleteEntry() {
        Task {
            await viewModel.deleteEntry(entry)
            dismiss()
        }
    }

}

// MARK: - Preview

#Preview {
    let repository = DiaryRepository()
    let viewModel = DiaryViewModel(
        fetchUseCase: FetchDiaryEntriesUseCase(repository: repository),
        createUseCase: CreateDiaryEntryUseCase(repository: repository),
        updateUseCase: UpdateDiaryEntryUseCase(repository: repository),
        deleteUseCase: DeleteDiaryEntryUseCase(repository: repository),
        togglePinUseCase: TogglePinUseCase(repository: repository)
    )
    
    return NavigationStack {
        DiaryDetailView(
            entry: DiaryEntry(
                title: "Sample Entry",
                content: "This is the content of the sample diary entry."
            ),
            viewModel: viewModel
        )
    }
}
