import SwiftUI

public struct TypeBadgeView: View {
    public let type: PokemonType
    
    public init(type: PokemonType) {
        self.type = type
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: type.iconName)
                .font(.caption2.bold())
            Text(type.displayName)
                .font(.caption.bold())
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(type.color)
        .clipShape(Capsule())
        .shadow(color: type.color.opacity(0.4), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    HStack(spacing: 8) {
        TypeBadgeView(type: .grass)
        TypeBadgeView(type: .fire)
        TypeBadgeView(type: .water)
    }
    .padding()
}

