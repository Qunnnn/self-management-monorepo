//
//  APIEndpoint.swift
//  self-management
//
//  RESOURCE: Centralized API Endpoints
//

import Foundation

/// Defines all available API endpoints in the system.
/// This allows for easy path management and metadata (like whether an API is public).
enum APIEndpoint: String, CaseIterable {
    
    // Auth Endpoints
    case login = "/auth/login"
    case register = "/auth/register"
    case refresh = "/auth/refresh"
    case logout = "/auth/logout"
    
    // User Endpoints
    case profile = "/users/me"
    
    // Notes Endpoints
    case notes = "/notes"
    
    /// The actual path string for the endpoint
    var path: String {
        return self.rawValue
    }
    
    /// Whether the endpoint is accessible without an authentication token
    var isPublic: Bool {
        switch self {
        case .login, .register, .refresh:
            return true
        default:
            return false
        }
    }
}
