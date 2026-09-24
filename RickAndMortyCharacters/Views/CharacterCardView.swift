import SwiftUI

public struct CharacterCardView: View {
    public let character: RMCharacter
    
    public init(character: RMCharacter) {
        self.character = character
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Character Image
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
