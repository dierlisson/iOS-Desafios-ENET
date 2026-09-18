import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
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
