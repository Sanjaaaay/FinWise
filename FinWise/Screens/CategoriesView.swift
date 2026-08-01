import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @State private var showNewCategory = false

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    HeroHeader(colors: colors) {
                        TitleRow(title: "Categories", colors: colors)
                        BudgetStatsBlock(colors: colors)
                    }

                    LazyVGrid(columns: columns, spacing: 22) {
                        ForEach(ExpenseCategory.gridCategories) { category in
                            if category == .savings {
                                NavigationLink {
                                    SavingsGoalsGridView()
                                } label: {
                                    tile(icon: category.icon, label: category.rawValue, highlighted: false)
                                }
                                .buttonStyle(.plain)
                            } else {
                                NavigationLink(value: category) {
                                    tile(icon: category.icon, label: category.rawValue, highlighted: false)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        Button {
                            showNewCategory = true
                        } label: {
                            tile(icon: "plus", label: "More", highlighted: false)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    .padding(.bottom, 24)
                }
            }
            .background(colors.bg)
            .navigationDestination(for: ExpenseCategory.self) { category in
                CategoryDetailView(category: category)
            }
        }
        .sheet(isPresented: $app.showAddExpense) {
            AddExpenseView()
        }
        .sheet(isPresented: $showNewCategory) {
            NewEntryView(title: "New Category") { _ in }
        }
    }

    private func tile(icon: String, label: String, highlighted: Bool) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 74, height: 74)
                .background(colors.iconLightBlue)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            Text(label).font(.fw(13, .semibold)).foregroundStyle(colors.ink)
        }
    }
}

#Preview {
    CategoriesView().environmentObject(AppState())
}
