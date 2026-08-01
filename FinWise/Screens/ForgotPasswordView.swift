import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Forgot Password")
                    .font(.fw(26, .bold))
                    .foregroundStyle(colors.ink)
                    .frame(maxWidth: .infinity)
                    .frame(height: 170)
                    .background(colors.teal)
                    .clipShape(.rect(bottomLeadingRadius: 40, bottomTrailingRadius: 40))

                VStack(alignment: .leading, spacing: 20) {
                    Text("Reset Password?").font(.fw(20, .bold)).foregroundStyle(colors.ink)
                    Text("Enter the email associated with your account and we\u{2019}ll send a code to reset your password.")
                        .font(.fw(13, .medium))
                        .foregroundStyle(colors.ink2)

                    AuthField(label: "Enter Email Address", placeholder: "example@example.com", text: $email, colors: colors, keyboardType: .emailAddress)
                        .padding(.top, 6)

                    NavigationLink(value: AuthRoute.securityPin) {
                        Text("Next Step")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(email.trimmingCharacters(in: .whitespaces).isEmpty ? colors.teal.opacity(0.55) : colors.teal)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .disabled(email.trimmingCharacters(in: .whitespaces).isEmpty)
                    .padding(.top, 8)

                    Spacer(minLength: 60)

                    Button {
                        dismiss()
                    } label: {
                        Text("Sign Up")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(colors.pillBg)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 26)
                .padding(.top, 26)
                .padding(.bottom, 30)
            }
        }
        .background(colors.bg.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    ForgotPasswordView().environmentObject(AppState())
}
