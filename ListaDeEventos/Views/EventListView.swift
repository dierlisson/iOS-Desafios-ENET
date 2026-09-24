import SwiftUI

public struct EventListView: View {
    @Bindable var viewModel: EventsViewModel
    
    public init(viewModel: EventsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Horizontal Category Selector Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(EventCategory.allCases) { category in
                            CategoryChipView(
                                category: category,
                                isSelected: viewModel.selectedCategory == category
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    viewModel.selectedCategory = category
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(Color.customSystemBackground)
                
                Divider()
                
                // Content List / States
                ZStack {
                    Color.customSystemGroupedBackground
                        .ignoresSafeArea()
                    
                    if viewModel.isLoading {
                        ProgressView("Carregando eventos...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredEvents.isEmpty {
                        ContentUnavailableView {
                            Label("Nenhum Evento Encontrado", systemImage: "calendar.badge.exclamationmark")
                        } description: {
                            Text("Tente ajustar seus termos de busca ou mudar a categoria selecionada.")
                        } actions: {
                            Button("Limpar Filtros") {
                                withAnimation {
                                    viewModel.resetFilters()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                HStack {
                                    Text("\(viewModel.filteredEvents.count) \(viewModel.filteredEvents.count == 1 ? "evento encontrado" : "eventos encontrados")")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                                .padding(.horizontal, 4)
                                
                                ForEach(viewModel.filteredEvents) { event in
                                    NavigationLink(value: event) {
                                        EventCardView(
                                            event: event,
                                            isFavorite: viewModel.isFavorite(event),
                                            onToggleFavorite: {
                                                viewModel.toggleFavorite(for: event)
                                            }
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(16)
                        }
                    }
                }
            }
            .navigationTitle("Lista de Eventos")
            .navigationDestination(for: Event.self) { event in
                EventDetailView(
                    event: event,
                    isFavorite: viewModel.isFavorite(event),
                    onToggleFavorite: {
                        viewModel.toggleFavorite(for: event)
                    }
                )
            }
            .searchable(
                text: $viewModel.searchText,
                prompt: "Buscar por título, local ou palavra-chave..."
            )
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker("Ordenar por", selection: $viewModel.selectedSort) {
                            ForEach(SortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title3)
                    }
                }
            }
            .task {
                if viewModel.events.isEmpty {
                    await viewModel.loadEvents()
                }
            }
        }
    }
}

#Preview {
    EventListView(viewModel: EventsViewModel())
}
