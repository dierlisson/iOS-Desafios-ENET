import SwiftUI

public struct PokedexListView: View {
    @State public var viewModel = PokedexViewModel()
    @State private var selectedPokemon: Pokemon? = nil
    
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    public init(viewModel: PokedexViewModel = PokedexViewModel()) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Type Filter Chips Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // "Todos" chip
                        Button(action: {
                            viewModel.selectTypeFilter(nil)
                        }) {
                            Text("Todos")
                                .font(.subheadline.bold())
                                .foregroundColor(viewModel.selectedType == nil ? .white : .primary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(viewModel.selectedType == nil ? Color.blue : Color.primary.opacity(0.08))
                                .cornerRadius(20)
                        }
                        
                        ForEach(PokemonType.allCases) { type in
                            Button(action: {
                                viewModel.selectTypeFilter(type)
                            }) {
                                HStack(spacing: 5) {
                                    Image(systemName: type.iconName)
                                        .font(.caption.bold())
                                    Text(type.displayName)
                                        .font(.subheadline.bold())
                                }
                                .foregroundColor(viewModel.selectedType == type ? .white : .primary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(viewModel.selectedType == type ? type.color : Color.primary.opacity(0.08))
                                .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
                .background(Color.appSystemGroupedBackground)
                
                Divider()
                
                // Content States (Loading, Error, Empty, List)
                ZStack {
                    Color.appSystemGroupedBackground
                        .ignoresSafeArea()
                    
                    if viewModel.isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.3)
                            Text("Carregando Pokédex...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    } else if let errorMsg = viewModel.errorMessage, viewModel.pokemons.isEmpty {
                        ContentUnavailableView {
                            Label("Erro de Conexão", systemImage: "wifi.slash")
                        } description: {
                            Text(errorMsg)
                        } actions: {
                            Button("Tentar Novamente") {
                                Task {
                                    await viewModel.loadInitialPokemons()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else if viewModel.filteredPokemons.isEmpty {
                        ContentUnavailableView {
                            Label("Nenhum Pokémon Encontrado", systemImage: "magnifyingglass")
                        } description: {
                            Text("Tente buscar por outro nome, ID ou selecione outra categoria.")
                        } actions: {
                            Button("Limpar Filtros") {
                                viewModel.clearFilters()
                            }
                            .buttonStyle(.bordered)
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 14) {
                                ForEach(viewModel.filteredPokemons) { pokemon in
                                    Button(action: {
                                        selectedPokemon = pokemon
                                    }) {
                                        PokemonCardView(pokemon: pokemon)
                                    }
                                    .buttonStyle(.plain)
                                    .onAppear {
                                        Task {
                                            await viewModel.loadNextPageIfNeeded(currentPokemon: pokemon)
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            
                            // Bottom Pagination Loader
                            if viewModel.isLoadingMore {
                                HStack(spacing: 10) {
                                    ProgressView()
                                    Text("Carregando mais pokémons...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 16)
                            }
                        }
                        .refreshable {
                            await viewModel.loadInitialPokemons()
                        }
                    }
                }
            }
            .navigationTitle("Pokédex")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .searchable(text: $viewModel.searchText, prompt: "Buscar por nome ou ID (#001)...")
            .navigationDestination(item: $selectedPokemon) { pokemon in
                PokemonDetailView(pokemon: pokemon, viewModel: viewModel)
            }
            .task {
                let args = ProcessInfo.processInfo.arguments
                if args.contains("--detail-bulbasaur") {
                    selectedPokemon = MockPokedexData.bulbasaur
                } else if args.contains("--detail-pikachu") {
                    selectedPokemon = MockPokedexData.pikachu
                } else if args.contains("--filter-fogo") {
                    viewModel.selectTypeFilter(.fire)
                }
                
                if viewModel.pokemons.isEmpty {
                    await viewModel.loadInitialPokemons()
                }
            }
        }
    }
}



#Preview {
    let mockVM = PokedexViewModel(service: MockPokedexService())
    return PokedexListView(viewModel: mockVM)
}



