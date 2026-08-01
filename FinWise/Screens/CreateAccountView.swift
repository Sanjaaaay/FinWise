import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

    @State private var fullName = ""
    @State private var email = ""
    @State private var mobile = ""
    @State private var dob = Date()
    @State private var password = ""
    @State private var confirmPassword = ""

    private var isValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty && password == confirmPassword
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Create Account")
                    .font(.fw(28, .bold))
                    .foregroundStyle(colors.ink)
                    .frame(maxWidth: .infinity)
                    .frame(height: 170)
                    .background(colors.teal)
                    .clipShape(.rect(bottomLeadingRadius: 40, bottomTrailingRadius: 40))

                VStack(spacing: 20) {
                    AuthField(label: "Full Name", placeholder: "example@example.com", text: $fullName, colors: colors)
                    AuthField(label: "Email", placeholder: "example@example.com", text: $email, colors: colors, keyboardType: .emailAddress)
                    AuthField(label: "Mobile Number", placeholder: "+ 123 456 789", text: $mobile, colors: colors, keyboardType: .phonePad)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date Of Birth").font(.fw(13, .semibold)).foregroundStyle(colors.ink)
                        HStack {
                            Text(dob.formatted(.dateTime.day().month().year()))
                                .font(.fw(15, .medium))
                                .foregroundStyle(colors.ink)
                            Spacer()
                        }
                        .padding(.horizontal, 18)
                        .frame(height: 52)
                        .background(colors.fieldBg)
                        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                        .overlay(
                            DatePicker("", selection: $dob, displayedComponents: .date)
                                .labelsHidden()
                                .opacity(0.02)
                        )
                    }

                    AuthSecureField(label: "Password", text: $password, colors: colors)
                    AuthSecureField(label: "Confirm Password", text: $confirmPassword, colors: colors)

                    Text("By continuing, you agree to **Terms of Use** and **Privacy Policy**.")
                        .font(.fw(12, .medium))
                        .foregroundStyle(colors.ink2)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 6)

                    Button {
                        // Account creation validated locally above (isValid) — no separate
                        // backend, so this directly signs the new account in.
                        app.displayName = fullName
                        app.userEmail = email
                        app.isLoggedIn = true
                    } label: {
                        Text("Sign Up")
                            .font(.fw(17, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .foregroundStyle(colors.ink)
                            .background(isValid ? colors.teal : colors.teal.opacity(0.55))
                            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .disabled(!isValid)

                    Button {
                        dismiss()
                    } label: {
                        (Text("Already have an account? ") + Text("Log In").foregroundStyle(colors.blue))
                            .font(.fw(13, .medium))
                            .foregroundStyle(colors.ink)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 26)
                .padding(.top, 26)
                .padding(.bottom, 30)
            }
        }
        .background(colors.bg.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    CreateAccountView().environmentObject(AppState())
}
