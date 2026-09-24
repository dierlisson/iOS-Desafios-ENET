import SwiftUI

public struct EventCardView: View {
    public let event: Event
    public let isFavorite: Bool
    public let onToggleFavorite: () -> Void
    
    public init(event: Event, isFavorite: Bool, onToggleFavorite: @escaping () -> Void) {
        self.event = event
        self.isFavorite = isFavorite
        self.onToggleFavorite = onToggleFavorite
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header: Icon Banner & Badges
            HStack(alignment: .top) {
                HStack(spacing: 10) {
                    Image(systemName: event.iconName)
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 48, height: 48)
                        .background(
                            LinearGradient(
                                colors: [.blue, .indigo],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.category.rawValue)
                            .font(.caption.bold())
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.blue.opacity(0.12), in: Capsule())
                        
                        Text(event.price)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundStyle(isFavorite ? .red : .secondary)
                        .padding(8)
                        .background(Color.primary.opacity(0.04), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isFavorite ? "Remover dos favoritos" : "Adicionar aos favoritos")
            }
            
            // Event Details
            VStack(alignment: .leading, spacing: 6) {
                Text(event.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                Text(event.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Divider()
            
            // Footer Info: Date & Location
            HStack(spacing: 12) {
                HStack(spacing: 5) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundStyle(.blue)
                    Text(event.date.formattedEventDate)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if let relativeBadge = event.date.relativeBadgeText {
                        Text(relativeBadge)
                            .font(.caption2.bold())
                            .foregroundStyle(relativeBadge == "Hoje" ? Color.green : Color.orange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                (relativeBadge == "Hoje" ? Color.green : Color.orange).opacity(0.15),
                                in: Capsule()
                            )
                    }
                }
                
                Spacer()
                
                HStack(spacing: 5) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(.red)
                    Text(event.location)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(16)
        .background(Color.customSecondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
    }
}

#Preview {
    EventCardView(
        event: EventService.sampleEvents[0],
        isFavorite: true,
        onToggleFavorite: {}
    )
    .padding()
}
