import SwiftUI

struct SecurityFingerprintView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Security Fingerprint")
                    .font(.fw(24, .bold))
                    .foregroundStyle(colors.ink)
                    .frame(maxWidth: .infinity)
                    .frame(height: 170)
                    .background(colors.teal)
                    .clipShape(.rect(bottomLeadingRadius: 40, bottomTrailingRadius: 40))

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
                        Text("Confirm it\u{2019}s you to unlock FinWise and get back to your budget.")
                            .font(.fw(13, .medium))
                            .foregroundStyle(colors.ink2)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        // No real biometric integration for this demo — treated as a
                        // successful authentication, matching what a real Face/Touch ID
                        // prompt would do on success.
                        app.isLoggedIn = true
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

                    NavigationLink(value: AuthRoute.securityPin) {
                        Text("\u{00BF}Or prefer use pin code?")
                            .font(.fw(13, .medium))
                            .foregroundStyle(colors.ink2)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 30)
                .padding(.top, 30)
                .padding(.bottom, 30)
            }
        }
        .background(colors.bg.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    SecurityFingerprintView().environmentObject(AppState())
}
