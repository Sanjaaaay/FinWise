import SwiftUI

struct SavingsGoalDetailView: View {
    let goal: SavingsGoal
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss
    @State private var showAddDeposit = false

    private var saved: Double { app.savedAmount(for: goal.name) }
    private var percent: Double { goal.goalAmount > 0 ? min(100, saved / goal.goalAmount * 100) : 0 }

    private var deposits: [Transaction] {
        let goalName = goal.name
        let matching = app.transactions.filter { t in t.category == .savings && t.tag == goalName }
        return matching.sorted { $0.date > $1.date }
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
                        Text(goal.name).font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }

                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 14) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Goal").font(.fw(12, .medium)).foregroundStyle(colors.ink.opacity(0.7))
                                Text(goal.goalAmount.asMoney).font(.fw(19, .bold)).foregroundStyle(colors.ink)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Amount Saved").font(.fw(12, .medium)).foregroundStyle(colors.ink.opacity(0.7))
                                Text(saved.asMoney).font(.fw(19, .bold)).foregroundStyle(colors.card)
                            }
                        }
                        Spacer()
                        ZStack {
                            Circle().stroke(colors.card.opacity(0.35), lineWidth: 5).frame(width: 100, height: 100)
                            Circle().trim(from: 0, to: percent / 100).stroke(colors.blue, lineWidth: 5)
                                .frame(width: 100, height: 100).rotationEffect(.degrees(-90))
                            VStack(spacing: 4) {
                                Image(systemName: goal.icon).foregroundStyle(.white).font(.system(size: 22))
                                Text(goal.name).font(.fw(11, .semibold)).foregroundStyle(.white)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(colors.card)
                                Capsule()
                                    .fill(colors.ink)
                                    .frame(width: max(60, geo.size.width * percent / 100))
                                    .overlay(Text("\(Int(percent))%").font(.fw(11, .bold)).foregroundStyle(.white))
                                Text(goal.goalAmount.asMoney)
                                    .font(.fw(11, .semibold)).italic().foregroundStyle(colors.ink)
                                    .padding(.trailing, 14)
                                    .frame(width: geo.size.width, alignment: .trailing)
                            }
                        }
                        .frame(height: 26)

                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.square.fill").foregroundStyle(colors.ink)
                            Text("\(Int(percent))% Of Your \(goal.name) Goal, Keep Going.")
                                .font(.fw(12, .medium))
                                .foregroundStyle(colors.ink)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    if deposits.isEmpty {
                        Text("No deposits yet.")
                            .font(.fw(13, .medium))
                            .foregroundStyle(colors.ink2)
                            .frame(maxWidth: .infinity, minHeight: 60)
                    } else {
                        HStack {
                            Text(deposits.first?.date.formatted(.dateTime.month(.wide)) ?? "")
                                .font(.fw(18, .bold)).foregroundStyle(colors.ink)
                            Spacer()
                            Image(systemName: "calendar")
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .background(colors.teal)
                                .clipShape(Circle())
                        }
                        ForEach(deposits) { t in
                            TransactionRow(t: t, colors: colors, showTag: false)
                        }
                    }

                    Button {
                        showAddDeposit = true
                    } label: {
                        Text("Add Savings")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(colors.teal)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 6)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddDeposit) {
            NewEntryView(title: "Add to \(goal.name)") { text in
                if let amount = app.parsedAmount(text) {
                    app.addSavingsDeposit(goalName: goal.name, amount: amount)
                }
            }
        }
    }
}

#Preview {
    SavingsGoalDetailView(goal: SavingsGoal.all[0]).environmentObject(AppState())
}
