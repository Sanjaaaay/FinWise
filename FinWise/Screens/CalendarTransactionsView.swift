import SwiftUI

private enum CalTab: String, CaseIterable, Identifiable {
    case spends = "Spends", categories = "Categories"
    var id: String { rawValue }
}

struct CalendarTransactionsView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

    @State private var monthDate: Date
    @State private var selectedDay: Date?
    @State private var tab: CalTab = .spends

    init() {
        _monthDate = State(initialValue: Date())
    }

    private var calendar: Calendar { Calendar.current }

    private var monthDays: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: monthDate),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate))
        else { return [] }
        // Monday-first weekday index (0 = Mon ... 6 = Sun)
        let weekday = (calendar.component(.weekday, from: firstOfMonth) + 5) % 7
        var days: [Date?] = Array(repeating: nil, count: weekday)
        for d in range {
            if let date = calendar.date(byAdding: .day, value: d - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        return days
    }

    private var dayTransactions: [Transaction] {
        guard let selectedDay else { return [] }
        return app.transactions.filter { calendar.isDate($0.date, inSameDayAs: selectedDay) }
    }

    private var categoryTotals: [(category: ExpenseCategory, total: Double)] {
        let monthTx = app.transactions.filter { calendar.isDate($0.date, equalTo: monthDate, toGranularity: .month) && $0.kind == .expense }
        var totals: [ExpenseCategory: Double] = [:]
        for t in monthTx { totals[t.category, default: 0] += t.amount }
        return totals.map { ($0.key, $0.value) }.sorted { $0.total > $1.total }
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
                        Text("Calendar").font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        monthStepper
                        Spacer()
                        Text(monthDate.formatted(.dateTime.year())).font(.fw(15, .bold)).foregroundStyle(colors.teal)
                    }

                    HStack(spacing: 0) {
                        ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { d in
                            Text(d).font(.fw(11, .semibold)).foregroundStyle(colors.blue)
                                .frame(maxWidth: .infinity)
                        }
                    }

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 14) {
                        ForEach(Array(monthDays.enumerated()), id: \.offset) { _, day in
                            if let day {
                                let isSelected = selectedDay.map { calendar.isDate($0, inSameDayAs: day) } ?? false
                                Button {
                                    selectedDay = isSelected ? nil : day
                                } label: {
                                    Text("\(calendar.component(.day, from: day))")
                                        .font(.fw(13, isSelected ? .bold : .medium))
                                        .foregroundStyle(isSelected ? .white : colors.ink)
                                        .frame(width: 32, height: 32)
                                        .background(isSelected ? colors.teal : Color.clear)
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                            } else {
                                Color.clear.frame(width: 32, height: 32)
                            }
                        }
                    }

                    SegmentedToggle(selected: $tab, label: \.rawValue, colors: colors)
                        .padding(.top, 6)

                    if tab == .spends {
                        let items = selectedDay != nil ? dayTransactions : app.transactions.filter { calendar.isDate($0.date, equalTo: monthDate, toGranularity: .month) }
                        if items.isEmpty {
                            Text("No transactions \(selectedDay != nil ? "on this day" : "this month").")
                                .font(.fw(13, .medium))
                                .foregroundStyle(colors.ink2)
                                .frame(maxWidth: .infinity, minHeight: 80)
                        } else {
                            ForEach(items.sorted(by: { $0.date > $1.date })) { t in
                                TransactionRow(t: t, colors: colors)
                            }
                        }
                    } else {
                        if categoryTotals.isEmpty {
                            Text("No expenses this month.")
                                .font(.fw(13, .medium))
                                .foregroundStyle(colors.ink2)
                                .frame(maxWidth: .infinity, minHeight: 80)
                        } else {
                            ForEach(categoryTotals, id: \.category) { entry in
                                HStack(spacing: 14) {
                                    Image(systemName: entry.category.icon)
                                        .foregroundStyle(.white)
                                        .frame(width: 40, height: 40)
                                        .background(entry.category.iconBg(colors))
                                        .clipShape(Circle())
                                    Text(entry.category.rawValue).font(.fw(14, .semibold)).foregroundStyle(colors.ink)
                                    Spacer()
                                    Text(entry.total.asMoney).font(.fw(14, .bold)).foregroundStyle(colors.blue)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
    }

    private var monthStepper: some View {
        HStack(spacing: 10) {
            Button {
                if let prev = calendar.date(byAdding: .month, value: -1, to: monthDate) { monthDate = prev; selectedDay = nil }
            } label: {
                Image(systemName: "chevron.left").font(.system(size: 12, weight: .semibold)).foregroundStyle(colors.teal)
            }
            .buttonStyle(.plain)
            Text(monthDate.formatted(.dateTime.month(.wide))).font(.fw(15, .bold)).foregroundStyle(colors.teal)
            Button {
                if let next = calendar.date(byAdding: .month, value: 1, to: monthDate) { monthDate = next; selectedDay = nil }
            } label: {
                Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundStyle(colors.teal)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    CalendarTransactionsView().environmentObject(AppState())
}
