import SwiftUI

public struct CategoryChipView: View {
    public let category: EventCategory
    public let isSelected: Bool
    public let action: () -> Void
    
    public init(category: EventCategory, isSelected: Bool, action: @escaping () -> Void) {
        self.category = category
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.iconName)
                    .font(.footnote)
                Text(category.rawValue)
                    .font(.subheadline.weight(isSelected ? .semibold : .regular))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color.primary.opacity(0.06))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(isSelected ? Color.blue : Color.primary.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        CategoryChipView(category: .all, isSelected: true, action: {})
        CategoryChipView(category: .tech, isSelected: false, action: {})
    }
    .padding()
}
