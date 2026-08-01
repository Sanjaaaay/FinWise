import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                VStack(spacing: 0) {
                    ForEach(app.notifications) { item in
                        row(item)
                        if item.id != app.notifications.last?.id {
                            Rectangle().fill(colors.line).frame(height: 1)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
    }

    private var header: some View {
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
            Text("Notification").font(.fw(20, .bold)).foregroundStyle(colors.ink)
            Spacer()
            NotificationBellButton(colors: colors)
        }
        .padding(.horizontal, 22)
        .padding(.top, 8)
        .padding(.bottom, 26)
        .background(colors.teal)
        .clipShape(.rect(bottomLeadingRadius: 40, bottomTrailingRadius: 40))
    }

    private func row(_ item: AppState.NotificationItem) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: item.icon)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(colors.teal)
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(.fw(15, .bold)).foregroundStyle(colors.ink)
                Text(item.subtitle)
                    .font(.fw(12.5, .medium))
                    .foregroundStyle(colors.ink2)
                if let detail = item.detail {
                    Text(detail).font(.fw(12, .semibold)).foregroundStyle(colors.blue)
                }
                Text(item.timeLabel)
                    .font(.fw(11, .medium))
                    .foregroundStyle(colors.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.vertical, 14)
    }
}

#Preview {
    NotificationsView().environmentObject(AppState())
}
