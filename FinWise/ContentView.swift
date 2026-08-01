import SwiftUI

struct ContentView: View {
    @EnvironmentObject var app: AppState

    private var colors: ThemeColors { AppTheme.colors(dark: app.darkThemeEnabled) }

    var body: some View {
        Group {
            if app.showLaunch {
                LaunchView()
            } else if !app.hasSeenOnboarding {
                OnboardingView()
            } else if app.isLoggedIn {
                mainTabs
            } else {
                LoginView()
            }
        }
        .environment(\.fw, colors)
        .preferredColorScheme(app.darkThemeEnabled ? .dark : .light)
        .animation(.easeInOut(duration: 0.25), value: app.showLaunch)
        .animation(.easeInOut(duration: 0.25), value: app.hasSeenOnboarding)
        .animation(.easeInOut(duration: 0.25), value: app.isLoggedIn)
        .animation(.easeInOut(duration: 0.25), value: app.darkThemeEnabled)
    }

    private var mainTabs: some View {
        VStack(spacing: 0) {
            Group {
                switch app.selectedTab {
                case .home: HomeView()
                case .analysis: AnalysisView()
                case .transactions: TransactionsView()
                case .categories: CategoriesView()
                case .profile: ProfileView()
                }
            }
            .frame(maxHeight: .infinity)

            CustomTabBar(selected: $app.selectedTab, colors: colors)
        }
        .background(colors.bg.ignoresSafeArea())
        .sheet(isPresented: $app.showNotifications) {
            NotificationsView()
        }
    }
}

private struct CustomTabBar: View {
    @Binding var selected: AppState.MainTab
    let colors: ThemeColors

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppState.MainTab.allCases) { tab in
                let on = tab == selected
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { selected = tab }
                } label: {
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(on ? .white : colors.ink2)
                        .frame(width: 44, height: 44)
                        .background(on ? colors.teal : Color.clear)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .background(
            colors.pillBg
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .padding(.horizontal, 16)
        )
        .padding(.bottom, 8)
    }
}

#Preview {
    ContentView().environmentObject(AppState())
}
