import Foundation
import SwiftUI

enum AuthRoute: Hashable {
    case createAccount, forgotPassword, securityPin, newPassword, securityFingerprint
}

enum AnalysisRoute: Hashable {
    case search, calendar
}

final class AppState: ObservableObject {
    // App phase (shown once per launch, in order)
    @Published var showLaunch: Bool = true
    @Published var hasSeenOnboarding: Bool = false

    // Auth
    @Published var isLoggedIn: Bool = false
    @Published var username: String = ""
    @Published var password: String = ""

    func login() {
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.isEmpty else { return }
        isLoggedIn = true
    }

    func logout() {
        isLoggedIn = false
        password = ""
    }

    // Profile
    @Published var displayName: String = "John Smith"
    @Published var userPhone: String = "+44 555 5555 55"
    @Published var userEmail: String = "example@example.com"
    @Published var pushNotificationsEnabled: Bool = true
    @Published var darkThemeEnabled: Bool = false

    // Navigation
    enum MainTab: String, CaseIterable, Identifiable {
        case home, analysis, transactions, categories, profile
        var id: String { rawValue }
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .analysis: return "chart.bar.fill"
            case .transactions: return "arrow.left.arrow.right"
            case .categories: return "square.stack.fill"
            case .profile: return "person.fill"
            }
        }
    }
    @Published var selectedTab: MainTab = .home

    // Money
    @Published var totalBalance: Double = 7783.00
    @Published var monthlyBudget: Double = 20000.00
    /// Matches the source design's fixed "30% Of Your Expenses" caption — the mockup's
    /// three headline numbers aren't internally consistent, so this tracks the mockup's
    /// display value directly rather than being derived from totalExpense/monthlyBudget.
    @Published var budgetUsedPercent: Double = 30

    @Published var transactions: [Transaction] = [
        Transaction(id: "t1", category: .salary, kind: .income, title: "Salary", tag: "Monthly", amount: 4000.00, date: .makeDate(month: 4, day: 30, hour: 18, minute: 27)),
        Transaction(id: "t2", category: .groceries, kind: .expense, title: "Groceries", tag: "Pantry", amount: 100.00, date: .makeDate(month: 4, day: 24, hour: 17, minute: 0)),
        Transaction(id: "t3", category: .rent, kind: .expense, title: "Rent", tag: "Rent", amount: 674.40, date: .makeDate(month: 4, day: 15, hour: 8, minute: 30)),
        Transaction(id: "t4", category: .transport, kind: .expense, title: "Transport", tag: "Fuel", amount: 4.13, date: .makeDate(month: 4, day: 8, hour: 9, minute: 30)),
        Transaction(id: "t5", category: .food, kind: .expense, title: "Food", tag: "Dinner", amount: 70.40, date: .makeDate(month: 3, day: 31, hour: 19, minute: 30)),
        Transaction(id: "t6", category: .savings, kind: .expense, title: "Travel Deposit", tag: "Travel", amount: 217.77, date: .makeDate(month: 4, day: 30, hour: 19, minute: 56)),
        Transaction(id: "t7", category: .savings, kind: .expense, title: "Travel Deposit", tag: "Travel", amount: 217.77, date: .makeDate(month: 4, day: 14, hour: 17, minute: 42)),
        Transaction(id: "t8", category: .savings, kind: .expense, title: "Travel Deposit", tag: "Travel", amount: 217.77, date: .makeDate(month: 4, day: 2, hour: 12, minute: 30))
    ]

    /// Excludes `.savings` deposits — putting money aside isn't spending it, so it
    /// shouldn't inflate the headline expense figure the way a real purchase does.
    var totalExpense: Double {
        transactions.filter { $0.kind == .expense && $0.category != .savings }.map(\.amount).reduce(0, +)
    }

    func savedAmount(for goalName: String) -> Double {
        transactions.filter { $0.category == .savings && $0.tag == goalName }.map(\.amount).reduce(0, +)
    }

    func addSavingsDeposit(goalName: String, amount: Double) {
        guard amount > 0 else { return }
        transactions.append(
            Transaction(id: UUID().uuidString, category: .savings, kind: .expense, title: "\(goalName) Deposit", tag: goalName, amount: amount, date: Date())
        )
    }

    enum HomeRange: String, CaseIterable, Identifiable {
        case daily = "Daily", weekly = "Weekly", monthly = "Monthly"
        var id: String { rawValue }
    }
    @Published var homeRange: HomeRange = .monthly

    /// Transactions visible on Home for the selected range, newest first.
    /// Note: this counts back from each transaction's own recency rank rather than a
    /// real calendar window from "now" — demo data lives in the past (April 2026) while
    /// a freshly-logged expense is dated today, so a real day/week/month window would
    /// either show only the new entry or hide it entirely depending on which side of
    /// "now" the rest of the data falls. Ranking by recency keeps this always sensible.
    var homeTransactions: [Transaction] {
        let sorted = transactions.sorted { $0.date > $1.date }
        switch homeRange {
        case .daily: return Array(sorted.prefix(1))
        case .weekly: return Array(sorted.prefix(3))
        case .monthly: return sorted
        }
    }

    // Add Expense / Income
    @Published var showAddExpense = false
    @Published var draftKind: TransactionKind = .expense
    @Published var draftCategory: ExpenseCategory = .food
    @Published var draftAmountText: String = ""
    @Published var draftTitle: String = ""
    @Published var draftNote: String = ""
    @Published var draftDate: Date = Date()

    /// Tolerates stray "$", "," or whitespace so typed input (especially via a
    /// hardware keyboard in Simulator, which bypasses the decimal-pad restriction)
    /// doesn't silently fail `Double(_:)` and leave Save permanently disabled.
    func parsedAmount(_ text: String) -> Double? {
        let cleaned = text
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: ",", with: "")
        return Double(cleaned)
    }

    var draftIsValid: Bool {
        parsedAmount(draftAmountText).map { $0 > 0 } ?? false
            && !draftTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func presentAddExpense(category: ExpenseCategory = .food) {
        draftKind = .expense
        draftCategory = category
        draftAmountText = ""
        draftTitle = ""
        draftNote = ""
        draftDate = Date()
        showAddExpense = true
    }

    func saveDraftTransaction() {
        guard let amount = parsedAmount(draftAmountText), amount > 0,
              !draftTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        // Income isn't broken down by expense category in this app — Salary is
        // the one category the seed data already treats as income-only.
        let category = draftKind == .income ? .salary : draftCategory
        transactions.append(
            Transaction(id: UUID().uuidString, category: category, kind: draftKind, title: draftTitle, tag: category.rawValue, amount: amount, date: draftDate)
        )
        showAddExpense = false
    }

    // Analysis
    enum AnalysisRange: String, CaseIterable, Identifiable {
        case daily = "Daily", weekly = "Weekly", monthly = "Monthly", yearly = "Year"
        var id: String { rawValue }

        var component: Calendar.Component {
            switch self {
            case .daily: return .day
            case .weekly: return .weekOfYear
            case .monthly: return .month
            case .yearly: return .year
            }
        }

        var labelFormat: String {
            switch self {
            case .daily: return "MMM d"
            case .weekly: return "'Wk'w"
            case .monthly: return "MMM"
            case .yearly: return "yyyy"
            }
        }
    }
    @Published var analysisRange: AnalysisRange = .monthly

    struct PeriodBucket: Identifiable {
        let id = UUID()
        let label: String
        let income: Double
        let expense: Double
        let date: Date
    }

    /// Buckets every transaction by the selected granularity — real data, not the
    /// mockup's placeholder chart values, so this grows as expenses are actually added.
    var analysisBuckets: [PeriodBucket] {
        let range = analysisRange
        let cal = Calendar.current
        var groups: [DateComponents: (income: Double, expense: Double, date: Date)] = [:]
        for t in transactions where t.category != .savings {
            let key = cal.dateComponents([range.component], from: t.date)
            var g = groups[key] ?? (0, 0, t.date)
            if t.kind == .income { g.income += t.amount } else { g.expense += t.amount }
            if t.date < g.date { g.date = t.date }
            groups[key] = g
        }
        let formatter = DateFormatter()
        formatter.dateFormat = range.labelFormat
        return groups.values
            .sorted { $0.date < $1.date }
            .map { PeriodBucket(label: formatter.string(from: $0.date), income: $0.income, expense: $0.expense, date: $0.date) }
    }

    var totalIncome: Double {
        transactions.filter { $0.kind == .income }.map(\.amount).reduce(0, +)
    }

    struct MonthGroup: Identifiable {
        let id: String
        let label: String
        let items: [Transaction]
    }

    /// Every transaction grouped by month, newest month first — used by the full
    /// Transactions tab (Home only ever shows a condensed, ungrouped slice).
    /// Keyed by year+month internally (not just month name) so this doesn't
    /// silently merge e.g. April 2026 with April 2027 once data spans years.
    var transactionsByMonth: [MonthGroup] {
        let keyFormatter = DateFormatter()
        keyFormatter.dateFormat = "yyyy-MM"
        let labelFormatter = DateFormatter()
        labelFormatter.dateFormat = "MMMM"
        let sorted = transactions.sorted { $0.date > $1.date }
        var order: [String] = []
        var buckets: [String: (label: String, items: [Transaction])] = [:]
        for t in sorted {
            let key = keyFormatter.string(from: t.date)
            if buckets[key] == nil {
                order.append(key)
                buckets[key] = (labelFormatter.string(from: t.date), [])
            }
            buckets[key]?.items.append(t)
        }
        return order.map { key in
            let bucket = buckets[key]!
            return MonthGroup(id: key, label: bucket.label, items: bucket.items)
        }
    }

    // Notifications
    @Published var showNotifications = false

    struct NotificationItem: Identifiable {
        let id: String
        let icon: String
        let title: String
        let subtitle: String
        /// Highlighted blue detail line for transaction-linked notifications, e.g. "Groceries | Pantry | -$100.00".
        let detail: String?
        let timeLabel: String
    }

    /// Two evergreen reminders plus one real notification per transaction, newest
    /// first. The mockup groups these under "Today / Yesterday / This Weekend" —
    /// skipped here on purpose: those labels only make sense relative to *now*,
    /// and the demo data is fixed in the past, so a real "today" grouping would
    /// mislabel months-old data the same way the two date-window bugs already did.
    var notifications: [NotificationItem] {
        var items: [NotificationItem] = [
            NotificationItem(id: "n-reminder", icon: "bell.fill", title: "Reminder!", subtitle: "Set up your automatic savings to meet your savings goal\u{2026}", detail: nil, timeLabel: "General"),
            NotificationItem(id: "n-update", icon: "star.fill", title: "New Update", subtitle: "Check out the new Analysis charts.", detail: nil, timeLabel: "General")
        ]
        for t in transactions.sorted(by: { $0.date > $1.date }) {
            items.append(
                NotificationItem(
                    id: "n-tx-\(t.id)",
                    icon: "dollarsign.circle.fill",
                    title: "Transactions",
                    subtitle: "A new transaction has been registered",
                    detail: "\(t.category.rawValue) | \(t.tag) | \(t.signedDisplay)",
                    timeLabel: t.timeString
                )
            )
        }
        return items
    }
}
