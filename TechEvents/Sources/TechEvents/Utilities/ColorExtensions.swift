import SwiftUI

public extension Color {
    static var appSystemBackground: Color {
        #if os(iOS)
        return Color(uiColor: .systemBackground)
        #else
        return Color.white
        #endif
    }
    
    static var appSecondarySystemBackground: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemBackground)
        #else
        return Color.gray.opacity(0.1)
        #endif
    }
    
    static var appSecondarySystemGroupedBackground: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemGroupedBackground)
        #else
        return Color.white
        #endif
    }
    
    static var appTertiarySystemBackground: Color {
        #if os(iOS)
        return Color(uiColor: .tertiarySystemBackground)
        #else
        return Color.gray.opacity(0.05)
        #endif
    }
    
    static var appSystemGroupedBackground: Color {
        #if os(iOS)
        return Color(uiColor: .systemGroupedBackground)
        #else
        return Color(white: 0.95)
        #endif
    }
    
    static var appTertiarySystemGroupedBackground: Color {
        #if os(iOS)
        return Color(uiColor: .tertiarySystemGroupedBackground)
        #else
        return Color.gray.opacity(0.15)
        #endif
    }
}
