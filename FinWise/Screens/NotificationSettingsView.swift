import SwiftUI

struct NotificationSettingsView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

    // These four are cosmetic-only, unlike `pushNotificationsEnabled` which
    // also drives the toggle on Edit Profile — the mockup doesn't wire them
    // to any other real behavior in the app.
    @State private var soundOn = true
    @State private var soundCallOn = true
    @State private var vibrateOn = true
    @State private var transactionUpdateOn = false
    @State private var expenseReminderOn = false
    @State private var budgetNotificationsOn = false
    @State private var lowBalanceAlertsOn = false

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
                        Text("Notification Settings").font(.fw(17, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                }

                VStack(spacing: 0) {
                    toggleRow("General Notification", isOn: $app.pushNotificationsEnabled)
                    toggleRow("Sound", isOn: $soundOn)
                    toggleRow("Sound Call", isOn: $soundCallOn)
                    toggleRow("Vibrate", isOn: $vibrateOn)
                    toggleRow("Transaction Update", isOn: $transactionUpdateOn)
                    toggleRow("Expense Reminder", isOn: $expenseReminderOn)
                    toggleRow("Budget Notifications", isOn: $budgetNotificationsOn)
                    toggleRow("Low Balance Alerts", isOn: $lowBalanceAlertsOn)
                }
                .padding(.horizontal, 24)
                .padding(.top, 26)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
    }

    private func toggleRow(_ label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label).font(.fw(14.5, .medium)).foregroundStyle(colors.ink)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(colors.teal)
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    NotificationSettingsView().environmentObject(AppState())
}
