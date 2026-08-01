import SwiftUI

struct PasswordSettingsView: View {
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

    @State private var current = ""
    @State private var newPassword = ""
    @State private var confirm = ""
    @State private var didChange = false

    private var isValid: Bool {
        !current.isEmpty && !newPassword.isEmpty && newPassword == confirm
    }

    var body: some View {
        Group {
            if didChange {
                SuccessScreen(message: "Password Has Been\nChanged Successfully", colors: colors) { dismiss() }
            } else {
                form
            }
        }
        .navigationBarHidden(true)
    }

    private var form: some View {
        ScrollView {
            VStack(spacing: 0) {
                HeroHeader(colors: colors) {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(colors.ink)
                                .frame(width: 40, height: 40)
                                .background(colors.card)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        Text("Password Settings").font(.fw(18, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                }

                VStack(spacing: 20) {
                    AuthSecureField(label: "Current Password", text: $current, colors: colors)
                    AuthSecureField(label: "New Password", text: $newPassword, colors: colors)
                    AuthSecureField(label: "Confirm New Password", text: $confirm, colors: colors)

                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) { didChange = true }
                    } label: {
                        Text("Change Password")
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
                .padding(.horizontal, 24)
                .padding(.top, 26)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
    }

}

#Preview {
    PasswordSettingsView().environmentObject(AppState())
}
