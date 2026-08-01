import SwiftUI

struct TermsAndConditionsView: View {
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss
    @State private var accepted = false

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
                        Text("Terms And Conditions").font(.fw(17, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("FinWise Terms Of Service")
                        .font(.fw(16, .bold))
                        .foregroundStyle(colors.ink)

                    Text("""
                    Welcome to FinWise. By using this app you agree to track your expenses and income honestly and to keep your account credentials secure.

                    1. Your data is stored locally on your device.
                    2. You are responsible for the accuracy of the transactions you record.
                    3. FinWise does not provide financial or investment advice.
                    4. You may delete your account and all associated data at any time from Settings.

                    We may update these terms as the app evolves. Continued use of FinWise after an update means you accept the revised terms.
                    """)
                    .font(.fw(13, .medium))
                    .foregroundStyle(colors.ink2)

                    Button {
                        accepted.toggle()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: accepted ? "checkmark.square.fill" : "square")
                                .foregroundStyle(accepted ? colors.teal : colors.ink3)
                            Text("I accept all the terms and conditions")
                                .font(.fw(13, .medium))
                                .foregroundStyle(colors.ink)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 6)

                    Button {
                        dismiss()
                    } label: {
                        Text("Accept")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(accepted ? colors.teal : colors.teal.opacity(0.55))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .disabled(!accepted)
                }
                .padding(.horizontal, 24)
                .padding(.top, 26)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
    }
}

#Preview {
    TermsAndConditionsView().environmentObject(AppState())
}
