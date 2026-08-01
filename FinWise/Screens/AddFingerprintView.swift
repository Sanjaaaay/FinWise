import SwiftUI

struct AddFingerprintView: View {
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss
    @Binding var registered: Bool
    @State private var didAdd = false

    var body: some View {
        Group {
            if didAdd {
                SuccessScreen(message: "Fingerprint Has Been\nAdded Successfully", colors: colors) { dismiss() }
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
                        Text("Add Fingerprint").font(.fw(18, .bold)).foregroundStyle(colors.ink)
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

                    VStack(spacing: 10) {
                        Text("Use Fingerprint To Access").font(.fw(18, .bold)).foregroundStyle(colors.ink)
                        Text("Register your fingerprint to unlock FinWise faster next time.")
                            .font(.fw(13, .medium))
                            .foregroundStyle(colors.ink2)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        registered = true
                        withAnimation(.easeInOut(duration: 0.25)) { didAdd = true }
                    } label: {
                        Text("Use Touch Id")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(colors.pillBg)
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
    AddFingerprintView(registered: .constant(false))
}
