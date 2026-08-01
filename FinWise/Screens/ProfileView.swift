import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @State private var showLogoutConfirm = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    HeroHeader(colors: colors) {
                        TitleRow(title: "Profile", colors: colors)
                        VStack(spacing: 10) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 74))
                                .foregroundStyle(.white)
                            Text(app.displayName).font(.fw(19, .bold)).foregroundStyle(colors.ink)
                            Text("ID: 25030024").font(.fw(12, .semibold)).foregroundStyle(colors.ink.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                    }

                    VStack(spacing: 14) {
                        NavigationLink {
                            EditProfileView()
                        } label: {
                            menuRow(icon: "person.fill", label: "Edit Profile", iconBg: colors.iconLightBlue)
                        }
                        .buttonStyle(.plain)
                        NavigationLink {
                            SecurityView()
                        } label: {
                            menuRow(icon: "shield.fill", label: "Security", iconBg: colors.iconMediumBlue)
                        }
                        .buttonStyle(.plain)
                        NavigationLink {
                            SettingsView()
                        } label: {
                            menuRow(icon: "gearshape.fill", label: "Setting", iconBg: colors.iconMediumBlue)
                        }
                        .buttonStyle(.plain)
                        NavigationLink {
                            HelpView()
                        } label: {
                            menuRow(icon: "questionmark.circle.fill", label: "Help", iconBg: colors.iconLightBlue)
                        }
                        .buttonStyle(.plain)
                        Button {
                            showLogoutConfirm = true
                        } label: {
                            menuRow(icon: "rectangle.portrait.and.arrow.right.fill", label: "Logout", iconBg: colors.iconMediumBlue)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 30)
                    .padding(.bottom, 24)
                }
            }
            .background(colors.bg)
        }
        .overlay {
            if showLogoutConfirm {
                ConfirmOverlay(
                    title: "End Session",
                    message: "Are you sure you want to log out?",
                    confirmLabel: "Yes, End Session",
                    colors: colors,
                    onConfirm: { app.logout() },
                    onCancel: { showLogoutConfirm = false }
                )
            }
        }
    }

    private func menuRow(icon: String, label: String, iconBg: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 46, height: 46)
                .background(iconBg)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            Text(label).font(.fw(16, .semibold)).foregroundStyle(colors.ink)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(colors.ink3)
        }
    }
}

#Preview {
    ProfileView().environmentObject(AppState())
}
