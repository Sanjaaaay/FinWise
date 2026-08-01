import SwiftUI

struct DeleteAccountView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

    @State private var password = ""
    @State private var showConfirm = false

    var body: some View {
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
                        Text("Delete Account").font(.fw(18, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                }

                VStack(spacing: 22) {
                    Text("Are You Sure You Want To Delete\nYour Account?")
                        .font(.fw(17, .bold))
                        .foregroundStyle(colors.ink)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("This action will permanently delete all of your data, and you will not be able to recover it. Please keep the following in mind before proceeding:")
                            .font(.fw(13, .medium))
                            .foregroundStyle(colors.ink2)
                        bullet("All your expenses, income and associated transactions will be eliminated.")
                        bullet("You will not be able to access your account or any related information.")
                        bullet("This action cannot be undone.")
                    }
                    .padding(18)
                    .background(colors.pillBg)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                    Text("Please Enter Your Password To Confirm\nDeletion Of Your Account.")
                        .font(.fw(14, .bold))
                        .foregroundStyle(colors.ink)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)

                    SecureField("", text: $password)
                        .font(.fw(15, .medium))
                        .padding(.horizontal, 18)
                        .frame(height: 52)
                        .background(colors.pillBg)
                        .clipShape(Capsule())

                    Button {
                        showConfirm = true
                    } label: {
                        Text("Yes, Delete Account")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(password.isEmpty ? colors.teal.opacity(0.55) : colors.teal)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .disabled(password.isEmpty)

                    Button { dismiss() } label: {
                        Text("Cancel")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(colors.pillBg)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.top, 26)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
        .overlay {
            if showConfirm {
                ConfirmOverlay(
                    title: "Delete Account",
                    message: "By deleting your account, you agree that you understand the consequences of this action and that you agree to permanently delete your account and all associated data.",
                    confirmLabel: "Yes, Delete Account",
                    colors: colors,
                    onConfirm: { app.logout() },
                    onCancel: { showConfirm = false }
                )
            }
        }
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\u{2022}").font(.fw(13, .bold)).foregroundStyle(colors.ink2)
            Text(text).font(.fw(13, .medium)).foregroundStyle(colors.ink2)
        }
    }
}

/// Shared centered confirm/cancel card used by Delete Account and Logout —
/// both mockup screens use the identical white-card-over-dimmed-background pattern.
struct ConfirmOverlay: View {
    let title: String
    let message: String
    let confirmLabel: String
    let colors: ThemeColors
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35).ignoresSafeArea()
                .onTapGesture { onCancel() }

            VStack(spacing: 18) {
                Text(title).font(.fw(19, .bold)).foregroundStyle(colors.ink)
                Text(message)
                    .font(.fw(13, .medium))
                    .foregroundStyle(colors.ink2)
                    .multilineTextAlignment(.center)

                Button(action: onConfirm) {
                    Text(confirmLabel)
                        .font(.fw(15, .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .foregroundStyle(colors.ink)
                        .background(colors.teal)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.fw(15, .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .foregroundStyle(colors.ink)
                        .background(colors.pillBg)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(24)
            .background(colors.card)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    DeleteAccountView().environmentObject(AppState())
}
