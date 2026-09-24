import SwiftUI

public struct StatBarView: View {
    public let stat: PokemonStat
    public let typeColor: Color
    
    public init(stat: PokemonStat, typeColor: Color) {
        self.stat = stat
        self.typeColor = typeColor
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Text(stat.displayName)
                .font(.subheadline.bold())
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Text("\(stat.value)")
                .font(.subheadline.monospacedDigit().bold())
                .foregroundColor(.primary)
                .frame(width: 35, alignment: .trailing)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.08))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [typeColor.opacity(0.7), typeColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * stat.progressRatio, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 4)
    }
}
