import SwiftUI

private enum HomeRoute: Hashable {
    case accountBalance, quicklyAnalysis
}

struct HomeView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 0) {
                        header
                        VStack(spacing: 20) {
                            savingsCard
                            rangeToggle
                            transactionList
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 24)
                    }
                }
                .background(colors.bg)

                Button {
                    app.presentAddExpense()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 58, height: 58)
                        .background(colors.teal)
                        .clipShape(Circle())
                        .shadow(color: colors.teal.opacity(0.45), radius: 14, x: 0, y: 8)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 20)
                .padding(.bottom, 16)
            }
            .sheet(isPresented: $app.showAddExpense) {
                AddExpenseView()
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .accountBalance: AccountBalanceView()
                case .quicklyAnalysis: QuicklyAnalysisView()
                }
            }
        }
    }

    private var header: some View {
        HeroHeader(colors: colors) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hi, Welcome Back").font(.fw(20, .bold)).foregroundStyle(colors.ink)
                    Text("Good Morning").font(.fw(13, .medium)).foregroundStyle(colors.ink.opacity(0.65))
                }
                Spacer()
                NotificationBellButton(colors: colors)
            }
            NavigationLink(value: HomeRoute.accountBalance) {
                BudgetStatsBlock(colors: colors)
            }
            .buttonStyle(.plain)
        }
    }

    private var savingsCard: some View {
        NavigationLink(value: HomeRoute.quicklyAnalysis) {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle().stroke(colors.card.opacity(0.35), lineWidth: 4).frame(width: 62, height: 62)
                        Circle().trim(from: 0, to: 0.6).stroke(colors.blue, lineWidth: 4)
                            .frame(width: 62, height: 62).rotationEffect(.degrees(-90))
                        Image(systemName: "car.fill").foregroundStyle(colors.card).font(.system(size: 20))
                    }
                    Text("Savings\nOn Goals")
                        .font(.fw(13, .semibold))
                        .foregroundStyle(colors.card)
                        .multilineTextAlignment(.leading)

                    Rectangle().fill(colors.card.opacity(0.35)).frame(width: 1, height: 44)

                    VStack(alignment: .leading, spacing: 12) {
                        statRow(icon: "square.stack.3d.up.fill", label: "Revenue Last Week", value: "$4,000.00")
                        Rectangle().fill(colors.card.opacity(0.35)).frame(height: 1)
                        statRow(icon: "fork.knife", label: "Food Last Week", value: "-$100.00")
                    }
                }
            }
            .padding(18)
            .background(colors.teal)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func statRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 12)).foregroundStyle(colors.card)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.fw(11, .medium)).foregroundStyle(colors.card.opacity(0.85))
                Text(value).font(.fw(13, .bold)).foregroundStyle(colors.card)
            }
        }
    }

    private var rangeToggle: some View {
        SegmentedToggle(selected: $app.homeRange, label: \.rawValue, colors: colors)
    }

    private var transactionList: some View {
        VStack(spacing: 14) {
            ForEach(app.homeTransactions) { t in
                TransactionRow(t: t, colors: colors)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: app.homeRange)
    }
}

#Preview {
    HomeView().environmentObject(AppState())
}
