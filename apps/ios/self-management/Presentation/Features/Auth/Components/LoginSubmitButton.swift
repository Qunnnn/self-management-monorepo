import SwiftUI

struct LoginSubmitButton: View {
    let isLoading: Bool
    let isValid: Bool
    let action: () -> Void
    
    var body: some View {
        Button (action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Sign In")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: isValid ? [.blue, .purple] : [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundStyle(isValid ? .white : .red)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: isValid ? .blue.opacity(0.3) : .clear, radius: 10, x: 0, y: 5)
            .scaleEffect(isLoading ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: isLoading)
        }
        .disabled(!isValid || isLoading)
    }
}
