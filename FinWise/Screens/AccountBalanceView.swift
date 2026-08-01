import SwiftUI

struct AccountBalanceView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

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
                        Text("Account Balance").font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                    BudgetStatsBlock(colors: colors)

                    HStack(spacing: 14) {
                        statCard(icon: "arrow.up.right.square.fill", label: "Income", value: app.totalIncome.asMoney, valueColor: colors.ink)
                        statCard(icon: "arrow.down.right.square.fill", label: "Expense", value: app.totalExpense.asMoney, valueColor: colors.blue)
                    }
                }

                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Transactions").font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        Button {
                            app.selectedTab = .transactions
                            dismiss()
                        } label: {
                            Text("See all").font(.fw(13, .semibold)).foregroundStyle(colors.ink2)
                        }
                        .buttonStyle(.plain)
                    }
                    ForEach(app.transactions.sorted(by: { $0.date > $1.date }).prefix(4)) { t in
                        TransactionRow(t: t, colors: colors)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
    }

    private func statCard(icon: String, label: String, value: String, valueColor: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 18)).foregroundStyle(colors.teal)
            Text(label).font(.fw(13, .medium)).foregroundStyle(colors.ink2)
            Text(value).font(.fw(17, .bold)).foregroundStyle(valueColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(colors.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

#Preview {
    AccountBalanceView().environmentObject(AppState())
}
