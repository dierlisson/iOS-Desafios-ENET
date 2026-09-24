import SwiftUI

public struct EventDetailView: View {
    public let event: Event
    public let isFavorite: Bool
    public let onToggleFavorite: () -> Void
    
    @State private var isRegistering: Bool = false
    @State private var isRegistered: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    public init(event: Event, isFavorite: Bool, onToggleFavorite: @escaping () -> Void) {
        self.event = event
        self.isFavorite = isFavorite
        self.onToggleFavorite = onToggleFavorite
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Banner Header
                ZStack(alignment: .topTrailing) {
                    VStack {
                        Image(systemName: event.iconName)
                            .font(.system(size: 64))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .indigo, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    
                    Button(action: onToggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundStyle(isFavorite ? .red : .white)
                            .padding(12)
                            .background(.thinMaterial, in: Circle())
                    }
                    .padding(16)
                }
                
                // Badges & Title
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Text(event.category.rawValue)
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue, in: Capsule())
                        
                        Text(event.price)
                            .font(.caption.bold())
                            .foregroundStyle(.green)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.green.opacity(0.15), in: Capsule())
                        
                        Spacer()
                    }
                    
                    Text(event.title)
                        .font(.title2.bold())
                        .foregroundStyle(.primary)
                    
                    Text(event.subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                // Event Info Grid: Date, Location, Organizer
                VStack(spacing: 16) {
                    InfoRow(
                        icon: "calendar",
                        iconColor: .blue,
                        title: "Data e Horário",
                        subtitle: event.date.formattedEventDate
                    )
                    
                    InfoRow(
                        icon: "mappin.and.ellipse",
                        iconColor: .red,
                        title: "Localização",
                        subtitle: "\(event.location) • \(event.address)"
                    )
                    
                    InfoRow(
                        icon: "person.crop.circle.badge.checkmark",
                        iconColor: .purple,
                        title: "Organização",
                        subtitle: event.organizer
                    )
                    
                    InfoRow(
                        icon: "person.3.fill",
                        iconColor: .orange,
                        title: "Vagas & Participantes",
                        subtitle: "\(event.attendeesCount) inscritos / \(event.maxCapacity) vagas totais"
                    )
                }
                .padding(16)
                .background(Color.customSecondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 18))
                
                // Description Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sobre o Evento")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(event.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                }
                
                // Action Button
                VStack(spacing: 12) {
                    Button {
                        isRegistering = true
                        Task {
                            try? await Task.sleep(nanoseconds: 800_000_000)
                            isRegistering = false
                            isRegistered = true
                        }
                    } label: {
                        HStack {
                            if isRegistering {
                                ProgressView()
                                    .tint(.white)
                                Text("Inscrevendo...")
                            } else if isRegistered {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Inscrição Confirmada!")
                            } else {
                                Image(systemName: "ticket.fill")
                                Text("Garantir Minha Vaga")
                            }
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isRegistered ? Color.green : Color.blue, in: RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(isRegistering || isRegistered)
                    
                    if isRegistered {
                        Text("Sua vaga está garantida! Um e-mail de confirmação foi enviado.")
                            .font(.caption)
                            .foregroundStyle(.green)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 12)
            }
            .padding(20)
        }
        .background(Color.customSystemGroupedBackground)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

private struct InfoRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.12), in: Circle())
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        EventDetailView(
            event: EventService.sampleEvents[0],
            isFavorite: false,
            onToggleFavorite: {}
        )
    }
}
