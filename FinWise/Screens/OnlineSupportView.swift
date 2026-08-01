import SwiftUI

struct SupportChatSummary: Identifiable {
    let id = UUID()
    let title: String
    let preview: String
    let dateLabel: String
}

private let activeChats: [SupportChatSummary] = [
    SupportChatSummary(title: "Support Assistant", preview: "Hello! I'm here to assist you", dateLabel: "2 Min Ago")
]

private let endedChats: [SupportChatSummary] = [
    SupportChatSummary(title: "Help Center", preview: "Your account is ready to use\u{2026}", dateLabel: "Feb 08 -2024"),
    SupportChatSummary(title: "Support Assistant", preview: "Hello! I'm here to assist you", dateLabel: "Dic 24 -2023"),
    SupportChatSummary(title: "Support Assistant", preview: "Hello! I'm here to assist you", dateLabel: "Sep 10 -2023"),
    SupportChatSummary(title: "Help Center", preview: "Hi, how are you today?", dateLabel: "June 12 -2023")
]

struct OnlineSupportView: View {
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

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
                        Text("Online Support").font(.fw(18, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                }

                VStack(alignment: .leading, spacing: 14) {
                    Text("Active Chats").font(.fw(16, .bold)).foregroundStyle(colors.ink)
                    ForEach(activeChats) { chat in
                        NavigationLink {
                            SupportChatView()
                        } label: {
                            chatRow(chat)
                        }
                        .buttonStyle(.plain)
                    }

                    Text("Ended Chats").font(.fw(16, .bold)).foregroundStyle(colors.ink).padding(.top, 8)
                    ForEach(endedChats) { chat in
                        NavigationLink {
                            SupportChatView()
                        } label: {
                            chatRow(chat)
                        }
                        .buttonStyle(.plain)
                    }

                    NavigationLink {
                        SupportChatView()
                    } label: {
                        Text("Start Another Chat")
                            .font(.fw(16, .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(colors.ink)
                            .background(colors.teal)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 10)
                }
                .padding(.horizontal, 24)
                .padding(.top, 26)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
    }

    private func chatRow(_ chat: SupportChatSummary) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 18))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(colors.teal)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 3) {
                Text(chat.title).font(.fw(14.5, .bold)).foregroundStyle(colors.ink)
                Text(chat.preview).font(.fw(12.5, .medium)).foregroundStyle(colors.ink2)
            }
            Spacer()
            Text(chat.dateLabel).font(.fw(11, .medium)).foregroundStyle(colors.ink3)
        }
        .padding(14)
        .background(colors.pillBg)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    OnlineSupportView().environmentObject(AppState())
}
