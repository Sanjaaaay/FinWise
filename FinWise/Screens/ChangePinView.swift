import SwiftUI

struct ChangePinView: View {
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

    @State private var current = ""
    @State private var new = ""
    @State private var confirm = ""
    @State private var didChange = false

    private var isValid: Bool {
        !current.isEmpty && !new.isEmpty && new == confirm
    }

    var body: some View {
        Group {
            if didChange {
                SuccessScreen(message: "Pin Has Been\nChanged Successfully", colors: colors) { dismiss() }
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
                        Text("Change Pin").font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                }

                VStack(spacing: 20) {
                    pinField(label: "Current Pin", text: $current)
                    pinField(label: "New Pin", text: $new)
                    pinField(label: "Confirm Pin", text: $confirm)

                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) { didChange = true }
                    } label: {
                        Text("Change Pin")
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

    private func pinField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.fw(13, .semibold)).foregroundStyle(colors.ink)
            SecureField("", text: text)
                .keyboardType(.numberPad)
                .font(.fw(15, .medium))
                .foregroundStyle(colors.ink)
                .padding(.horizontal, 18)
                .frame(height: 52)
                .background(colors.pillBg)
                .clipShape(Capsule())
        }
    }
}

/// The full-screen teal "X Has Been Y Successfully" state shared by Password
/// Settings, Change Pin, and the Fingerprint flows — each mockup screen for
/// these uses the identical checkmark-ring-on-teal layout.
struct SuccessScreen: View {
    let message: String
    let colors: ThemeColors
    var onTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 22) {
            Spacer()
            ZStack {
                Circle().stroke(Color.white.opacity(0.6), lineWidth: 3).frame(width: 90, height: 90)
                Circle().fill(Color.white).frame(width: 10, height: 10)
            }
            Text(message)
                .font(.fw(19, .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colors.teal.ignoresSafeArea())
        .onTapGesture(perform: onTap)
    }
}

#Preview {
    ChangePinView()
}
