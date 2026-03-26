//
//  TaskRepository.swift
//  self-management
//
//  LEARNING: Repository Implementation (Tasks)
//

import Foundation

/// Implementation of task management operations using an API client
/// This class acts as a bridge between the domain layer's requirements and the actual API calls.
final class TaskRepository: TaskRepositoryProtocol {
    
    // MARK: - Properties
    
    private let apiClient: APIClientProtocol

    // MARK: - Initialization
    
    /// Initializes a TaskRepository with a specific API client.
    /// - Parameter apiClient: The API client to be used for requests (typically the authenticatedApiClient).
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - API DTOs
    
    /// Data Transfer Object for receiving task data from the API
    private struct TaskDTO: Decodable {
        let id: String
        let userId: String
        let title: String
        let description: String?
        let isCompleted: Bool
        let createdAt: String
        let deletedAt: String?

        /// Converts the DTO into the domain-layer TodoTask entity.
        func toEntity() -> TodoTask? {
            guard let id = UUID(uuidString: self.id),
                  let userId = UUID(uuidString: self.userId) else {
                return nil
            }
            
            // ISO8601 formatter for date strings
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let createdAtDate = formatter.date(from: self.createdAt) ?? Date()
            let deletedAtDate = self.deletedAt.flatMap { formatter.date(from: $0) }
            
            return TodoTask(
                id: id,
                userId: userId,
                title: self.title,
                description: self.description,
                isCompleted: self.isCompleted,
                createdAt: createdAtDate,
                deletedAt: deletedAtDate
            )
        }
    }

    /// Data Transfer Object for the Request Body when creating a task
    private struct CreateTaskRequestDTO: Encodable {
        let userId: String
        let title: String
        let description: String?
    }

    // MARK: - Repository Methods

    /// Fetches all active tasks with optional filters.
    func fetchTasks(completed: Bool?, limit: Int?, offset: Int?) async throws -> [TodoTask] {
        var params: [String: String] = [:]
        if let completed = completed { params["completed"] = String(completed) }
        if let limit = limit { params["limit"] = String(limit) }
        if let offset = offset { params["offset"] = String(offset) }
        
        let queryParams: [String: String]? = params.isEmpty ? nil : params
        
        let dtoList: [TaskDTO] = try await apiClient.request(
            path: APIEndpoint.tasks.path,
            method: "GET",
            query: queryParams,
            headers: nil as [String: String]?
        )
        
        return dtoList.compactMap { $0.toEntity() }
    }
    
    /// Fetches all tasks for a specific user with optional filters.
    func fetchTasks(for userId: UUID, completed: Bool?, limit: Int?, offset: Int?) async throws -> [TodoTask] {
        var params: [String: String] = [:]
        if let completed = completed { params["completed"] = String(completed) }
        if let limit = limit { params["limit"] = String(limit) }
        if let offset = offset { params["offset"] = String(offset) }
        
        let path = APIEndpoint.userTasks.path(args: userId.uuidString.lowercased())
        let queryParams: [String: String]? = params.isEmpty ? nil : params
        
        let dtoList: [TaskDTO] = try await apiClient.request(
            path: path,
            method: "GET",
            query: queryParams,
            headers: nil as [String: String]?
        )
        
        return dtoList.compactMap { $0.toEntity() }
    }
    
    /// Fetches a single task by ID.
    func fetchTask(by id: UUID) async throws -> TodoTask? {
        let path = "\(APIEndpoint.tasks.path)/\(id.uuidString.lowercased())"
        let dto: TaskDTO = try await apiClient.request(
            path: path,
            method: "GET",
            query: nil as [String: String]?,
            headers: nil as [String: String]?
        )
        return dto.toEntity()
    }
    
    /// Creates a new task.
    func createTask(title: String, description: String?, for userId: UUID) async throws -> TodoTask {
        let requestBody = CreateTaskRequestDTO(
            userId: userId.uuidString.lowercased(),
            title: title,
            description: description
        )
        
        let dto: TaskDTO = try await apiClient.request(
            path: APIEndpoint.tasks.path,
            method: "POST",
            body: requestBody,
            query: nil as [String: String]?,
            headers: nil as [String: String]?
        )
        
        guard let entity = dto.toEntity() else {
            throw APIError.decodingFailed(NSError(domain: "TaskRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse created task"]))
        }
        
        return entity
    }
    
    /// Marks a task as complete through the API.
    func completeTask(by id: UUID) async throws -> TodoTask {
        let path = APIEndpoint.completeTask.path(args: id.uuidString.lowercased())
        let dto: TaskDTO = try await apiClient.request(
            path: path,
            method: "PATCH",
            query: nil as [String: String]?,
            headers: nil as [String: String]?
        )
        
        guard let entity = dto.toEntity() else {
            throw APIError.decodingFailed(NSError(domain: "TaskRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse completed task"]))
        }
        
        return entity
    }
    
    /// Deletes a task through the API (usually soft-delete in the backend).
    func deleteTask(by id: UUID) async throws -> Void {
        let path = APIEndpoint.deleteTask.path(args: id.uuidString.lowercased())
        try await apiClient.emptyRequest(
            path: path,
            method: "DELETE",
            query: nil as [String: String]?,
            headers: nil as [String: String]?
        )
    }
}


