import SwiftUI

public struct CharacterListView: View {
    @Bindable var viewModel: CharactersViewModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    public init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Status Filters Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        StatusChip(
                            title: "Todos",
                            color: .blue,
                            isSelected: viewModel.selectedStatus == nil
                        ) {
                            viewModel.selectedStatus = nil
                        }
                        
                        ForEach(RMStatus.allCases) { status in
                            StatusChip(
                                title: status.localizedName,
                                color: status.color,
                                isSelected: viewModel.selectedStatus == status
                            ) {
                                viewModel.selectedStatus = status
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
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
                            Label("Nenhum Personagem Encontrado", systemImage: "person.slash.fill")
                        } description: {
                            Text("Tente buscar por outro nome ou alterar o filtro de status.")
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.characters) { character in
                                    NavigationLink(value: character) {
                                        CharacterCardView(character: character)
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
                CharacterDetailView(character: character)
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

private struct StatusChip: View {
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
                    .font(.subheadline.weight(isSelected ? .bold : .regular))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? color.opacity(0.2) : Color.primary.opacity(0.06), in: Capsule())
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
