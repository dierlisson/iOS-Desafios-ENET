import SwiftUI

public struct StatBarView: View {
    public let stat: PokemonStat
    public let typeColor: Color
    @State private var animatedRatio: Double = 0.0
    
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
                        .frame(width: max(0, geometry.size.width * animatedRatio), height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 4)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animatedRatio = stat.progressRatio
            }
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        StatBarView(stat: PokemonStat(name: "hp", value: 45), typeColor: PokemonType.grass.color)
        StatBarView(stat: PokemonStat(name: "attack", value: 120), typeColor: PokemonType.fire.color)
    }
    .padding()
}

