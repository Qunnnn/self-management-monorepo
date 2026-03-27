//
//  APIDiaryRepository.swift
//  self-management
//

import Foundation

/// Implementation of diary management operations using an API client
final class APIDiaryRepository: DiaryRepositoryProtocol {
    
    // MARK: - Properties
    
    private let apiClient: APIClientProtocol

    // MARK: - Initialization
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - API DTOs
    
    private struct DiaryEntryDTO: Decodable {
        let id: String
        let userId: String
        let title: String
        let content: String
        let mood: String?
        let latitude: Double?
        let longitude: Double?
        let isPinned: Bool
        let createdAt: String
        let updatedAt: String

        func toEntity() -> DiaryEntry? {
            guard let uuid = UUID(uuidString: self.id) else {
                return nil
            }
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let createdAtDate = formatter.date(from: self.createdAt) ?? Date()
            let updatedAtDate = formatter.date(from: self.updatedAt) ?? Date()
            
            let diaryMood = self.mood.flatMap { DiaryMood(rawValue: $0) }
            
            return DiaryEntry(
                id: uuid,
                title: self.title,
                content: self.content,
                createdAt: createdAtDate,
                updatedAt: updatedAtDate,
                isPinned: self.isPinned,
                mood: diaryMood,
                latitude: self.latitude,
                longitude: self.longitude,
                attachments: [] // Attachments are fetched separately or lazily
            )
        }
    }

    private struct CreateDiaryRequestDTO: Encodable {
        let title: String
        let content: String
        let mood: String?
        let isPinned: Bool
    }

    private struct UpdateDiaryRequestDTO: Encodable {
        let title: String?
        let content: String?
        let mood: String?
        let isPinned: Bool?
    }

    // MARK: - Repository Methods

    func getAllEntries() async throws -> [DiaryEntry] {
        let dtoList: [DiaryEntryDTO] = try await apiClient.request(
            path: APIEndpoint.diary.path,
            method: "GET",
            query: nil as [String: String]?,
            headers: nil as [String: String]?
        )
        
        return dtoList.compactMap { $0.toEntity() }
    }

    func getEntry(by id: UUID) async throws -> DiaryEntry? {
        let path = APIEndpoint.diaryDetail.path(args: id.uuidString.lowercased())
        let dto: DiaryEntryDTO = try await apiClient.request(
            path: path,
            method: "GET",
            query: nil as [String: String]?,
            headers: nil as [String: String]?
        )
        return dto.toEntity()
    }

    func saveEntry(_ entry: DiaryEntry) async throws {
        let request = CreateDiaryRequestDTO(
            title: entry.title,
            content: entry.content,
            mood: entry.mood?.rawValue,
            isPinned: entry.isPinned
        )
        
        let _: DiaryEntryDTO = try await apiClient.request(
            path: APIEndpoint.diary.path,
            method: "POST",
            body: request,
            query: nil as [String: String]?,
            headers: nil as [String: String]?
        )
    }

    func updateEntry(_ entry: DiaryEntry) async throws {
        let path = APIEndpoint.diaryDetail.path(args: entry.id.uuidString.lowercased())
        let request = UpdateDiaryRequestDTO(
            title: entry.title,
            content: entry.content,
            mood: entry.mood?.rawValue,
            isPinned: entry.isPinned
        )
        
        let _: DiaryEntryDTO = try await apiClient.request(
            path: path,
            method: "PUT",
            body: request,
            query: nil as [String: String]?,
            headers: nil as [String: String]?
        )
    }

    func deleteEntry(by id: UUID) async throws {
        let path = APIEndpoint.diaryDetail.path(args: id.uuidString.lowercased())
        try await apiClient.emptyRequest(
            path: path,
            method: "DELETE",
            query: nil as [String: String]?,
            headers: nil as [String: String]?
        )
    }

    func deleteEntries(by ids: [UUID]) async throws {
        for id in ids {
            try await deleteEntry(by: id)
        }
    }
}
