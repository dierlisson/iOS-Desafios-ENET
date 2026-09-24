import SwiftUI

public struct CharacterDetailView: View {
    public let character: RMCharacter
    
    public init(character: RMCharacter) {
        self.character = character
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
                        Color.gray.opacity(0.12)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .overlay(
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
                
                // Character Title & Status Badge
                VStack(spacing: 8) {
                    Text(character.name)
                        .font(.title.bold())
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(character.status.color)
                            .frame(width: 10, height: 10)
                        Text(character.status.localizedName.uppercased())
                            .font(.caption.bold())
                            .foregroundStyle(character.status.color)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(character.status.color.opacity(0.12), in: Capsule())
                }
                
                // Details Grid Section
                VStack(spacing: 14) {
                    DetailRow(icon: "person.fill", title: "Espécie", value: character.species)
                    DetailRow(icon: "figure.fill", title: "Gênero", value: character.gender)
                    if !character.type.isEmpty {
                        DetailRow(icon: "star.fill", title: "Tipo / Subespécie", value: character.type)
                    }
                    DetailRow(icon: "globe.americas.fill", title: "Origem", value: character.origin.name)
                    DetailRow(icon: "mappin.and.ellipse", title: "Localização Atual", value: character.location.name)
                    DetailRow(icon: "tv.fill", title: "Aparições em Episódios", value: "\(character.episode.count) episódios")
                }
                .padding(20)
                .background(Color.customSecondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 22))
            }
            .padding(20)
        }
        .background(Color.customSystemGroupedBackground)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

private struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.green)
                .frame(width: 36, height: 36)
                .background(Color.green.opacity(0.12), in: Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
    }
}
