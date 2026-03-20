//
//  AuthRepository.swift
//  self-management
//
//  LEARNING: Repository Implementation (Auth)
//

import Foundation

/// Implementation of authentication operations
/// This is a Data Adapter - implementation detail of the Domain Repository Port
final class AuthRepository: AuthRepositoryProtocol {
    
    // MARK: - Properties
    
    private let apiClient: APIClientProtocol

    // MARK: - Initialization
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API DTOs
    
    // Private DTOs for decoding backend responses
    private struct UserDTO: Decodable {
        let id: Int
        let name: String
        let email: String
        let phoneNumber: String?
    }

    private struct AuthResponseDTO: Decodable {
        let user: UserDTO
        let token: String
    }

    // Request DTOs
    private struct LoginRequestDTO: Encodable {
        let email: String
        let password: String
    }

    // MARK: - Repository Methods

    /// Login implementation
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    /// - Returns: A tuple with the logged-in User and authentication tokens
    func login(email: String, password: String) async throws -> (User, AuthTokens) {
        let requestBody = LoginRequestDTO(email: email, password: password)
        
        do {
            let authResponse: AuthResponseDTO = try await apiClient.request(
                path: "/auth/login",
                method: "POST",
                body: requestBody,
                headers: nil as [String: String]?
            )
            
            let user = User(
                id: authResponse.user.id,
                email: authResponse.user.email,
                name: authResponse.user.name,
                profilePictureUrl: nil
            )
            
            // BE only returns a single token for now
            let tokens = AuthTokens(
                accessToken: authResponse.token,
                refreshToken: "refresh_not_supported"
            )
            
            return (user, tokens)
            
        } catch let apiError as APIError {
            // Map API errors to domain errors if needed
            print("Login failed: \(apiError.localizedDescription)")
            throw AuthError.invalidCredentials
        } catch {
            throw AuthError.invalidCredentials
        }
    }
    
    /// Logout implementation
    func logout() async throws {
        // No server-side logout configured, just cleanup locally
    }
    
    /// Fetch the current user profile using an access token
    /// - Parameter accessToken: A valid access token
    /// - Returns: Current logged-in User if the token is valid
    func fetchCurrentUser(accessToken: String) async -> User? {
        guard !accessToken.isEmpty else { return nil }
        
        do {
            let userDTO: UserDTO = try await apiClient.request(
                path: "/users/me",
                method: "GET",
                headers: ["Authorization": "Bearer \(accessToken)"]
            )
            
            return User(
                id: userDTO.id,
                email: userDTO.email,
                name: userDTO.name,
                profilePictureUrl: nil
            )
            
        } catch {
            print("Failed to fetch current user: \(error)")
            return nil
        }
    }
}
