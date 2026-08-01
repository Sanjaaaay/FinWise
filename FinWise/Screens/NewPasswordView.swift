import SwiftUI

struct NewPasswordView: View {
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss
    @State private var password = ""
    @State private var confirm = ""
    @State private var didChange = false

    private var isValid: Bool { !password.isEmpty && password == confirm }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("New Password")
                    .font(.fw(26, .bold))
                    .foregroundStyle(colors.ink)
                    .frame(maxWidth: .infinity)
                    .frame(height: 170)
                    .background(colors.teal)
                    .clipShape(.rect(bottomLeadingRadius: 40, bottomTrailingRadius: 40))

                VStack(spacing: 20) {
                    AuthSecureField(label: "New Password", text: $password, colors: colors)
                    AuthSecureField(label: "Confirm New Password", text: $confirm, colors: colors)

                    Button {
                        didChange = true
                    } label: {
                        Text(didChange ? "Password Changed \u{2713}" : "Change Password")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(isValid ? colors.teal : colors.teal.opacity(0.55))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .disabled(!isValid)
                    .padding(.top, 10)
                }
                .padding(.horizontal, 26)
                .padding(.top, 30)
                .padding(.bottom, 30)
            }
        }
        .background(colors.bg.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    NewPasswordView()
}
