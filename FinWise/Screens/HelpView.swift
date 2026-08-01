import SwiftUI

private enum HelpTab: String, CaseIterable, Identifiable {
    case faq = "FAQ", contact = "Contact Us"
    var id: String { rawValue }
}

private enum FAQCategory: String, CaseIterable, Identifiable {
    case general = "General", account = "Account", services = "Services"
    var id: String { rawValue }
}

private struct FAQItem: Identifiable {
    let id = UUID()
    let category: FAQCategory
    let question: String
    let answer: String
}

private let faqs: [FAQItem] = [
    FAQItem(category: .general, question: "How to use FinWise?", answer: "Log expenses from Home or Categories, check Analysis for spending trends, and track your budget progress at the top of every screen."),
    FAQItem(category: .general, question: "How much does it cost to use FinWise?", answer: "FinWise is free to use."),
    FAQItem(category: .general, question: "How to contact support?", answer: "Reach us any time from the Contact Us tab on this screen."),
    FAQItem(category: .account, question: "How can I reset my password if I forget it?", answer: "Use the Forgot Password link on the login screen to reset it."),
    FAQItem(category: .account, question: "Are there any privacy or data security measures in place?", answer: "Your data stays on your device in this version of the app."),
    FAQItem(category: .account, question: "Can I customize settings within the application?", answer: "Yes — update your profile, notifications, and appearance from Edit Profile."),
    FAQItem(category: .account, question: "How can I delete my account?", answer: "Go to Profile > Setting > Delete Account."),
    FAQItem(category: .services, question: "How do I access my expense history?", answer: "Open the Transactions tab for your full month-by-month history."),
    FAQItem(category: .services, question: "Can I use the app offline?", answer: "Yes, all your data is stored locally and available without an internet connection.")
]

struct HelpView: View {
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss

    @State private var tab: HelpTab = .faq
    @State private var category: FAQCategory = .general
    @State private var query: String = ""
    @State private var expanded: Set<UUID> = []

    private var filteredFAQs: [FAQItem] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        return faqs.filter { $0.category == category }
            .filter { q.isEmpty || $0.question.lowercased().contains(q) }
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
                        Text("Help & FAQs").font(.fw(19, .bold)).foregroundStyle(colors.ink)
                        Spacer()
                        NotificationBellButton(colors: colors)
                    }
                    Text("How Can We Help You?")
                        .font(.fw(15, .bold))
                        .foregroundStyle(colors.ink)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                }

                VStack(spacing: 18) {
                    SegmentedToggle(selected: $tab, label: \.rawValue, colors: colors)

                    if tab == .faq {
                        HStack(spacing: 8) {
                            ForEach(FAQCategory.allCases) { c in
                                let on = c == category
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { category = c }
                                } label: {
                                    Text(c.rawValue)
                                        .font(.fw(13, .semibold))
                                        .padding(.horizontal, 16)
                                        .frame(height: 36)
                                        .foregroundStyle(on ? colors.ink : colors.ink2)
                                        .background(on ? colors.card : Color.clear)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                            Spacer()
                        }
                        .padding(6)
                        .background(colors.pillBg)
                        .clipShape(Capsule())

                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass").foregroundStyle(colors.ink3)
                            TextField("Search", text: $query)
                                .font(.fw(14, .medium))
                                .foregroundStyle(colors.ink)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 48)
                        .background(colors.pillBg)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(colors.teal, lineWidth: 1.5))

                        VStack(spacing: 10) {
                            if filteredFAQs.isEmpty {
                                Text("No results for \u{201C}\(query)\u{201D}.")
                                    .font(.fw(13, .medium))
                                    .foregroundStyle(colors.ink2)
                                    .frame(maxWidth: .infinity, minHeight: 80)
                            } else {
                                ForEach(filteredFAQs) { item in
                                    faqRow(item)
                                }
                            }
                        }
                    } else {
                        contactCard
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)
                .padding(.bottom, 24)
            }
        }
        .background(colors.bg)
        .navigationBarHidden(true)
    }

    private func faqRow(_ item: FAQItem) -> some View {
        let isOpen = expanded.contains(item.id)
        return VStack(alignment: .leading, spacing: isOpen ? 10 : 0) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                    if isOpen { expanded.remove(item.id) } else { expanded.insert(item.id) }
                }
            } label: {
                HStack {
                    Text(item.question)
                        .font(.fw(13.5, .semibold))
                        .foregroundStyle(colors.ink)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(colors.ink3)
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                }
            }
            .buttonStyle(.plain)

            if isOpen {
                Text(item.answer)
                    .font(.fw(12.5, .medium))
                    .foregroundStyle(colors.ink2)
            }
        }
        .padding(16)
        .background(colors.pillBg)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var contactCard: some View {
        VStack(spacing: 10) {
            NavigationLink {
                OnlineSupportView()
            } label: {
                contactRow(icon: "questionmark.circle.fill", label: "Customer Service")
            }
            .buttonStyle(.plain)
            contactRow(icon: "globe", label: "Website")
            contactRow(icon: "person.2.fill", label: "Facebook")
            contactRow(icon: "message.fill", label: "Whatsapp")
            contactRow(icon: "camera.fill", label: "Instagram")
        }
    }

    private func contactRow(icon: String, label: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(colors.teal)
                .clipShape(Circle())
            Text(label).font(.fw(14.5, .semibold)).foregroundStyle(colors.ink)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(colors.ink3)
        }
        .padding(14)
        .background(colors.pillBg)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    HelpView().environmentObject(AppState())
}
