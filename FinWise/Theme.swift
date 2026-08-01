import SwiftUI

struct ThemeColors {
    let bg: Color
    let card: Color
    let ink: Color
    let ink2: Color
    let ink3: Color
    let teal: Color
    let blue: Color
    let iconLightBlue: Color
    let iconMediumBlue: Color
    let line: Color
    let fieldBg: Color
    let pillBg: Color

    static let light = ThemeColors(
        bg: Color(hex: 0xF1FFF3),
        card: Color(hex: 0xFFFFFF),
        ink: Color(hex: 0x052224),
        ink2: Color(hex: 0x4A6B67),
        ink3: Color(hex: 0x8CA6A3),
        teal: Color(hex: 0x00D09E),
        blue: Color(hex: 0x0068FF),
        iconLightBlue: Color(hex: 0x6DB6FE),
        iconMediumBlue: Color(hex: 0x3299FF),
        line: Color.black.opacity(0.06),
        fieldBg: Color(hex: 0xBBD5C4),
        pillBg: Color(hex: 0xDFF7E2)
    )

    /// Not sourced from the mockup kit (it's light-only) — the Edit Profile screen's
    /// "Turn Dark Theme" toggle implies one should exist, so this follows standard
    /// dark-mode conventions while keeping the same teal/blue brand accents.
    static let dark = ThemeColors(
        bg: Color(hex: 0x0B1A16),
        card: Color(hex: 0x14231F),
        ink: Color(hex: 0xEAFBF3),
        ink2: Color(hex: 0x9FC4BC),
        ink3: Color(hex: 0x6E8F87),
        teal: Color(hex: 0x00D09E),
        blue: Color(hex: 0x4C8DFF),
        iconLightBlue: Color(hex: 0x6DB6FE),
        iconMediumBlue: Color(hex: 0x3299FF),
        line: Color.white.opacity(0.08),
        fieldBg: Color(hex: 0x23413A),
        pillBg: Color(hex: 0x16302A)
    )

    var shadow: Color { Color.black.opacity(0.06) }
}

extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

/// Driven by the in-app "Turn Dark Theme" toggle (Edit Profile), not the system
/// appearance setting — this app has its own independent light/dark preference.
enum AppTheme {
    static func colors(dark: Bool) -> ThemeColors { dark ? .dark : .light }
}

extension Font {
    static func fw(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

private struct ThemeColorsKey: EnvironmentKey {
    static let defaultValue: ThemeColors = .light
}

extension EnvironmentValues {
    var fw: ThemeColors {
        get { self[ThemeColorsKey.self] }
        set { self[ThemeColorsKey.self] = newValue }
    }
}
