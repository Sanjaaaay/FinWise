import SwiftUI

struct AddExpenseView: View {
    @EnvironmentObject var app: AppState
    @Environment(\.fw) private var colors
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @State private var showDatePicker = false

    private enum Field {
        case amount, title, note
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header
                kindToggle
                dateField
                if app.draftKind == .expense {
                    categoryField
                }
                amountField
                titleField
                noteField
                saveButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        .background(colors.bg.ignoresSafeArea())
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(date: $app.draftDate, colors: colors)
        }
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
            Text(app.draftKind == .income ? "Add Income" : "Add Expenses").font(.fw(18, .bold)).foregroundStyle(colors.ink)
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
    }

    private var kindToggle: some View {
        SegmentedToggle(selected: $app.draftKind, label: \.rawValue, colors: colors)
    }

    private var dateField: some View {
        labeledField("Date") {
            Button {
                showDatePicker = true
            } label: {
                HStack {
                    Text(app.draftDate.formatted(.dateTime.month(.wide).day().year()))
                        .font(.fw(15, .medium))
                        .foregroundStyle(colors.ink)
                    Spacer()
                    ZStack {
                        Circle().fill(colors.teal).frame(width: 34, height: 34)
                        Image(systemName: "calendar")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var categoryField: some View {
        labeledField("Category") {
            Menu {
                ForEach(ExpenseCategory.gridCategories) { cat in
                    Button {
                        app.draftCategory = cat
                    } label: {
                        Label(cat.rawValue, systemImage: cat.icon)
                    }
                }
            } label: {
                HStack {
                    Image(systemName: app.draftCategory.icon).foregroundStyle(colors.ink2)
                    Text(app.draftCategory.rawValue).font(.fw(15, .medium)).foregroundStyle(colors.ink)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(colors.ink2)
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var amountField: some View {
        labeledField("Amount") {
            HStack(spacing: 4) {
                Text("$").font(.fw(15, .semibold)).foregroundStyle(colors.ink2)
                TextField("0.00", text: $app.draftAmountText)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .amount)
                    .font(.fw(15, .medium))
                    .foregroundStyle(colors.ink)
            }
        }
    }

    private var titleField: some View {
        labeledField(app.draftKind == .income ? "Income Title" : "Expense Title") {
            TextField(app.draftKind == .income ? "e.g. Freelance" : "e.g. Dinner", text: $app.draftTitle)
                .focused($focusedField, equals: .title)
                .font(.fw(15, .medium))
                .foregroundStyle(colors.ink)
        }
    }

    private var noteField: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 26, style: .continuous).fill(colors.pillBg)
            if app.draftNote.isEmpty {
                Text("Enter Message")
                    .font(.fw(14, .medium))
                    .foregroundStyle(colors.teal)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
            }
            TextEditor(text: $app.draftNote)
                .focused($focusedField, equals: .note)
                .font(.fw(14, .medium))
                .foregroundStyle(colors.ink)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
        }
        .frame(height: 160)
    }

    private var saveButton: some View {
        Button {
            app.saveDraftTransaction()
        } label: {
            Text("Save")
                .font(.fw(17, .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
                .foregroundStyle(colors.ink)
                .background(app.draftIsValid ? colors.teal : colors.teal.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(!app.draftIsValid)
        .padding(.top, 8)
    }

    private func labeledField<Content: View>(_ label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.fw(13, .semibold)).foregroundStyle(colors.ink)
            content()
                .padding(.horizontal, 18)
                .frame(height: 52)
                .background(colors.pillBg)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
    }
}

/// A real, visible date picker in its own sheet — replaces the earlier
/// near-invisible DatePicker-overlay trick, which proved unreliable to tap.
struct DatePickerSheet: View {
    @Binding var date: Date
    let colors: ThemeColors
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 22) {
            Capsule().fill(colors.line).frame(width: 40, height: 5).padding(.top, 10)

            Text("Select Date").font(.fw(18, .bold)).foregroundStyle(colors.ink)

            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .labelsHidden()
                .tint(colors.teal)

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.fw(16, .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(colors.ink)
                    .background(colors.teal)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, 24)
        .background(colors.bg.ignoresSafeArea())
        .presentationDetents([.height(480)])
    }
}

#Preview {
    AddExpenseView().environmentObject(AppState())
}
