//
//  User.swift
//  self-management
//
//  LEARNING: Domain Entity (Auth)
//

import Foundation

/// Represents a user in the self-management system
/// This is a Domain Entity - pure business logic only
struct User: Identifiable, Equatable {
    
    // MARK: - Properties
    
    /// Unique identifier for the user
    let id: String
    
    /// User's email address
    let email: String
    
    /// User's display name
    let name: String
    
    /// URL to user's profile picture
    let profilePictureUrl: URL?
    
    // MARK: - Initialization
    
    init(
        id: String = "",
        email: String,
        name: String,
        profilePictureUrl: URL? = nil
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.profilePictureUrl = profilePictureUrl
    }
}
