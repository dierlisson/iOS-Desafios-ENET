import SwiftUI

public struct PokemonCardView: View {
    public let pokemon: Pokemon
    
    public init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Card Background Gradient
            LinearGradient(
                colors: [
                    pokemon.primaryType.color.opacity(0.85),
                    pokemon.primaryType.color.opacity(0.55)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(18)
            .shadow(color: pokemon.primaryType.color.opacity(0.3), radius: 6, x: 0, y: 4)
            
            // Decorative background pokeball circle pattern
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 120, height: 120)
                .offset(x: 50, y: 30)
            
            VStack(alignment: .leading, spacing: 8) {
                // Header: Name & ID Number
                HStack {
                    Text(pokemon.displayName)
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Spacer(minLength: 4)
                    
                    Text(pokemon.formattedID)
                        .font(.subheadline.bold())
                        .foregroundColor(Color.white.opacity(0.8))
                }
                
                HStack(alignment: .bottom) {
                    // Type Badges Column
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(pokemon.types) { type in
                            HStack(spacing: 4) {
                                Image(systemName: type.iconName)
                                    .font(.system(size: 9, weight: .bold))
                                Text(type.displayName)
                                    .font(.caption2.bold())
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.white.opacity(0.25))
                            .clipShape(Capsule())
                        }
                    }
                    
                    Spacer()
                    
                    // Async Artwork Image
                    AsyncImage(url: URL(string: pokemon.imageUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 3)
                        case .failure:
                            Image(systemName: "bolt.horizontal.fill")
                                .font(.title)
                                .foregroundColor(.white.opacity(0.6))
                                .frame(width: 80, height: 80)
                        case .empty:
                            ProgressView()
                                .tint(.white)
                                .frame(width: 80, height: 80)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .padding(14)
        }
        .frame(height: 125)
    }
}
