import SwiftUI

public struct TechEventCardView: View {
    public let event: TechEvent
    public let onToggleBookmark: () -> Void
    
    public init(event: TechEvent, onToggleBookmark: @escaping () -> Void) {
        self.event = event
        self.onToggleBookmark = onToggleBookmark
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                HStack(spacing: 8) {
                    Label(event.format.displayName, systemImage: event.format.iconName)
                        .font(.caption.bold())
                        .foregroundColor(event.format.color)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(event.format.color.opacity(0.12))
                        .cornerRadius(12)
                    
                    Label(event.modality.displayName, systemImage: event.modality.iconName)
                        .font(.caption.bold())
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.primary.opacity(0.06))
                        .cornerRadius(12)
                }
                
                Spacer()
                
                Button(action: onToggleBookmark) {
                    Image(systemName: event.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.title3)
                        .foregroundColor(event.isBookmarked ? .yellow : .secondary)
                        .padding(8)
                        .background(Color.primary.opacity(0.04))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(event.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Divider()
            
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text(event.dateFormatted)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(event.priceText)
                    .font(.caption.bold())
                    .foregroundColor(event.isFree ? .green : .primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(event.isFree ? Color.green.opacity(0.12) : Color.primary.opacity(0.06))
                    .cornerRadius(6)
            }
        }
        .padding(16)
        .background(Color.appSecondarySystemGroupedBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}
