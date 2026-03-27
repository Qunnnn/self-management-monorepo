//
//  TasksListView.swift
//  self-management
//
//  LEARNING: Tasks View (Aesthetic Design)
//

import SwiftUI
import UIKit

/// Main UI for the tasks feature, displaying a list of user tasks with support for creating, completing and deleting tasks.
struct TasksListView: View {
    
    // MARK: - State Properties
    
    @Environment(\.dependencyContainer) private var container
    @State private var viewModel: TasksViewModel?
    
    // MARK: - Body View
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color from design system
                AppDesignSystem.colors.background
                    .ignoresSafeArea()
                
                if let vm = viewModel {
                    viewContent(vm: vm)
                } else {
                    ProgressView("Initializing...")
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel?.isShowingAddTask = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            .sheet(isPresented: Binding(
                get: { viewModel?.isShowingAddTask ?? false },
                set: { viewModel?.isShowingAddTask = $0 }
            )) {
                if let vm = viewModel {
                    AddTaskView(vm: vm)
                        .presentationDetents([.medium])
                }
            }
            .task {
                setupViewModel()
                await viewModel?.loadTasks()
            }
            .refreshable {
                await viewModel?.loadTasks()
            }
        }
    }
    
    // MARK: - Private Methods
    
    @ViewBuilder
    private func viewContent(vm: TasksViewModel) -> some View {
        if vm.isLoading && vm.tasks.isEmpty {
            VStack {
                ProgressView()
                    .scaleEffect(1.2)
                Text("Fetching your tasks...")
                    .font(AppDesignSystem.typography.caption)
                    .foregroundColor(AppDesignSystem.colors.textSecondary)
                    .padding(.top, 8)
            }
        } else if let error = vm.errorMessage {
            ContentUnavailableView {
                Label("Error", systemImage: "exclamationmark.triangle.fill")
            } description: {
                Text(error)
            } actions: {
                Button("Retry") {
                    Task { await vm.loadTasks() }
                }
                .buttonStyle(.borderedProminent)
            }
        } else if vm.tasks.isEmpty {
            ContentUnavailableView {
                Label("No Tasks", systemImage: "checklist")
            } description: {
                Text("You're all caught up! Tap the + button to add a new task.")
            } actions: {
                Button("Add Task") {
                    vm.isShowingAddTask = true
                }
                .buttonStyle(.borderedProminent)
            }
        } else {
            TaskList(vm: vm)
        }
    }
    
    private func setupViewModel() {
        guard viewModel == nil, let container = container else { return }
        
        viewModel = TasksViewModel(
            fetchUseCase: container.fetchTasksUseCase,
            createUseCase: container.createTaskUseCase,
            completeUseCase: container.completeTaskUseCase,
            deleteUseCase: container.deleteTaskUseCase
        )
    }
}

// MARK: - Supporting Views

struct TaskList: View {
    let vm: TasksViewModel
    
    var body: some View {
        List {
            Section {
                ForEach(vm.tasks) { task in
                    TaskRow(task: task) {
                        Task { await vm.completeTask(task) }
                    }
                    .listRowBackground(Color.appTheme.background)
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 4)
                }
                .onDelete { offsets in
                    Task { await vm.deleteTask(at: offsets) }
                }
            } header: {
                Text("My Daily Tasks")
                    .font(AppDesignSystem.typography.caption)
                    .foregroundColor(AppDesignSystem.colors.textSecondary)
                    .textCase(.uppercase)
            }
        }
        .listStyle(.plain)
        .background(AppDesignSystem.colors.background)
    }
}

struct TaskRow: View {
    let task: TodoTask
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    onToggle()
                }
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? AppDesignSystem.colors.success : AppDesignSystem.colors.border)
                    .font(.system(size: 24, weight: .medium))
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(AppDesignSystem.typography.title)
                    .strikethrough(task.isCompleted, color: AppDesignSystem.colors.textTertiary)
                    .foregroundColor(task.isCompleted ? AppDesignSystem.colors.textSecondary : AppDesignSystem.colors.textPrimary)
                    .animation(.none, value: task.isCompleted)
                
                if let description = task.description {
                    Text(description)
                        .font(AppDesignSystem.typography.body)
                        .foregroundColor(AppDesignSystem.colors.textSecondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            if task.isCompleted {
                Image(systemName: "sparkles")
                    .foregroundColor(AppDesignSystem.colors.warning)
                    .font(.caption)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appTheme.surface)
                .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppDesignSystem.colors.border, lineWidth: 1)
        )
    }
}

struct AddTaskView: View {
    let vm: TasksViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section("New Task Details") {
                    TextField("Title", text: Binding(
                        get: { vm.newTaskTitle },
                        set: { vm.newTaskTitle = $0 }
                    ))
                    TextField("Description (Optional)", text: Binding(
                        get: { vm.newTaskDescription },
                        set: { vm.newTaskDescription = $0 }
                    ), axis: .vertical)
                        .lineLimit(3...10)
                }
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        vm.isShowingAddTask = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task { await vm.addTask() }
                    }
                    .disabled(vm.newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    TasksListView()
        .environment(DependencyContainer())
}
