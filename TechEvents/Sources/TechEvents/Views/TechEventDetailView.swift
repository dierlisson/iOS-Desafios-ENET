import SwiftUI

public struct TechEventDetailView: View {
    public let event: TechEvent
    public let onToggleBookmark: () -> Void
    
    @State private var isShowingRegistrationAlert = false
    @State private var isRegistered = false
    
    public init(event: TechEvent, onToggleBookmark: @escaping () -> Void) {
        self.event = event
        self.onToggleBookmark = onToggleBookmark
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack(alignment: .bottomLeading) {
                    if let bannerUrl = event.bannerUrl, let url = URL(string: bannerUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 220)
                                    .clipped()
                            default:
                                defaultHeaderBackground
                            }
                        }
                    } else {
                        defaultHeaderBackground
                    }
                    
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.75)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 220)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Label(event.format.displayName, systemImage: event.format.iconName)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(.white.opacity(0.25))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            
                            Text(event.modality.displayName)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(.white.opacity(0.25))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            
                            Spacer()
                        }
                        
                        Text(event.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(16)
                }
                .frame(height: 220)
                .clipped()
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Data e Horário")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(event.dateFormatted)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Investimento")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(event.priceText)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(event.isFree ? .green : .blue)
                        }
                    }
                    .padding()
                    .background(Color.appSecondarySystemBackground)
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Localização")
                            .font(.headline)
                        
                        Label(event.location, systemImage: "mappin.and.ellipse")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sobre o Evento")
                            .font(.headline)
                        
                        Text(event.fullDescription)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                    }
                    
                    Divider()
                    
                    if !event.speakers.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Palestrantes (\(event.speakers.count))")
                                .font(.headline)
                            
                            ForEach(event.speakers) { speaker in
                                HStack(spacing: 14) {
                                    if let avatarUrl = speaker.avatarUrl, let url = URL(string: avatarUrl) {
                                        AsyncImage(url: url) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 44, height: 44)
                                                    .clipShape(Circle())
                                            } else {
                                                speakerPlaceholder
                                            }
                                        }
                                    } else {
                                        speakerPlaceholder
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(speaker.name)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                        
                                        Text("\(speaker.role) @ \(speaker.company)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        if let bio = speaker.bio {
                                            Text(bio)
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                                .padding(.top, 2)
                                        }
                                    }
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.appTertiarySystemBackground)
                                .cornerRadius(10)
                            }
                        }
                        
                        Divider()
                    }
                    
                    if !event.schedule.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Programação")
                                .font(.headline)
                            
                            ForEach(event.schedule) { slot in
                                ScheduleSlotRowView(slot: slot)
                            }
                        }
                    }
                    
                    Button {
                        isShowingRegistrationAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Label(
                                isRegistered ? "Inscrição Confirmada ✓" : (event.isFree ? "Inscrever-se Gratuitamente" : "Garantir Ingresso"),
                                systemImage: isRegistered ? "checkmark.circle.fill" : "ticket.fill"
                            )
                            .fontWeight(.bold)
                            Spacer()
                        }
                        .padding()
                        .background(isRegistered ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(isRegistered)
                    .padding(.top, 10)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: onToggleBookmark) {
                    Image(systemName: event.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(event.isBookmarked ? .yellow : .primary)
                }
            }
        }
        .alert("Confirmação de Inscrição", isPresented: $isShowingRegistrationAlert) {
            Button("Confirmar") {
                isRegistered = true
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Deseja confirmar sua participação no evento \"\(event.title)\"?")
        }
    }
    
    private var defaultHeaderBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.9)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(height: 220)
    }
    
    private var speakerPlaceholder: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .frame(width: 44, height: 44)
            .foregroundColor(.blue.opacity(0.8))
    }
}
