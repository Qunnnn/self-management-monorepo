//
//  NetworkConfig.swift
//  self-management
//
//  Central source for networking configuration.
//

import Foundation

/// Central configuration for network settings across the app
enum NetworkConfig {
    
    /// The current base URL for API requests.
    ///
    /// - Important: For development on a physical device, ensure the URL matches your machine's 
    /// local network IP (e.g. 192.168.x.x) or hostname (e.g. my-mac.local).
    /// For the simulator, 'localhost' should suffice if the backend is running locally.
    static var baseURL: URL {
        #if targetEnvironment(simulator)
        return URL(string: "http://localhost:8080")!
        #else
        // Using the raw machine IP for maximum reliability across all network environments.
        return URL(string: "http://192.168.100.171:8080")!
        #endif
    }
}
