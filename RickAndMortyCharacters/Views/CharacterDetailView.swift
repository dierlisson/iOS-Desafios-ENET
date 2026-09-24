import SwiftUI

public struct CharacterDetailView: View {
    public let character: RMCharacter
    private var favoritesManager: FavoritesManager = .shared
    
    public init(character: RMCharacter, favoritesManager: FavoritesManager = .shared) {
        self.character = character
        self.favoritesManager = favoritesManager
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Image
                AsyncImage(url: URL(string: character.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        ZStack {
                            Color.gray.opacity(0.12)
                            ProgressView()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .overlay(
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
                
                // Character Title & Status/Species/Gender Badges
                VStack(spacing: 12) {
                    Text(character.name)
                        .font(.title.bold())
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 8) {
                        DetailBadgeView(
                            title: character.status.localizedName,
                            color: character.status.color,
                            showDot: true
                        )
                        DetailBadgeView(
                            title: character.species,
                            color: .portalGreen,
                            showDot: false
                        )
                        DetailBadgeView(
                            title: character.gender.localizedName,
                            color: character.gender.color,
                            showDot: false
                        )
                    }
                }
                
                // Details Section Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .font(.title3)
                            .foregroundStyle(Color.portalGreen)
                        Text("Informações")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    .padding(.bottom, 4)
                    
                    VStack(spacing: 14) {
                        DetailRow(icon: "heart.text.square.fill", title: "Status", value: character.status.localizedName, color: character.status.color)
                        DetailRow(icon: "person.fill", title: "Espécie", value: character.species, color: .portalGreen)
                        DetailRow(icon: "figure.fill", title: "Gênero", value: character.gender.localizedName, color: character.gender.color)
                        if !character.type.isEmpty {
                            DetailRow(icon: "star.fill", title: "Tipo / Subespécie", value: character.type, color: .orange)
                        }
                        DetailRow(icon: "globe.americas.fill", title: "Origem", value: character.origin.name, color: .blue)
                        DetailRow(icon: "mappin.and.ellipse", title: "Localização Atual", value: character.location.name, color: .purple)
                        DetailRow(icon: "tv.fill", title: "Aparições em Episódios", value: "\(character.episode.count) episódios", color: .indigo)
                    }
                }
                .padding(20)
                .background(Color.customSecondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 22))
            }
            .padding(20)
        }
        .background(Color.customSystemGroupedBackground)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        favoritesManager.toggleFavorite(character.id)
                    }
                } label: {
                    Image(systemName: favoritesManager.isFavorite(character.id) ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundStyle(favoritesManager.isFavorite(character.id) ? Color.favoriteRed : .primary)
                }
            }
        }
        #endif
    }
}

private struct DetailBadgeView: View {
    let title: String
    let color: Color
    let showDot: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            if showDot {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
            }
            Text(title.uppercased())
                .font(.caption2.bold())
                .foregroundStyle(color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color.opacity(0.12), in: Capsule())
    }
}

private struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.12), in: Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
    }
}
