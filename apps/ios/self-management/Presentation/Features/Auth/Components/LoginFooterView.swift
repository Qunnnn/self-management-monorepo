import SwiftUI

struct LoginFooterView: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .foregroundStyle(.secondary)
            Button("Sign Up") {
                // FUTURE: Navigate to SignUp
            }
            .fontWeight(.bold)
            .foregroundStyle(.blue)
        }
        .font(.subheadline)
    }
}
