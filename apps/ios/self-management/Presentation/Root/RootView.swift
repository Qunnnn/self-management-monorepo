//
//  RootView.swift
//  self-management
//
//  LEARNING: Root View & Navigation
//
//  This is the app's main navigation hub.
//  It uses TabView to organize different features.
//

import SwiftUI

/// Main navigation container for the app
struct RootView: View {

    // MARK: - State

    @State private var selectedTab: Tab = .notes

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases) { tab in
                Group {
                    switch tab {
                    case .notes:
                        NotesListView()
                    case .tasks, .habits, .finance, .health:
                        ComingSoonView(feature: tab.title)
                    }
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
    }
}

// MARK: - Tab Definition

/// Available tabs in the app
enum Tab: String, CaseIterable, Identifiable {
    case notes
    case tasks
    case habits
    case finance
    case health
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .notes: return "Notes"
        case .tasks: return "Tasks"
        case .habits: return "Habits"
        case .finance: return "Finance"
        case .health: return "Health"
        }
    }
    
    var icon: String {
        switch self {
        case .notes: return "note.text"
        case .tasks: return "checkmark.circle"
        case .habits: return "repeat"
        case .finance: return "dollarsign.circle"
        case .health: return "heart"
        }
    }
}

// MARK: - Preview

#Preview {
    RootView()
        .environment(DependencyContainer())
}
