import SwiftUI

struct LoginErrorView: View {
    let errorMessage: String?
    
    var body: some View {
        if let error = errorMessage {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                Text(error)
            }
            .font(.footnote.weight(.medium))
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.red.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .transition(.move(edge: .top).combined(with: .opacity))
        } else {
            // Placeholder to avoid layout jumping when error appears
            Color.clear.frame(height: 20)
        }
    }
}
