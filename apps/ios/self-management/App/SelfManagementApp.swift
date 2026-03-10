//
//  SelfManagementApp.swift
//  self-management
//
//  Main application entry point
//  This is where the app starts and dependencies are configured
//

import SwiftUI

@main
struct SelfManagementApp: App {

    // MARK: - Dependencies

    /// Dependency container holds all app-wide dependencies
    /// We use @State to ensure it persists across view updates
    @State private var container = DependencyContainer()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            RootView(
                loginUseCase: container.loginUseCase,
                sessionService: container.sessionService
            )
            .environment(container)
        }
    }
}
