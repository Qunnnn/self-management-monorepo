//
//  FetchCurrentUserUseCase.swift
//  self-management
//
//  LEARNING: Single-Action Use Case (Auth)
//

import Foundation

/// Use case for fetching the current user profile.
final class FetchCurrentUserUseCase {

    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    /// Fetches the current user profile using a stored access token.
    /// - Parameter accessToken: A valid access token.
    /// - Returns: Current user if the token is valid.
    func execute(accessToken: String) async -> User? {
        return await repository.fetchCurrentUser(accessToken: accessToken)
    }
}
