import SwiftUI

enum ExpenseCategory: String, CaseIterable, Identifiable {
    case salary = "Salary"
    case food = "Food"
    case transport = "Transport"
    case medicine = "Medicine"
    case groceries = "Groceries"
    case rent = "Rent"
    case gifts = "Gifts"
    case savings = "Savings"
    case entertainment = "Entertainment"

    var id: String { rawValue }

    /// The tiles shown in the Categories grid — Salary is income-only, not a spending category.
    static let gridCategories: [ExpenseCategory] = [.food, .transport, .medicine, .groceries, .rent, .gifts, .savings, .entertainment]

    var icon: String {
        switch self {
        case .salary: return "banknote.fill"
        case .food: return "fork.knife"
        case .transport: return "bus.fill"
        case .medicine: return "cross.case.fill"
        case .groceries: return "cart.fill"
        case .rent: return "key.fill"
        case .gifts: return "gift.fill"
        case .savings: return "dollarsign.circle.fill"
        case .entertainment: return "ticket.fill"
        }
    }

    func iconBg(_ colors: ThemeColors) -> Color {
        self == .salary ? colors.iconLightBlue : colors.iconMediumBlue
    }
}

enum TransactionKind: String, CaseIterable, Identifiable {
    case expense = "Expense", income = "Income"
    var id: String { rawValue }
}

struct Transaction: Identifiable {
    let id: String
    let category: ExpenseCategory
    let kind: TransactionKind
    let title: String
    /// Secondary tag shown next to the date, e.g. "Monthly", "Pantry", "Fuel".
    let tag: String
    let amount: Double
    let date: Date

    var signedDisplay: String {
        kind == .expense ? "-\(amount.asMoney)" : amount.asMoney
    }

    var timeString: String {
        let f = DateFormatter()
        f.dateFormat = "H:mm - MMMM d"
        return f.string(from: date)
    }
}

struct SavingsGoal: Identifiable {
    let id: String
    let name: String
    let icon: String
    let goalAmount: Double
    /// Only Travel has real deposit history in the seed data — the rest start at
    /// $0 saved rather than inventing progress the mockup never actually specified.
    static let all: [SavingsGoal] = [
        SavingsGoal(id: "travel", name: "Travel", icon: "airplane", goalAmount: 1962.93),
        SavingsGoal(id: "newhouse", name: "New House", icon: "house.fill", goalAmount: 50000),
        SavingsGoal(id: "car", name: "Car", icon: "car.fill", goalAmount: 15000),
        SavingsGoal(id: "wedding", name: "Wedding", icon: "heart.circle.fill", goalAmount: 10000)
    ]
}

extension Date {
    static func makeDate(month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var c = DateComponents()
        c.year = 2026; c.month = month; c.day = day; c.hour = hour; c.minute = minute
        return Calendar.current.date(from: c) ?? Date()
    }
}

extension Double {
    /// "$7,783.00" — grouped thousands, two decimal places, always US-style regardless
    /// of device locale (the source mockups mix locale formats; this app standardizes).
    var asMoney: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.usesGroupingSeparator = true
        let body = formatter.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
        return "$\(body)"
    }
}
