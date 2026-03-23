//
//  APIClient.swift
//  self-management
//
//  LEARNING: HTTP API Client
//

import Foundation

/// Defines standard API errors
enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case statusCode(Int)
    case decodingFailed(Error)
    case encodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL constructed."
        case .requestFailed(let err): return "Network request failed: \(err.localizedDescription)"
        case .invalidResponse: return "Received invalid response from server."
        case .statusCode(let code): return "HTTP Error: \(code)"
        case .decodingFailed(let err): return "Failed to decode response: \(err.localizedDescription)"
        case .encodingFailed(let err): return "Failed to encode request body: \(err.localizedDescription)"
        }
    }
}

/// Abstract protocol defining networking operations
protocol APIClientProtocol {
    
    /// Execute a network request with an encodable body and decode a given type
    func request<T: Decodable, B: Encodable>(
        path: String,
        method: String,
        body: B?,
        headers: [String: String]?
    ) async throws -> T
    
    /// Execute a network request without a body and decode a given type
    func request<T: Decodable>(
        path: String,
        method: String,
        headers: [String: String]?
    ) async throws -> T
    
    /// Execute a network request (no response body expected)
    func emptyRequest<B: Encodable>(
        path: String,
        method: String,
        body: B?,
        headers: [String: String]?
    ) async throws
    
    /// Execute a network request without a body (no response body expected)
    func emptyRequest(
        path: String,
        method: String,
        headers: [String: String]?
    ) async throws
}

struct EmptyEncodable: Encodable {}

/// Main HTTP networking client inside the App
final class APIClient: APIClientProtocol {
    private let baseURL: URL
    private let session: URLSession
    private let interceptor: RequestInterceptor?
    
    init(
        baseURL: URL = APIClient.defaultBaseURL,
        session: URLSession = .shared,
        interceptor: RequestInterceptor? = nil
    ) {
        self.baseURL = baseURL
        self.session = session
        self.interceptor = interceptor
    }
    
    // Static base URL for convenient initialization
    private static var defaultBaseURL: URL {
        URL(string: "http://localhost:8080")!
    }
    
    // Convenience init for easier adoption
    convenience init(session: URLSession = .shared, interceptor: RequestInterceptor? = nil) {
        self.init(baseURL: Self.defaultBaseURL, session: session, interceptor: interceptor)
    }
    
    func request<T: Decodable, B: Encodable>(
        path: String,
        method: String = "GET",
        body: B? = nil,
        headers: [String: String]? = nil
    ) async throws -> T {
        let request = try buildRequest(path: path, method: method, body: body, headers: headers)
        return try await executeAndDecode(request: request)
    }
    
    func request<T: Decodable>(
        path: String,
        method: String = "GET",
        headers: [String: String]? = nil
    ) async throws -> T {
        // Use a dummy struct since body is nil anyway
        let dummyBody: EmptyEncodable? = nil
        let request = try buildRequest(path: path, method: method, body: dummyBody, headers: headers)
        return try await executeAndDecode(request: request)
    }
    
    func emptyRequest<B: Encodable>(
        path: String,
        method: String = "GET",
        body: B? = nil,
        headers: [String: String]? = nil
    ) async throws {
        let request = try buildRequest(path: path, method: method, body: body, headers: headers)
        try await execute(request: request)
    }
    
    func emptyRequest(
        path: String,
        method: String = "GET",
        headers: [String: String]? = nil
    ) async throws {
        let dummyBody: EmptyEncodable? = nil
        let request = try buildRequest(path: path, method: method, body: dummyBody, headers: headers)
        try await execute(request: request)
    }
    
    // MARK: - Core Execution Methods
    
    private func executeAndDecode<T: Decodable>(request: URLRequest) async throws -> T {
        var adaptedRequest = request
        if let interceptor = interceptor {
            adaptedRequest = try await interceptor.adapt(request)
        }
        
        do {
            let (data, response) = try await session.data(for: adaptedRequest)
            try validateResponse(response)
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingFailed(error)
            }
        } catch let apiError as APIError {
            // Check if we should retry
            if let interceptor = interceptor, try await interceptor.retry(adaptedRequest, for: apiError) {
                return try await executeAndDecode(request: request)
            }
            throw apiError
        } catch {
            // Check if we should retry
            if let interceptor = interceptor, try await interceptor.retry(adaptedRequest, for: error) {
                return try await executeAndDecode(request: request)
            }
            throw APIError.requestFailed(error)
        }
    }
    
    private func execute(request: URLRequest) async throws {
        var adaptedRequest = request
        if let interceptor = interceptor {
            adaptedRequest = try await interceptor.adapt(request)
        }
        
        do {
            let (_, response) = try await session.data(for: adaptedRequest)
            try validateResponse(response)
        } catch let apiError as APIError {
            // Check if we should retry
            if let interceptor = interceptor, try await interceptor.retry(adaptedRequest, for: apiError) {
                try await execute(request: request)
                return
            }
            throw apiError
        } catch {
            // Check if we should retry
            if let interceptor = interceptor, try await interceptor.retry(adaptedRequest, for: error) {
                try await execute(request: request)
                return
            }
            throw APIError.requestFailed(error)
        }
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.statusCode(httpResponse.statusCode)
        }
    }
    
    private func buildRequest<B: Encodable>(
        path: String,
        method: String,
        body: B?,
        headers: [String: String]?
    ) throws -> URLRequest {
        var baseString = baseURL.absoluteString
        if baseString.hasSuffix("/") && path.hasPrefix("/") {
            baseString.removeLast()
        }
        guard let url = URL(string: baseString + path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw APIError.encodingFailed(error)
            }
        }
        
        return request
    }
}
