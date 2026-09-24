import SwiftUI

public struct ScheduleSlotRowView: View {
    public let slot: ScheduleSlot
    
    public init(slot: ScheduleSlot) {
        self.slot = slot
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 2) {
                Text(slot.startTime)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(slot.endTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 55, alignment: .leading)
            
            Rectangle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 3)
                .cornerRadius(1.5)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(slot.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let description = slot.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack(spacing: 12) {
                    if let room = slot.room {
                        Label(room, systemImage: "mappin.and.ellipse")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    if let speaker = slot.speaker {
                        Label(speaker.name, systemImage: "person.fill")
                            .font(.caption)
                            .foregroundColor(.purple)
                    }
                }
                .padding(.top, 2)
            }
            .padding(.vertical, 4)
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.appSecondarySystemBackground.opacity(0.5))
        .cornerRadius(10)
    }
}
