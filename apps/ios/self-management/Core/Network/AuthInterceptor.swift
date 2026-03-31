//
//  AuthInterceptor.swift
//  self-management
//

import Foundation

/// Interceptor that handles adding Authorization headers and automatic token refreshing.
/// Similar to Flutter's Dio Interceptor.
actor AuthInterceptor: RequestInterceptor {
    
    private let tokenStorage: TokenStorage
    private let baseURL: URL
    
    /// Use a separate URLSession for refresh to avoid interceptor loops
    private let refreshSession: URLSession = .shared
    
    /// Track an ongoing refresh task to handle concurrent retries
    private var refreshTask: Task<AuthTokens, Error>?
    
    init(tokenStorage: TokenStorage = TokenStorage(), baseURL: URL = NetworkConfig.baseURL) {
        self.tokenStorage = tokenStorage
        self.baseURL = baseURL
    }
    
    // MARK: - RequestInterceptor
    
    func adapt(_ request: URLRequest) async throws -> URLRequest {
        var request = request
        
        // Don't add auth header if it's already there or for public auth endpoints
        if request.value(forHTTPHeaderField: "Authorization") == nil,
           let tokens = tokenStorage.loadTokens() {
            request.setValue("Bearer \(tokens.accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    func retry(_ request: URLRequest, for error: Error) async throws -> Bool {
        // Only retry on 401 Unauthorized
        guard let apiError = error as? APIError,
              case .statusCode(401) = apiError else {
            return false
        }
        
        // Only retry if it's NOT already the refresh endpoint (to prevent infinite loops)
        let path = request.url?.path() ?? ""
        guard !path.contains(APIEndpoint.refresh.path) else {
            return false
        }
        
        // Use an existing refresh task if one is already running
        if let existingTask = refreshTask {
            _ = try await existingTask.value
            return true
        }
        
        // Start a new refresh task
        let newTask = Task<AuthTokens, Error> {
            try await self.refreshTokens()
        }
        
        refreshTask = newTask
        
        do {
            let newTokens = try await newTask.value
            tokenStorage.saveTokens(newTokens)
            refreshTask = nil // Clear the task after success
            return true
        } catch {
            refreshTask = nil // Clear the task on failure
            tokenStorage.clearTokens()
            return false
        }
    }
    
    // MARK: - Private Methods
    
    private struct RefreshRequestDTO: Encodable {
        let refreshToken: String
    }
    
    private struct RefreshResponseDTO: Decodable {
        let userId: String
        let accessToken: String
        let refreshToken: String
    }
    
    private func refreshTokens() async throws -> AuthTokens {
        guard let tokens = tokenStorage.loadTokens() else {
            throw APIError.invalidResponse
        }
        
        let endpoint = APIEndpoint.refresh
        var request = URLRequest(url: baseURL.appending(path: endpoint.path))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = RefreshRequestDTO(refreshToken: tokens.refreshToken)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await refreshSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.statusCode((response as? HTTPURLResponse)?.statusCode ?? 500)
        }
        
        let refreshResponse = try JSONDecoder().decode(RefreshResponseDTO.self, from: data)
        return AuthTokens(
            accessToken: refreshResponse.accessToken,
            refreshToken: refreshResponse.refreshToken
        )
    }
}
