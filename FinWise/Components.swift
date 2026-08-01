import SwiftUI

/// The "Total Balance / Total Expense + budget progress bar" block shared by
/// Home, Categories, and Analysis — each screen supplies its own title/greeting
/// row above this, but the stats themselves are identical everywhere they appear.
struct BudgetStatsBlock: View {
    @EnvironmentObject var app: AppState
    let colors: ThemeColors

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                statColumn(icon: "arrow.up.right.square", label: "Total Balance", value: app.totalBalance.asMoney, valueColor: colors.card)
                Rectangle().fill(colors.ink.opacity(0.25)).frame(width: 1, height: 34).padding(.top, 6)
                statColumn(icon: "square.and.arrow.down", label: "Total Expense", value: "-\(app.totalExpense.asMoney)", valueColor: colors.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            VStack(alignment: .leading, spacing: 10) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(colors.card)
                        Capsule()
                            .fill(colors.ink)
                            .frame(width: max(60, geo.size.width * app.budgetUsedPercent / 100))
                            .overlay(
                                Text("\(Int(app.budgetUsedPercent))%")
                                    .font(.fw(11, .bold))
                                    .foregroundStyle(.white)
                            )
                        Text(app.monthlyBudget.asMoney)
                            .font(.fw(11, .semibold))
                            .italic()
                            .foregroundStyle(colors.ink)
                            .padding(.trailing, 14)
                            .frame(width: geo.size.width, alignment: .trailing)
                    }
                }
                .frame(height: 26)

                HStack(spacing: 6) {
                    Image(systemName: "checkmark.square.fill").foregroundStyle(colors.ink)
                    Text("\(Int(app.budgetUsedPercent))% Of Your Expenses, Looks Good.")
                        .font(.fw(12, .medium))
                        .foregroundStyle(colors.ink)
                }
            }
        }
    }

    private func statColumn(icon: String, label: String, value: String, valueColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 12)).foregroundStyle(colors.ink)
                Text(label).font(.fw(12, .medium)).foregroundStyle(colors.ink.opacity(0.7))
            }
            Text(value).font(.fw(19, .bold)).foregroundStyle(valueColor)
        }
    }
}

/// The teal, bottom-rounded hero header shell used by Home, Categories, and Analysis.
struct HeroHeader<Content: View>: View {
    let colors: ThemeColors
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            content
        }
        .padding(.horizontal, 22)
        .padding(.top, 8)
        .padding(.bottom, 26)
        .background(colors.teal)
        .clipShape(.rect(bottomLeadingRadius: 40, bottomTrailingRadius: 40))
    }
}

/// The plain "<title> + bell" top row used by Categories, Analysis, Transactions,
/// and Profile (Home uses its own greeting instead).
struct TitleRow: View {
    @EnvironmentObject var app: AppState
    let title: String
    let colors: ThemeColors

    var body: some View {
        HStack {
            Text(title).font(.fw(20, .bold)).foregroundStyle(colors.ink)
            Spacer()
            NotificationBellButton(colors: colors)
        }
    }
}

/// The bell icon used in every screen header — opens the Notifications sheet.
struct NotificationBellButton: View {
    @EnvironmentObject var app: AppState
    let colors: ThemeColors

    var body: some View {
        Button {
            app.showNotifications = true
        } label: {
            Image(systemName: "bell.fill")
                .foregroundStyle(colors.ink)
                .frame(width: 40, height: 40)
                .background(colors.card)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

/// Generic pill-style range picker — used for Home's 3-way Daily/Weekly/Monthly
/// toggle and Analysis's 4-way Daily/Weekly/Monthly/Year toggle.
struct SegmentedToggle<T: Hashable & CaseIterable & Identifiable>: View where T.AllCases: RandomAccessCollection {
    @Binding var selected: T
    let label: (T) -> String
    let colors: ThemeColors

    var body: some View {
        HStack(spacing: 4) {
            ForEach(T.allCases) { option in
                let on = option == selected
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { selected = option }
                } label: {
                    Text(label(option))
                        .font(.fw(14, .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundStyle(on ? colors.ink : colors.ink2)
                        .background(on ? colors.teal.opacity(0.5) : Color.clear)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(5)
        .background(colors.pillBg)
        .clipShape(Capsule())
    }
}

/// A single transaction line — icon, title/time, tag, signed amount. Shared by
/// Home's condensed list and the full Transactions tab's month-grouped list.
/// `showTag` is false for single-category lists (e.g. a category detail screen),
/// where the tag column would just repeat the category name on every row.
struct TransactionRow: View {
    let t: Transaction
    let colors: ThemeColors
    var showTag: Bool = true

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: t.category.icon)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(t.category.iconBg(colors))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(t.title).font(.fw(15, .bold)).foregroundStyle(colors.ink)
                Text(t.timeString).font(.fw(11.5, .medium)).foregroundStyle(colors.blue)
            }

            Spacer()

            if showTag {
                Rectangle().fill(colors.line).frame(width: 1, height: 26)
                Text(t.tag)
                    .font(.fw(12, .medium))
                    .foregroundStyle(colors.ink2)
                    .frame(minWidth: 60)
                Rectangle().fill(colors.line).frame(width: 1, height: 26)
            }

            Text(t.signedDisplay)
                .font(.fw(14, .bold))
                .foregroundStyle(t.kind == .expense ? colors.blue : colors.ink)
                .frame(minWidth: 70, alignment: .trailing)
        }
    }
}

/// Labeled text field styled for the auth screens (Login/Create Account/Forgot
/// Password/New Password) — uses `fieldBg`, the muted-sage tone unique to auth,
/// vs. the `pillBg` used by fields everywhere else in the app.
struct AuthField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let colors: ThemeColors
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.fw(13, .semibold)).foregroundStyle(colors.ink)
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .font(.fw(15, .medium))
                .foregroundStyle(colors.ink)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 18)
                .frame(height: 52)
                .background(colors.fieldBg)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
    }
}

struct AuthSecureField: View {
    let label: String
    @Binding var text: String
    let colors: ThemeColors
    @State private var reveal = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.fw(13, .semibold)).foregroundStyle(colors.ink)
            HStack {
                Group {
                    if reveal { TextField("", text: $text) } else { SecureField("", text: $text) }
                }
                .font(.fw(15, .medium))
                .foregroundStyle(colors.ink)
                Button {
                    reveal.toggle()
                } label: {
                    Image(systemName: reveal ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(colors.ink2)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
            .frame(height: 52)
            .background(colors.fieldBg)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
    }
}
