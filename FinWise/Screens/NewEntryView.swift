import SwiftUI

/// The simple "New Category" / "New Goal" creation sheet — a title, a single
/// text field, and Save/Cancel. Matches the mockup's minimal modal exactly.
struct NewEntryView: View {
    let title: String
    var onSave: (String) -> Void

    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""

    var body: some View {
        VStack(spacing: 22) {
            Capsule().fill(colors.line).frame(width: 40, height: 5).padding(.top, 10)

            Text(title).font(.fw(20, .bold)).foregroundStyle(colors.ink)

            TextField("Write\u{2026}", text: $text)
                .font(.fw(15, .medium))
                .foregroundStyle(colors.ink)
                .padding(.horizontal, 18)
                .frame(height: 52)
                .background(colors.pillBg)
                .clipShape(Capsule())

            Button {
                let trimmed = text.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty else { return }
                onSave(trimmed)
                dismiss()
            } label: {
                Text("Save")
                    .font(.fw(16, .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(colors.ink)
                    .background(text.trimmingCharacters(in: .whitespaces).isEmpty ? colors.teal.opacity(0.55) : colors.teal)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)

            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .font(.fw(16, .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(colors.ink)
                    .background(colors.pillBg)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, 30)
        .background(colors.bg.ignoresSafeArea())
        .presentationDetents([.height(340)])
    }
}

#Preview {
    NewEntryView(title: "New Category") { _ in }
}
