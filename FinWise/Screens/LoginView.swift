import SwiftUI

struct LoginView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @FocusState private var focusedField: Field?
    @State private var showPassword = false

    private enum Field { case username, password }

    private var isValid: Bool {
        !app.username.trimmingCharacters(in: .whitespaces).isEmpty && !app.password.isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    header
                    form
                }
            }
            .background(colors.bg.ignoresSafeArea())
            .scrollDismissesKeyboard(.interactively)
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .createAccount: CreateAccountView()
                case .forgotPassword: ForgotPasswordView()
                case .securityPin: SecurityPinView()
                case .newPassword: NewPasswordView()
                case .securityFingerprint: SecurityFingerprintView()
                }
            }
        }
    }

    private var header: some View {
        Text("Welcome")
            .font(.fw(30, .bold))
            .foregroundStyle(colors.ink)
            .frame(maxWidth: .infinity)
            .frame(height: 190)
            .background(colors.teal)
            .clipShape(.rect(bottomLeadingRadius: 40, bottomTrailingRadius: 40))
    }

    private var form: some View {
        VStack(alignment: .leading, spacing: 22) {
            field(
                label: "Username Or Email",
                placeholder: "example@example.com",
                text: $app.username,
                isSecure: false,
                focus: .username
            )

            passwordField

            VStack(spacing: 14) {
                Button {
                    app.login()
                } label: {
                    Text("Log In")
                        .font(.fw(17, .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .foregroundStyle(colors.ink)
                        .background(isValid ? colors.teal : colors.teal.opacity(0.55))
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.top, 24)

                NavigationLink(value: AuthRoute.forgotPassword) {
                    Text("Forgot Password?")
                        .font(.fw(13, .semibold))
                        .foregroundStyle(colors.ink)
                }
                .buttonStyle(.plain)

                NavigationLink(value: AuthRoute.createAccount) {
                    Text("Sign Up")
                        .font(.fw(17, .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .foregroundStyle(colors.ink)
                        .background(colors.pillBg)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                }
                .buttonStyle(.plain)
            }

            VStack(spacing: 16) {
                NavigationLink(value: AuthRoute.securityFingerprint) {
                    (Text("Use ") + Text("Fingerprint").foregroundStyle(colors.blue) + Text(" To Access"))
                        .font(.fw(13, .semibold))
                        .foregroundStyle(colors.ink)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)

                Text("or sign up with")
                    .font(.fw(12, .medium))
                    .foregroundStyle(colors.ink3)
                    .frame(maxWidth: .infinity)

                HStack(spacing: 20) {
                    socialCircle("f")
                    socialCircle("G")
                }
                .frame(maxWidth: .infinity)

                (Text("Don\u{2019}t have an account? ") + Text("Sign Up").foregroundStyle(colors.blue))
                    .font(.fw(13, .medium))
                    .foregroundStyle(colors.ink)
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 26)
        .padding(.top, 28)
        .padding(.bottom, 30)
    }

    private func field(label: String, placeholder: String, text: Binding<String>, isSecure: Bool, focus: Field) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.fw(13, .semibold)).foregroundStyle(colors.ink)
            TextField(placeholder, text: text)
                .font(.fw(15, .medium))
                .foregroundStyle(colors.ink)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focusedField, equals: focus)
                .padding(.horizontal, 18)
                .frame(height: 52)
                .background(colors.fieldBg)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password").font(.fw(13, .semibold)).foregroundStyle(colors.ink)
            HStack {
                Group {
                    if showPassword {
                        TextField("", text: $app.password)
                    } else {
                        SecureField("", text: $app.password)
                    }
                }
                .font(.fw(15, .medium))
                .foregroundStyle(colors.ink)
                .focused($focusedField, equals: .password)

                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(colors.ink2)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
            .frame(height: 52)
            .background(colors.fieldBg)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
    }

    private func socialCircle(_ letter: String) -> some View {
        Text(letter)
            .font(.fw(18, .bold))
            .foregroundStyle(colors.ink)
            .frame(width: 52, height: 52)
            .background(colors.card)
            .clipShape(Circle())
            .overlay(Circle().stroke(colors.line, lineWidth: 1))
    }
}

#Preview {
    LoginView().environmentObject(AppState())
}
