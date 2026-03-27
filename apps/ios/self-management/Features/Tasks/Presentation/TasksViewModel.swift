//
//  TasksViewModel.swift
//  self-management
//
//  LEARNING: ViewModel Pattern (Tasks)
//

import Foundation
import SwiftUI
import Observation

/// ViewModel for the Tasks list view.
@Observable
final class TasksViewModel {
    
    // MARK: - State Properties
    
    private(set) var tasks: [TodoTask] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    var newTaskTitle = ""
    var newTaskDescription = ""
    var isShowingAddTask = false
    
    // MARK: - Dependencies
    
    private let fetchUseCase: FetchTasksUseCase
    private let createUseCase: CreateTaskUseCase
    private let completeUseCase: CompleteTaskUseCase
    private let deleteUseCase: DeleteTaskUseCase
    private let userId: String
    
    // MARK: - Initialization
    
    init(
        fetchUseCase: FetchTasksUseCase,
        createUseCase: CreateTaskUseCase,
        completeUseCase: CompleteTaskUseCase,
        deleteUseCase: DeleteTaskUseCase,
        userId: String
    ) {
        self.fetchUseCase = fetchUseCase
        self.createUseCase = createUseCase
        self.completeUseCase = completeUseCase
        self.deleteUseCase = deleteUseCase
        self.userId = userId
    }
    
    // MARK: - Actions
    
    /// Loads the tasks for the current user.
    @MainActor
    func loadTasks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            tasks = try await fetchUseCase.execute(for: userId)
            isLoading = false
        } catch {
            errorMessage = "Failed to load tasks: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// Adds a new task using the title and description from the state.
    @MainActor
    func addTask() async {
        guard !newTaskTitle.isEmpty else { return }
        
        do {
            let task = try await createUseCase.execute(
                title: newTaskTitle,
                description: newTaskDescription.isEmpty ? nil : newTaskDescription,
                for: userId
            )
            tasks.append(task)
            
            // Reset input state
            newTaskTitle = ""
            newTaskDescription = ""
            isShowingAddTask = false
        } catch {
            errorMessage = "Failed to add task: \(error.localizedDescription)"
        }
    }
    
    /// Toggles the completion status of a task.
    @MainActor
    func completeTask(_ task: TodoTask) async {
        guard !task.isCompleted else { return } // Already completed
        
        do {
            let updatedTask = try await completeUseCase.execute(taskId: task.id)
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[index] = updatedTask
            }
        } catch {
            errorMessage = "Failed to complete task: \(error.localizedDescription)"
        }
    }
    
    /// Deletes a task.
    @MainActor
    func deleteTask(at offsets: IndexSet) async {
        for index in offsets {
            let task = tasks[index]
            do {
                try await deleteUseCase.execute(taskId: task.id)
            } catch {
                errorMessage = "Failed to delete task: \(error.localizedDescription)"
                return // Stop on first error
            }
        }
        tasks.remove(atOffsets: offsets)
    }
}
