import SwiftUI

struct FingerprintDetailView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss
    @Binding var registered: Bool
    @State private var didDelete = false

    private var name: String { "\(app.displayName.split(separator: " ").first.map(String.init) ?? "My") Fingerprint" }

    var body: some View {
        Group {
            if didDelete {
                SuccessScreen(message: "The Fingerprint Has Been\nSuccessfully Deleted.", colors: colors) { dismiss() }
            } else {
                detail
            }
        }
        .navigationBarHidden(true)
    }

    private var detail: some View {
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
                        Text(name).font(.fw(18, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                }

                VStack(spacing: 24) {
                    ZStack {
                        Circle().fill(colors.teal).frame(width: 150, height: 150)
                        Image(systemName: "touchid")
                            .font(.system(size: 68, weight: .light))
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 20)

                    Text(name)
                        .font(.fw(15, .semibold))
                        .foregroundStyle(colors.ink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(colors.pillBg)
                        .clipShape(Capsule())

                    Button {
                        registered = false
                        withAnimation(.easeInOut(duration: 0.25)) { didDelete = true }
                    } label: {
                        Text("Delete")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(colors.teal)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 30)
                .padding(.bottom, 30)
            }
        }
        .background(colors.bg)
    }
}

#Preview {
    FingerprintDetailView(registered: .constant(true)).environmentObject(AppState())
}
