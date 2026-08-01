import SwiftUI

private enum ReportKind: String, CaseIterable, Identifiable {
    case income = "Income", expense = "Expense"
    var id: String { rawValue }
}

struct SearchTransactionsView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

    @State private var query = ""
    @State private var category: ExpenseCategory?
    @State private var date: Date?
    @State private var report: ReportKind = .expense
    @State private var didSearch = false

    private func matches(_ t: Transaction) -> Bool {
        let matchesQuery = query.isEmpty || t.title.localizedCaseInsensitiveContains(query)
        let matchesCategory = category == nil || t.category == category
        let matchesDate = date == nil || Calendar.current.isDate(t.date, inSameDayAs: date ?? t.date)
        let matchesKind = t.kind == (report == .income ? .income : .expense)
        return matchesQuery && matchesCategory && matchesDate && matchesKind
    }

    private var results: [Transaction] {
        app.transactions
            .filter(matches)
            .sorted { $0.date > $1.date }
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
                        Text("Search").font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass").foregroundStyle(colors.ink2)
                        TextField("Search\u{2026}", text: $query)
                            .font(.fw(15, .medium))
                            .foregroundStyle(colors.ink)
                    }
                    .padding(.horizontal, 18)
                    .frame(height: 52)
                    .background(colors.card)
                    .clipShape(Capsule())
                }

                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Categories").font(.fw(13, .semibold)).foregroundStyle(colors.ink)
                        Menu {
                            Button("All Categories") { category = nil }
                            ForEach(ExpenseCategory.gridCategories) { c in
                                Button(c.rawValue) { category = c }
                            }
                        } label: {
                            HStack {
                                Text(category?.rawValue ?? "Select the category")
                                    .font(.fw(15, .medium))
                                    .foregroundStyle(category == nil ? colors.ink3 : colors.ink)
                                Spacer()
                                Image(systemName: "chevron.down").font(.system(size: 12, weight: .semibold)).foregroundStyle(colors.ink2)
                            }
                            .padding(.horizontal, 18)
                            .frame(height: 52)
                            .background(colors.pillBg)
                            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date").font(.fw(13, .semibold)).foregroundStyle(colors.ink)
                        HStack {
                            Text(date.map { $0.formatted(.dateTime.day().month().year()) } ?? "Any date")
                                .font(.fw(15, .medium))
                                .foregroundStyle(date == nil ? colors.ink3 : colors.ink)
                            Spacer()
                            ZStack {
                                Circle().fill(colors.teal).frame(width: 34, height: 34)
                                Image(systemName: "calendar").font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                            }
                            .overlay(
                                DatePicker("", selection: Binding(get: { date ?? Date() }, set: { date = $0 }), displayedComponents: .date)
                                    .labelsHidden()
                                    .opacity(0.02)
                                    .frame(width: 34, height: 34)
                                    .clipped()
                            )
                        }
                        .padding(.horizontal, 18)
                        .frame(height: 52)
                        .background(colors.pillBg)
                        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Report").font(.fw(13, .semibold)).foregroundStyle(colors.ink)
                        HStack(spacing: 26) {
                            ForEach(ReportKind.allCases) { kind in
                                Button {
                                    report = kind
                                } label: {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .strokeBorder(colors.teal, lineWidth: 2)
                                            .background(Circle().fill(report == kind ? colors.teal : Color.clear))
                                            .frame(width: 20, height: 20)
                                        Text(kind.rawValue).font(.fw(14, .medium)).foregroundStyle(colors.ink)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Button {
                        didSearch = true
                    } label: {
                        Text("Search")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(colors.teal)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)

                    if didSearch {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("\(results.count) result\(results.count == 1 ? "" : "s")")
                                .font(.fw(13, .semibold))
                                .foregroundStyle(colors.ink2)
                            ForEach(results) { t in
                                TransactionRow(t: t, colors: colors)
                            }
                        }
                        .padding(.top, 4)
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
}

#Preview {
    SearchTransactionsView().environmentObject(AppState())
}
