//
//  ComingSoonView.swift
//  self-management
//
//  Placeholder view for features under development
//

import SwiftUI

struct ComingSoonView: View {

    let feature: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("\(feature)")
                .font(.title)
                .fontWeight(.bold)

            Text("Coming Soon")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text("This feature is under development.\nStay tuned!")
                .font(.body)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    ComingSoonView(feature: "Tasks")
}
