import SwiftUI
import Charts

struct AnalysisView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    HeroHeader(colors: colors) {
                        TitleRow(title: "Analysis", colors: colors)
                        BudgetStatsBlock(colors: colors)
                    }

                    VStack(spacing: 20) {
                        SegmentedToggle(selected: $app.analysisRange, label: \.rawValue, colors: colors)
                        chartCard
                        totalsRow
                        myTargets
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                }
            }
            .background(colors.bg)
            .navigationDestination(for: AnalysisRoute.self) { route in
                switch route {
                case .search: SearchTransactionsView()
                case .calendar: CalendarTransactionsView()
                }
            }
        }
    }

    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Income & Expenses").font(.fw(15, .bold)).foregroundStyle(colors.ink)
                Spacer()
                NavigationLink(value: AnalysisRoute.search) { iconCircle("magnifyingglass") }
                    .buttonStyle(.plain)
                NavigationLink(value: AnalysisRoute.calendar) { iconCircle("calendar") }
                    .buttonStyle(.plain)
            }

            if app.analysisBuckets.isEmpty {
                Text("No transactions yet for this range.")
                    .font(.fw(13, .medium))
                    .foregroundStyle(colors.ink2)
                    .frame(maxWidth: .infinity, minHeight: 160)
            } else {
                Chart(app.analysisBuckets) { bucket in
                    BarMark(x: .value("Period", bucket.label), y: .value("Income", bucket.income))
                        .position(by: .value("Kind", "Income"))
                        .foregroundStyle(colors.teal)
                        .cornerRadius(3)
                    BarMark(x: .value("Period", bucket.label), y: .value("Expense", bucket.expense))
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
                        AxisValueLabel().font(.fw(10, .medium)).foregroundStyle(colors.ink3)
                    }
                }
                .frame(height: 190)
            }
        }
        .padding(18)
        .background(colors.pillBg)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
    }

    private func iconCircle(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 32, height: 32)
            .background(colors.teal)
            .clipShape(Circle())
    }

    private var totalsRow: some View {
        HStack {
            totalStat(icon: "arrow.up.right.square.fill", label: "Income", value: app.totalIncome.asMoney, color: colors.teal)
            Spacer()
            totalStat(icon: "arrow.down.right.square.fill", label: "Expense", value: app.totalExpense.asMoney, color: colors.blue)
            Spacer()
        }
    }

    private func totalStat(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(color)
            Text(label).font(.fw(13, .medium)).foregroundStyle(colors.ink2)
            Text(value).font(.fw(16, .bold)).foregroundStyle(colors.ink)
        }
    }

    private var myTargets: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("My Targets").font(.fw(16, .bold)).foregroundStyle(colors.ink)
            Text("Coming soon.").font(.fw(12, .medium)).foregroundStyle(colors.ink2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AnalysisView().environmentObject(AppState())
}
