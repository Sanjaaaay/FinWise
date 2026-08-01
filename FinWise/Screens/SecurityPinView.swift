import SwiftUI

struct SecurityPinView: View {
    @Environment(\.fw) private var colors
    @FocusState private var focused: Bool
    @State private var code = ""

    private let length = 6

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Security Pin")
                    .font(.fw(26, .bold))
                    .foregroundStyle(colors.ink)
                    .frame(maxWidth: .infinity)
                    .frame(height: 170)
                    .background(colors.teal)
                    .clipShape(.rect(bottomLeadingRadius: 40, bottomTrailingRadius: 40))

                VStack(spacing: 28) {
                    Text("Enter Security Pin").font(.fw(16, .bold)).foregroundStyle(colors.ink)

                    ZStack {
                        HStack(spacing: 12) {
                            ForEach(0..<length, id: \.self) { i in
                                let digit = i < code.count ? String(Array(code)[i]) : ""
                                Text(digit)
                                    .font(.fw(18, .bold))
                                    .foregroundStyle(colors.ink)
                                    .frame(width: 44, height: 44)
                                    .overlay(Circle().stroke(colors.teal, lineWidth: 1.5))
                            }
                        }
                        TextField("", text: $code)
                            .keyboardType(.numberPad)
                            .focused($focused)
                            .opacity(0.02)
                            .onChange(of: code) { _, newValue in
                                code = String(newValue.filter(\.isNumber).prefix(length))
                            }
                    }
                    .onTapGesture { focused = true }

                    NavigationLink(value: AuthRoute.newPassword) {
                        Text("Accept")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(code.count == length ? colors.teal : colors.teal.opacity(0.55))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .disabled(code.count != length)

                    Button {
                        code = ""
                    } label: {
                        Text("Send Again")
                            .font(.fw(15, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(colors.pillBg)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 26)
                .padding(.top, 30)
                .padding(.bottom, 30)
            }
        }
        .background(colors.bg.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear { focused = true }
    }
}

#Preview {
    SecurityPinView()
}
