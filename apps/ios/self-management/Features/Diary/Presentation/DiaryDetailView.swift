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
    @State private var editedStatus: DiaryStatus
    @State private var showingDeleteConfirmation = false
    @State private var hasChanges = false

    // MARK: - Initialization

    init(entry: DiaryEntry, viewModel: DiaryViewModel) {
        self.entry = entry
        self.viewModel = viewModel
        self._editedTitle = State(initialValue: entry.title)
        self._editedContent = State(initialValue: entry.content)
        self._editedStatus = State(initialValue: entry.status)
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
                    .frame(minHeight: 200)
                    .onChange(of: editedContent) { checkForChanges() }
            }

            Section("Status") {
                Picker("Status", selection: $editedStatus) {
                    ForEach(DiaryStatus.allCases, id: \.self) { status in
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
                LabeledContent("Created", value: entry.createdAt.formatted())
                LabeledContent("Modified", value: entry.updatedAt.formatted())
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
                     editedStatus != entry.status
    }

    private func saveChanges() {
        let updatedEntry = entry.updated(
            title: editedTitle,
            content: editedContent,
            status: editedStatus
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
                content: "This is the content of the sample diary entry.",
                status: .active
            ),
            viewModel: viewModel
        )
    }
}
