import SwiftUI

public struct CharacterListView: View {
    @Bindable var viewModel: CharactersViewModel
    @State private var showFiltersSheet: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    public init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filters Header Section
                VStack(alignment: .leading, spacing: 8) {
                    // Status Filter Scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                title: "Todos Status",
                                color: .blue,
                                isSelected: viewModel.selectedStatus == nil
                            ) {
                                viewModel.selectedStatus = nil
                            }
                            
                            ForEach(RMStatus.allCases) { status in
                                FilterChip(
                                    title: status.localizedName,
                                    color: status.color,
                                    isSelected: viewModel.selectedStatus == status
                                ) {
                                    viewModel.selectedStatus = status
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Gender Filter Scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                title: "Todos Gêneros",
                                color: .purple,
                                isSelected: viewModel.selectedGender == nil
                            ) {
                                viewModel.selectedGender = nil
                            }
                            
                            ForEach(RMGender.allCases) { gender in
                                FilterChip(
                                    title: gender.localizedName,
                                    color: gender.color,
                                    isSelected: viewModel.selectedGender == gender
                                ) {
                                    viewModel.selectedGender = gender
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 8)
                .background(Color.customSystemBackground)
                
                Divider()
                
                // Content States
                ZStack {
                    Color.customSystemGroupedBackground
                        .ignoresSafeArea()
                    
                    if viewModel.isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                            Text("Buscando no Multiverso...")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = viewModel.errorMessage {
                        ContentUnavailableView {
                            Label("Erro de Conexão", systemImage: "wifi.exclamationmark")
                        } description: {
                            Text(error)
                        } actions: {
                            Button("Tentar Novamente") {
                                Task {
                                    await viewModel.retry()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else if viewModel.characters.isEmpty {
                        ContentUnavailableView {
                            Label(
                                viewModel.showOnlyFavorites ? "Nenhum Favorito Encontrado" : "Nenhum Personagem Encontrado",
                                systemImage: viewModel.showOnlyFavorites ? "heart.slash.fill" : "person.slash.fill"
                            )
                        } description: {
                            Text(
                                viewModel.showOnlyFavorites
                                ? "Toque no ícone de coração nos cards para adicionar personagens aos favoritos."
                                : "Tente buscar por outro nome ou alterar os filtros de status e gênero."
                            )
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.characters) { character in
                                    NavigationLink(value: character) {
                                        CharacterCardView(character: character, favoritesManager: viewModel.favoritesManager)
                                    }
                                    .buttonStyle(.plain)
                                    .onAppear {
                                        if character == viewModel.characters.last {
                                            Task {
                                                await viewModel.loadNextPage()
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            
                            if viewModel.isLoadingNextPage {
                                ProgressView()
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Rick & Morty")
            .navigationDestination(for: RMCharacter.self) { character in
                CharacterDetailView(character: character, favoritesManager: viewModel.favoritesManager)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            viewModel.showOnlyFavorites.toggle()
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: viewModel.showOnlyFavorites ? "heart.fill" : "heart")
                                .foregroundStyle(viewModel.showOnlyFavorites ? Color.favoriteRed : .primary)
                        }
                    }
                }
            }
            .searchable(
                text: $viewModel.searchText,
                prompt: "Buscar personagem por nome..."
            )
            .task {
                await viewModel.loadInitialCharacters()
            }
        }
    }
}

private struct FilterChip: View {
    let title: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                Text(title)
                    .font(.caption.weight(isSelected ? .bold : .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? color.opacity(0.18) : Color.primary.opacity(0.05), in: Capsule())
            .foregroundStyle(isSelected ? color : .primary)
            .overlay(
                Capsule()
                    .strokeBorder(isSelected ? color : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CharacterListView(viewModel: CharactersViewModel())
}
