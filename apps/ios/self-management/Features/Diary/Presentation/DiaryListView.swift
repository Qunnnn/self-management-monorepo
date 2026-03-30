//
//  DiaryListView.swift
//  self-management
//
//  LEARNING: SwiftUI List View
//

import SwiftUI

struct DiaryListView: View {

    // MARK: - Environment

    @Environment(\.dependencyContainer) private var container

    // MARK: - State

    @State private var viewModel: DiaryViewModel?
    @State private var showingNewEntrySheet = false
    @State private var newEntryTitle = ""
    @State private var newEntryContent = ""

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel = viewModel {
                    diaryContent(viewModel: viewModel)
                } else {
                    ProgressView("Loading...")
                }
            }
            .navigationTitle("Diary")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewEntrySheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewEntrySheet) {
                newEntrySheet
            }
        }
        .task {
            setupViewModel()
            await viewModel?.loadEntries()
        }
    }

    // MARK: - Diary Content

    @ViewBuilder
    private func diaryContent(viewModel: DiaryViewModel) -> some View {
        if viewModel.entries.isEmpty {
            emptyState
        } else {
            diaryList(viewModel: viewModel)
        }
    }

    struct SectionData: Identifiable {
        let id: String
        let entries: [DiaryEntry]
    }
    
    private func getSectionData(viewModel: DiaryViewModel) -> [SectionData] {
        return [
            SectionData(id: "Pinned", entries: viewModel.pinnedEntries),
            SectionData(
                id: viewModel.pinnedEntries.isEmpty ? "Entries" : "Others",
                entries: viewModel.unpinnedEntries
            )
        ]
    }

    private func diaryList(viewModel: DiaryViewModel) -> some View {
        List {
            ForEach(getSectionData(viewModel: viewModel)) { section in
                Section {
                    ForEach(section.entries) { entry in
                        entryRow(entry: entry, viewModel: viewModel)
                    }
                } header: {
                    if !section.entries.isEmpty {
                        Text(section.id)
                    }
                }
            }
        }
        .searchable(text: Binding(
            get: { viewModel.searchQuery },
            set: { viewModel.searchQuery = $0 }
        ))
        .refreshable {
            await viewModel.loadEntries()
        }
    }

    private func entryRow(entry: DiaryEntry, viewModel: DiaryViewModel) -> some View {
        NavigationLink {
            DiaryDetailView(entry: entry, viewModel: viewModel)
        } label: {
            DiaryRowView(entry: entry)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                Task {
                    await viewModel.deleteEntry(entry)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                Task {
                    await viewModel.togglePin(entry)
                }
            } label: {
                Label(
                    entry.isPinned ? "Unpin" : "Pin",
                    systemImage: entry.isPinned ? "pin.slash" : "pin"
                )
            }
            .tint(.orange)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Diary Entries", systemImage: "book.fill")
        } description: {
            Text("Tap the + button to create your first diary entry")
        } actions: {
            Button("Create Entry") {
                showingNewEntrySheet = true
            }
            .buttonStyle(.borderedProminent)
        }
    }

    // MARK: - New Entry Sheet

    private var newEntrySheet: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Entry title", text: $newEntryTitle)
                }

                Section("Content") {
                    TextEditor(text: $newEntryContent)
                        .frame(minHeight: 150)
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        resetNewEntryForm()
                        showingNewEntrySheet = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel?.createEntry(
                                title: newEntryTitle.isEmpty ? "Untitled" : newEntryTitle,
                                content: newEntryContent
                            )
                            resetNewEntryForm()
                            showingNewEntrySheet = false
                        }
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    // MARK: - Helpers

    private func setupViewModel() {
        guard let container = container else { return }
        viewModel = DiaryViewModel(
            fetchUseCase: container.fetchDiaryEntriesUseCase,
            createUseCase: container.createDiaryEntryUseCase,
            updateUseCase: container.updateDiaryEntryUseCase,
            deleteUseCase: container.deleteDiaryEntryUseCase,
            togglePinUseCase: container.togglePinUseCase
        )
    }

    private func resetNewEntryForm() {
        newEntryTitle = ""
        newEntryContent = ""
    }
}

// MARK: - Preview

#Preview {
    DiaryListView()
        .environment(DependencyContainer())
}
