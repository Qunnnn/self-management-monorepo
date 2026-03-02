//
//  NotesListView.swift
//  self-management
//
//  LEARNING: SwiftUI List View
//
//  This view displays all notes in a list format.
//  It demonstrates:
//  - NavigationStack for navigation
//  - List with sections
//  - Search functionality
//  - Swipe actions
//  - Sheet presentation
//

import SwiftUI

struct NotesListView: View {

    // MARK: - Environment

    @Environment(\.dependencyContainer) private var container

    // MARK: - State

    @State private var viewModel: NotesViewModel?
    @State private var showingNewNoteSheet = false
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel = viewModel {
                    notesContent(viewModel: viewModel)
                } else {
                    ProgressView("Loading...")
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewNoteSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewNoteSheet) {
                newNoteSheet
            }
        }
        .task {
            setupViewModel()
            await viewModel?.loadNotes()
        }
    }

    // MARK: - Notes Content

    @ViewBuilder
    private func notesContent(viewModel: NotesViewModel) -> some View {
        if viewModel.notes.isEmpty {
            emptyState
        } else {
            notesList(viewModel: viewModel)
        }
    }

    private func notesList(viewModel: NotesViewModel) -> some View {
        List {
            // Pinned Section
            if !viewModel.pinnedNotes.isEmpty {
                Section("Pinned") {
                    ForEach(viewModel.pinnedNotes) { note in
                        noteRow(note: note, viewModel: viewModel)
                    }
                }
            }

            // All Notes Section
            Section(viewModel.pinnedNotes.isEmpty ? "Notes" : "Others") {
                ForEach(viewModel.unpinnedNotes) { note in
                    noteRow(note: note, viewModel: viewModel)
                }
            }
        }
        .searchable(text: Binding(
            get: { viewModel.searchQuery },
            set: { viewModel.searchQuery = $0 }
        ))
        .refreshable {
            await viewModel.loadNotes()
        }
    }

    private func noteRow(note: Note, viewModel: NotesViewModel) -> some View {
        NavigationLink {
            NoteDetailView(note: note, viewModel: viewModel)
        } label: {
            NoteRowView(note: note)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                Task {
                    await viewModel.deleteNote(note)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                Task {
                    await viewModel.togglePin(note)
                }
            } label: {
                Label(
                    note.isPinned ? "Unpin" : "Pin",
                    systemImage: note.isPinned ? "pin.slash" : "pin"
                )
            }
            .tint(.orange)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Notes", systemImage: "note.text")
        } description: {
            Text("Tap the + button to create your first note")
        } actions: {
            Button("Create Note") {
                showingNewNoteSheet = true
            }
            .buttonStyle(.borderedProminent)
        }
    }

    // MARK: - New Note Sheet

    private var newNoteSheet: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Note title", text: $newNoteTitle)
                }

                Section("Content") {
                    TextEditor(text: $newNoteContent)
                        .frame(minHeight: 150)
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        resetNewNoteForm()
                        showingNewNoteSheet = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel?.createNote(
                                title: newNoteTitle.isEmpty ? "Untitled" : newNoteTitle,
                                content: newNoteContent
                            )
                            resetNewNoteForm()
                            showingNewNoteSheet = false
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
        viewModel = NotesViewModel(useCase: container.notesUseCase)
    }

    private func resetNewNoteForm() {
        newNoteTitle = ""
        newNoteContent = ""
    }
}

// MARK: - Preview

#Preview {
    NotesListView()
        .environment(DependencyContainer())
}
