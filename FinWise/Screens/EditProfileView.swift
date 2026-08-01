import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var app: AppState
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
                        Text("Edit My Profile").font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }

                    VStack(spacing: 10) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 74))
                                .foregroundStyle(.white)
                            Image(systemName: "camera.fill")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 26, height: 26)
                                .background(colors.blue)
                                .clipShape(Circle())
                        }
                        Text(app.displayName).font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Text("ID: 25030024").font(.fw(12, .semibold)).foregroundStyle(colors.ink.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                }

                VStack(alignment: .leading, spacing: 20) {
                    Text("Account Settings").font(.fw(18, .bold)).foregroundStyle(colors.ink)

                    field(label: "Username", text: $app.displayName, placeholder: "Your name")
                    field(label: "Phone", text: $app.userPhone, placeholder: "+1 555 5555 55")
                    field(label: "Email Address", text: $app.userEmail, placeholder: "example@example.com")

                    toggleRow(label: "Push Notifications", isOn: $app.pushNotificationsEnabled)
                    toggleRow(label: "Turn Dark Theme", isOn: $app.darkThemeEnabled)

                    Button {
                        dismiss()
                    } label: {
                        Text("Update Profile")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(colors.teal)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
                .padding(.top, 26)
                .padding(.bottom, 30)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
    }

    private func field(label: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.fw(13, .semibold)).foregroundStyle(colors.ink)
            TextField(placeholder, text: text)
                .font(.fw(15, .medium))
                .foregroundStyle(colors.ink)
                .padding(.horizontal, 18)
                .frame(height: 52)
                .background(colors.pillBg)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
    }

    private func toggleRow(label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label).font(.fw(15, .semibold)).foregroundStyle(colors.ink)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(colors.teal)
        }
    }
}

#Preview {
    EditProfileView().environmentObject(AppState())
}
