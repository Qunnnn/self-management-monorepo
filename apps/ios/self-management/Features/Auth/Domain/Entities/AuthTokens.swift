//
//  AuthTokens.swift
//  self-management
//
//  Domain Entity: Authentication Tokens
//

import Foundation

/// Represents the authentication tokens received from the server
struct AuthTokens: Equatable {
    
    /// Short-lived token for API requests
    let accessToken: String
    
    /// Long-lived token used to obtain a new access token
    let refreshToken: String
}
