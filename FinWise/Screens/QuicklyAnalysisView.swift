import SwiftUI
import Charts

private struct WeekBucket: Identifiable {
    let id: Int
    let label: String
    let income: Double
    let expense: Double
}

struct QuicklyAnalysisView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

    /// The most recent calendar month actually present in the data — not
    /// necessarily the real "today" (demo transactions live in the past), and
    /// transactions are scoped to just this one month so "week of month" numbers
    /// from different months never collide in the same bucket.
    private var latestMonthTransactions: [Transaction] {
        guard let latest = app.transactions.map(\.date).max() else { return [] }
        let cal = Calendar.current
        return app.transactions.filter { cal.isDate($0.date, equalTo: latest, toGranularity: .month) }
    }

    private var monthLabel: String {
        let reference = app.transactions.map(\.date).max() ?? Date()
        return reference.formatted(.dateTime.month(.wide))
    }

    /// Buckets by week-of-month rather than reusing Analysis's shared `analysisRange`
    /// toggle, so opening this quick view doesn't silently change what the Analysis
    /// tab itself is set to show.
    private var weeklyBuckets: [WeekBucket] {
        let cal = Calendar.current
        var groups: [Int: (income: Double, expense: Double)] = [:]
        for t in latestMonthTransactions {
            let week = cal.component(.weekOfMonth, from: t.date)
            var g = groups[week] ?? (0, 0)
            if t.kind == .income { g.income += t.amount } else { g.expense += t.amount }
            groups[week] = g
        }
        return groups.keys.sorted().map { w in
            let g = groups[w]!
            return WeekBucket(id: w, label: ordinal(w), income: g.income, expense: g.expense)
        }
    }

    private func ordinal(_ w: Int) -> String {
        switch w {
        case 1: return "1st Week"
        case 2: return "2nd Week"
        case 3: return "3rd Week"
        default: return "\(w)th Week"
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
                        Text("Quickly Analysis").font(.fw(18, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }

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

                VStack(alignment: .leading, spacing: 16) {
                    Text("\(monthLabel) Expenses")
                        .font(.fw(15, .bold))
                        .foregroundStyle(colors.ink)

                    if weeklyBuckets.isEmpty {
                        Text("No transactions yet.")
                            .font(.fw(13, .medium))
                            .foregroundStyle(colors.ink2)
                            .frame(maxWidth: .infinity, minHeight: 100)
                    } else {
                        Chart(weeklyBuckets) { bucket in
                            BarMark(x: .value("Week", bucket.label), y: .value("Income", bucket.income))
                                .position(by: .value("Kind", "Income"))
                                .foregroundStyle(colors.teal)
                                .cornerRadius(3)
                            BarMark(x: .value("Week", bucket.label), y: .value("Expense", bucket.expense))
                                .position(by: .value("Kind", "Expense"))
                                .foregroundStyle(colors.blue)
                                .cornerRadius(3)
                        }
                        .chartLegend(.hidden)
                        .chartYAxis {
                            AxisMarks(position: .leading) { _ in
                                AxisGridLine().foregroundStyle(colors.line)
                                AxisValueLabel().font(.fw(9, .medium)).foregroundStyle(colors.ink3)
                            }
                        }
                        .chartXAxis {
                            AxisMarks { _ in
                                AxisValueLabel().font(.fw(9, .medium)).foregroundStyle(colors.ink3)
                            }
                        }
                        .frame(height: 170)
                    }

                    ForEach(app.transactions.sorted(by: { $0.date > $1.date }).prefix(3)) { t in
                        TransactionRow(t: t, colors: colors)
                    }
                }
                .padding(18)
                .background(colors.pillBg)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
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
}

#Preview {
    QuicklyAnalysisView().environmentObject(AppState())
}
