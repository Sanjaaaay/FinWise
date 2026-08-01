import SwiftUI

struct CategoryDetailView: View {
    let category: ExpenseCategory
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

    private var groups: [AppState.MonthGroup] {
        app.transactionsByMonth.compactMap { g in
            let items = g.items.filter { $0.category == category }
            return items.isEmpty ? nil : AppState.MonthGroup(id: g.id, label: g.label, items: items)
        }
    }

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
                        Text(category.rawValue).font(.fw(20, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                    BudgetStatsBlock(colors: colors)
                }

                VStack(alignment: .leading, spacing: 16) {
                    if groups.isEmpty {
                        Text("No \(category.rawValue.lowercased()) expenses yet.")
                            .font(.fw(13, .medium))
                            .foregroundStyle(colors.ink2)
                            .frame(maxWidth: .infinity, minHeight: 100)
                    } else {
                        ForEach(groups) { g in
                            Text(g.label).font(.fw(19, .bold)).foregroundStyle(colors.ink)
                            ForEach(g.items) { t in
                                TransactionRow(t: t, colors: colors, showTag: false)
                            }
                        }
                    }

                    Button {
                        app.presentAddExpense(category: category)
                    } label: {
                        Text("Add Expenses")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(colors.teal)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
    }
}

#Preview {
    CategoryDetailView(category: .food).environmentObject(AppState())
}
