//
//  RequestInterceptor.swift
//  self-management
//

import Foundation

/// A protocol that defines methods that can be used to intercept a network request.
/// Similar to Flutter's Dio interceptors or Alamofire's RequestInterceptor.
protocol RequestInterceptor {
    
    /// Called before the request is executed to adapt its values (e.g., add headers).
    /// - Parameter request: The request that is about to be executed.
    /// - Returns: The adapted request.
    func adapt(_ request: URLRequest) async throws -> URLRequest
    
    /// Called when a request fails to decide whether it should be retried.
    /// - Parameters:
    ///   - request: The request that failed.
    ///   - error: The error that caused the failure.
    /// - Returns: A boolean indicating whether the request should be retried.
    func retry(_ request: URLRequest, for error: Error) async throws -> Bool
}
