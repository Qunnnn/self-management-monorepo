import SwiftUI

struct LoginBackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.05), Color(uiColor: .systemBackground)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
