import SwiftUI

struct SavingsGoalsGridView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss
    @State private var showNewGoal = false

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

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
                        Text("Savings").font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                    BudgetStatsBlock(colors: colors)
                }

                LazyVGrid(columns: columns, spacing: 22) {
                    ForEach(SavingsGoal.all) { goal in
                        NavigationLink {
                            SavingsGoalDetailView(goal: goal)
                        } label: {
                            VStack(spacing: 10) {
                                Image(systemName: goal.icon)
                                    .font(.system(size: 26, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 74, height: 74)
                                    .background(goal.id == "travel" ? colors.blue : colors.iconLightBlue)
                                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                                Text(goal.name).font(.fw(13, .semibold)).foregroundStyle(colors.ink)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 28)

                Button {
                    showNewGoal = true
                } label: {
                    Text("Add More")
                        .font(.fw(15, .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundStyle(colors.ink)
                        .background(colors.teal)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.top, 28)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
        .sheet(isPresented: $showNewGoal) {
            NewEntryView(title: "New Category") { _ in }
        }
    }
}

#Preview {
    SavingsGoalsGridView().environmentObject(AppState())
}
