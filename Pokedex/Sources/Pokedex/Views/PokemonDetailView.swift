import SwiftUI

public struct PokemonDetailView: View {
    public let pokemon: Pokemon
    @Bindable public var viewModel: PokedexViewModel
    @Environment(\.dismiss) private var dismiss
    
    public init(pokemon: Pokemon, viewModel: PokedexViewModel) {
        self.pokemon = pokemon
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Header with Gradient & Artwork
                ZStack(alignment: .topLeading) {
                    LinearGradient(
                        colors: [
                            pokemon.primaryType.color,
                            pokemon.primaryType.color.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 280)
                    .clipShape(
                        UnevenRoundedRectangle(bottomLeadingRadius: 36, bottomTrailingRadius: 36)
                    )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(pokemon.displayName)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text(pokemon.formattedID)
                                .font(.title2.bold())
                                .foregroundColor(Color.white.opacity(0.85))
                        }
                        
                        HStack(spacing: 8) {
                            ForEach(pokemon.types) { type in
                                TypeBadgeView(type: type)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    // Center Hero Image
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            AsyncImage(url: URL(string: pokemon.imageUrl)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 190)
                                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 6)
                                case .failure:
                                    Image(systemName: "bolt.horizontal.fill")
                                        .font(.system(size: 80))
                                        .foregroundColor(.white.opacity(0.7))
                                        .frame(height: 190)
                                case .empty:
                                    ProgressView()
                                        .tint(.white)
                                        .frame(height: 190)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            Spacer()
                        }
                    }
                    .offset(y: 40)
                }
                
                Spacer().frame(height: 50)
                
                // Detailed Info Content
                VStack(spacing: 24) {
                    // Physical Attributes Card (Height & Weight)
                    HStack(spacing: 0) {
                        VStack(spacing: 6) {
                            Label("Altura", systemImage: "ruler.fill")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Text(pokemon.heightMetersText)
                                .font(.title3.bold())
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                            .frame(height: 40)
                        
                        VStack(spacing: 6) {
                            Label("Peso", systemImage: "scalemass.fill")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Text(pokemon.weightKilogramsText)
                                .font(.title3.bold())
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 16)
                    .background(Color.primary.opacity(0.04))
                    .cornerRadius(16)
                    
                    // Description / Species text if available
                    if let detail = viewModel.selectedPokemonDetail,
                       let desc = detail.speciesDescription, !desc.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sobre")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(desc)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Stats Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Atributos Base")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        if viewModel.isLoadingDetail {
                            ProgressView("Carregando atributos...")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 20)
                        } else if let detail = viewModel.selectedPokemonDetail {
                            VStack(spacing: 6) {
                                ForEach(detail.stats) { stat in
                                    StatBarView(stat: stat, typeColor: pokemon.primaryType.color)
                                }
                            }
                        }
                    }
                    
                    // Abilities Section
                    if let detail = viewModel.selectedPokemonDetail, !detail.abilities.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Habilidades")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 8) {
                                ForEach(detail.abilities, id: \.self) { ability in
                                    Text(ability)
                                        .font(.subheadline.bold())
                                        .foregroundColor(pokemon.primaryType.color)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 6)
                                        .background(pokemon.primaryType.color.opacity(0.12))
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
        }
        .ignoresSafeArea(edges: .top)
        .task {
            await viewModel.fetchDetail(for: pokemon)
        }
    }
}

