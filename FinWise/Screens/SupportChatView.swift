import SwiftUI

private enum SupportTab: String, CaseIterable, Identifiable {
    case assistant = "Support Assistant", helpCenter = "Help Center"
    var id: String { rawValue }
}

private struct ChatBubble: Identifiable {
    let id = UUID()
    let text: String
    let time: String?
    let fromUser: Bool
}

private let assistantThread: [ChatBubble] = [
    ChatBubble(text: "Welcome, I am your virtual assistant.", time: nil, fromUser: false),
    ChatBubble(text: "How can I help you today?", time: "14:00", fromUser: false),
    ChatBubble(text: "Hello! I have a question. How can I record my expenses by date?", time: "14:01", fromUser: true),
    ChatBubble(text: "Response to your request:\nYou can register expenses in the top menu of the homepage.", time: nil, fromUser: false),
    ChatBubble(text: "Enter the purchase information, including the date, etc.", time: "14:03", fromUser: false),
    ChatBubble(text: "OK, thanks a lot.", time: "14:05", fromUser: true),
    ChatBubble(text: "It was a pleasure to accommodate your request. See you soon!", time: "14:06 | Chat Ended", fromUser: false)
]

private let helpCenterThread: [ChatBubble] = [
    ChatBubble(text: "Hi, how are you today?", time: "09:12", fromUser: false),
    ChatBubble(text: "Your account is ready to use\u{2026}", time: "09:13 | Chat Ended", fromUser: false)
]

struct SupportChatView: View {
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss
    @State private var tab: SupportTab = .assistant
    @State private var draft = ""

    private var thread: [ChatBubble] {
        tab == .assistant ? assistantThread : helpCenterThread
    }

    var body: some View {
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
                SegmentedToggle(selected: $tab, label: \.rawValue, colors: colors)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(thread) { bubble in
                        bubbleView(bubble)
                    }
                }
                .padding(20)
            }

            HStack(spacing: 10) {
                Image(systemName: "camera.fill")
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(colors.teal)
                    .clipShape(Circle())
                TextField("Write Here\u{2026}", text: $draft)
                    .font(.fw(14, .medium))
                    .foregroundStyle(colors.ink)
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .background(colors.pillBg)
                    .clipShape(Capsule())
                Button {
                    draft = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(colors.teal)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(colors.bg)
        .navigationBarHidden(true)
    }

    private func bubbleView(_ bubble: ChatBubble) -> some View {
        VStack(alignment: bubble.fromUser ? .trailing : .leading, spacing: 4) {
            Text(bubble.text)
                .font(.fw(13.5, .medium))
                .foregroundStyle(bubble.fromUser ? .white : colors.ink)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(bubble.fromUser ? colors.teal : colors.pillBg)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            if let time = bubble.time {
                Text(time).font(.fw(10.5, .medium)).foregroundStyle(colors.ink3)
            }
        }
        .frame(maxWidth: .infinity, alignment: bubble.fromUser ? .trailing : .leading)
    }
}

#Preview {
    SupportChatView().environmentObject(AppState())
}
