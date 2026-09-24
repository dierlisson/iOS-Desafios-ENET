import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
    /// A darker green keeps white button text readable in both appearances.
    public static var investmentGreen: Color { Color(red: 0.12, green: 0.46, blue: 0.23) }

    /// Lighter foreground green reaches readable contrast on dark grouped cards.
    public static var investmentTextGreen: Color {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.35, green: 0.82, blue: 0.47, alpha: 1)
                : UIColor(red: 0.08, green: 0.39, blue: 0.19, alpha: 1)
        })
        #else
        return investmentGreen
        #endif
    }

    public static var investmentBackground: Color {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor.systemGroupedBackground
                : UIColor(red: 0.95, green: 0.98, blue: 0.96, alpha: 1)
        })
        #else
        return customSystemGroupedBackground
        #endif
    }

    public static var customSystemGroupedBackground: Color {
        #if canImport(UIKit)
        return Color(uiColor: .systemGroupedBackground)
        #elseif canImport(AppKit)
        return Color(nsColor: .windowBackgroundColor)
        #else
        return Color.gray.opacity(0.1)
        #endif
    }

    public static var customSecondarySystemGroupedBackground: Color {
        #if canImport(UIKit)
        return Color(uiColor: .secondarySystemGroupedBackground)
        #elseif canImport(AppKit)
        return Color(nsColor: .controlBackgroundColor)
        #else
        return Color.gray.opacity(0.15)
        #endif
    }
}

#if os(iOS)
extension View {
    @ViewBuilder
    public func decimalPadKeyboard() -> some View {
        self.keyboardType(.decimalPad)
    }

    @ViewBuilder
    public func numberPadKeyboard() -> some View {
        self.keyboardType(.numberPad)
    }
}
#else
extension View {
    @ViewBuilder
    public func decimalPadKeyboard() -> some View {
        self
    }

    @ViewBuilder
    public func numberPadKeyboard() -> some View {
        self
    }
}
#endif
