import SwiftUI

struct FingerprintListView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss
    @State private var registered = true

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
                        Text("Fingerprint").font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                }

                VStack(spacing: 14) {
                    if registered {
                        NavigationLink {
                            FingerprintDetailView(registered: $registered)
                        } label: {
                            row(icon: "touchid", label: "\(app.displayName.split(separator: " ").first.map(String.init) ?? "My") Fingerprint", iconBg: colors.iconLightBlue)
                        }
                        .buttonStyle(.plain)
                    }
                    NavigationLink {
                        AddFingerprintView(registered: $registered)
                    } label: {
                        row(icon: "plus", label: "Add A Fingerprint", iconBg: colors.iconMediumBlue)
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

    private func row(icon: String, label: String, iconBg: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 46, height: 46)
                .background(iconBg)
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
    FingerprintListView().environmentObject(AppState())
}
