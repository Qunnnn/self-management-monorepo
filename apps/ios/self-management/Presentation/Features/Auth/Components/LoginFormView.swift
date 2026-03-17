import SwiftUI

struct LoginFormView: View {
    @Binding var email: String
    @Binding var password: String
    @FocusState.Binding var focusedField: LoginFocusField?
    var onSubmit: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            AuthField(
                icon: "envelope.fill",
                placeholder: "Email Address",
                text: $email,
                keyboardType: .emailAddress
            )
            .focused($focusedField, equals: .email)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .password
            }
            
            AuthField(
                icon: "lock.fill",
                placeholder: "Password",
                text: $password,
                isSecure: true
            )
            .focused($focusedField, equals: .password)
            .submitLabel(.done)
            .onSubmit {
                focusedField = nil
                onSubmit()
            }
        }
    }
}
