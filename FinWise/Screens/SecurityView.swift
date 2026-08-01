import SwiftUI

struct SecurityView: View {
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
                        Text("Security").font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Security").font(.fw(20, .bold)).foregroundStyle(colors.ink)
                        .padding(.bottom, 16)
                    NavigationLink { ChangePinView() } label: { row("Change Pin") }
                        .buttonStyle(.plain)
                    Rectangle().fill(colors.line).frame(height: 1)
                    NavigationLink { FingerprintListView() } label: { row("Fingerprint") }
                        .buttonStyle(.plain)
                    Rectangle().fill(colors.line).frame(height: 1)
                    NavigationLink { TermsAndConditionsView() } label: { row("Terms And Conditions") }
                        .buttonStyle(.plain)
                    Rectangle().fill(colors.line).frame(height: 1)
                }
                .padding(.horizontal, 24)
                .padding(.top, 26)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
    }

    private func row(_ label: String) -> some View {
        HStack {
            Text(label).font(.fw(14.5, .medium)).foregroundStyle(colors.ink)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(colors.ink3)
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    SecurityView().environmentObject(AppState())
}
