import SwiftUI

private struct OnboardingPage {
    let headline: String
    let icon: String
}

private let pages: [OnboardingPage] = [
    OnboardingPage(headline: "Welcome To\nExpense Manager", icon: "dollarsign.circle.fill"),
    OnboardingPage(headline: "\u{00BF}Are You Ready To\nTake Control Of\nYour Finances?", icon: "chart.line.uptrend.xyaxis.circle.fill")
]

struct OnboardingView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @State private var index = 0

    var body: some View {
        VStack(spacing: 0) {
            Text(pages[index].headline)
                .font(.fw(24, .bold))
                .foregroundStyle(colors.ink)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: 260)
                .padding(.horizontal, 30)
                .background(colors.teal)
                .clipShape(.rect(bottomLeadingRadius: 40, bottomTrailingRadius: 40))

            Spacer()

            ZStack {
                Circle().fill(colors.pillBg).frame(width: 220, height: 220)
                Image(systemName: pages[index].icon)
                    .font(.system(size: 84))
                    .foregroundStyle(colors.teal)
            }

            Spacer()

            Button {
                if index < pages.count - 1 {
                    withAnimation(.easeInOut(duration: 0.25)) { index += 1 }
                } else {
                    app.hasSeenOnboarding = true
                }
            } label: {
                Text(index < pages.count - 1 ? "Next" : "Get Started")
                    .font(.fw(20, .bold))
                    .foregroundStyle(colors.ink)
            }
            .buttonStyle(.plain)

            HStack(spacing: 8) {
                ForEach(pages.indices, id: \.self) { i in
                    Circle()
                        .fill(i == index ? colors.teal : Color.clear)
                        .overlay(Circle().stroke(colors.ink3, lineWidth: i == index ? 0 : 1.5))
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.top, 14)
            .padding(.bottom, 40)
        }
        .background(colors.bg.ignoresSafeArea())
    }
}

#Preview {
    OnboardingView().environmentObject(AppState())
}
