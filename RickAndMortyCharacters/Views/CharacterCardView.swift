import SwiftUI

public struct CharacterCardView: View {
    public let character: RMCharacter
    private var favoritesManager: FavoritesManager = .shared
    
    public init(character: RMCharacter, favoritesManager: FavoritesManager = .shared) {
        self.character = character
        self.favoritesManager = favoritesManager
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Character Image & Favorite Button Overlay
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: character.image)) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.12)
                            ProgressView()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        ZStack {
                            Color.gray.opacity(0.12)
                            Image(systemName: "person.fill.questionmark")
                                .font(.title)
                                .foregroundStyle(.secondary)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        favoritesManager.toggleFavorite(character.id)
                    }
                } label: {
                    Image(systemName: favoritesManager.isFavorite(character.id) ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(favoritesManager.isFavorite(character.id) ? Color.favoriteRed : .white)
                        .padding(8)
                        .background(.thinMaterial, in: Circle())
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                }
                .padding(8)
                .buttonStyle(.plain)
            }
            
            // Name & Status Badge
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(character.status.color)
                        .frame(width: 8, height: 8)
                    
                    Text("\(character.status.localizedName) • \(character.species)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 6)
        }
        .padding(10)
        .background(Color.customSecondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}
