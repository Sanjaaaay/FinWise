import SwiftUI

struct SettingsView: View {
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

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
                        Text("Settings").font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                }

                VStack(spacing: 14) {
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        row(icon: "bell.fill", label: "Notification Settings")
                    }
                    .buttonStyle(.plain)
                    NavigationLink {
                        PasswordSettingsView()
                    } label: {
                        row(icon: "key.fill", label: "Password Settings")
                    }
                    .buttonStyle(.plain)
                    NavigationLink {
                        DeleteAccountView()
                    } label: {
                        row(icon: "person.fill", label: "Delete Account")
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.top, 28)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
    }

    private func row(icon: String, label: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(colors.teal)
                .clipShape(Circle())
            Text(label).font(.fw(15, .semibold)).foregroundStyle(colors.ink)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(colors.ink3)
        }
    }
}

#Preview {
    SettingsView().environmentObject(AppState())
}
