import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HeroHeader(colors: colors) {
                    TitleRow(title: "Transaction", colors: colors)

                    VStack(spacing: 4) {
                        Text("Total Balance").font(.fw(13, .medium)).foregroundStyle(colors.ink.opacity(0.7))
                        Text(app.totalBalance.asMoney).font(.fw(22, .bold)).foregroundStyle(colors.ink)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(colors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                    BudgetStatsBlock(colors: colors)
                }

                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(app.transactionsByMonth) { group in
                        Text(group.label).font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        ForEach(group.items) { t in
                            TransactionRow(t: t, colors: colors)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
    }
}

#Preview {
    TransactionsView().environmentObject(AppState())
}
