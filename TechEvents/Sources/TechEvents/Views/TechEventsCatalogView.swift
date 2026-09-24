import SwiftUI

public struct TechEventsCatalogView: View {
    @Bindable public var viewModel: TechEventsViewModel
    
    public init(viewModel: TechEventsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                quickFilterBar
                    .padding(.vertical, 8)
                    .background(Color.appSystemGroupedBackground)
                
                Divider()
                
                Group {
                    if viewModel.isLoading {
                        ProgressView("Carregando eventos tech...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = viewModel.errorMessage {
                        ContentUnavailableView {
                            Label("Erro ao Carregar", systemImage: "wifi.exclamationmark")
                        } description: {
                            Text(error)
                        } actions: {
                            Button("Tentar Novamente") {
                                Task {
                                    await viewModel.loadEvents()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else if viewModel.filteredEvents.isEmpty {
                        ContentUnavailableView {
                            Label("Nenhum Evento Encontrado", systemImage: "calendar.badge.exclamationmark")
                        } description: {
                            if viewModel.filterState.isFilteringActive {
                                Text("Nenhum evento corresponde aos filtros selecionados.")
                            } else {
                                Text("Não há eventos cadastrados no momento.")
                            }
                        } actions: {
                            if viewModel.filterState.isFilteringActive {
                                Button("Limpar Filtros") {
                                    viewModel.resetFilters()
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.filteredEvents) { event in
                                    NavigationLink {
                                        TechEventDetailView(
                                            event: event,
                                            onToggleBookmark: {
                                                Task {
                                                    await viewModel.toggleBookmark(for: event)
                                                }
                                            }
                                        )
                                    } label: {
                                        TechEventCardView(
                                            event: event,
                                            onToggleBookmark: {
                                                Task {
                                                    await viewModel.toggleBookmark(for: event)
                                                }
                                            }
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .animation(.easeInOut(duration: 0.25), value: viewModel.filteredEvents)
                            .padding()
                        }
                        .refreshable {
                            await viewModel.loadEvents()
                        }
                    }
                }
            }
            .navigationTitle("TechEvents")
            .searchable(
                text: $viewModel.filterState.searchText,
                prompt: "Buscar evento, palestrante, cidade..."
            )
            .onChange(of: viewModel.filterState.searchText) { _, _ in
                viewModel.applyFilter()
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.isFilterSheetPresented = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                            if viewModel.filterState.activeFilterCount > 0 {
                                Text("\(viewModel.filterState.activeFilterCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(4)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.isFilterSheetPresented) {
                FilterSheetView(
                    filterState: $viewModel.filterState,
                    onApply: {
                        viewModel.applyFilter()
                    },
                    onReset: {
                        viewModel.resetFilters()
                    }
                )
            }
            .navigationDestination(item: $viewModel.selectedEvent) { event in
                TechEventDetailView(
                    event: event,
                    onToggleBookmark: {
                        Task {
                            await viewModel.toggleBookmark(for: event)
                        }
                    }
                )
            }
            .task {
                if viewModel.events.isEmpty {
                    await viewModel.loadEvents()
                }
                let args = ProcessInfo.processInfo.arguments
                if args.contains("-UITest_ShowFilter") {
                    viewModel.filterState.selectedFormat = .presencial
                    viewModel.filterState.onlyFree = true
                    viewModel.applyFilter()
                    try? await Task.sleep(nanoseconds: 400_000_000)
                    viewModel.isFilterSheetPresented = true
                } else if args.contains("-UITest_ShowDetail") {
                    if let first = viewModel.filteredEvents.first {
                        viewModel.selectedEvent = first
                    }
                }
            }
        }
    }
    
    private var quickFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "Gratuitos",
                    iconName: "tag.fill",
                    isSelected: viewModel.filterState.onlyFree
                ) {
                    viewModel.toggleFreeFilter()
                }
                
                FilterChip(
                    title: "Salvos",
                    iconName: "bookmark.fill",
                    isSelected: viewModel.filterState.onlyBookmarked
                ) {
                    viewModel.toggleBookmarkedFilter()
                }
                
                ForEach(EventFormat.allCases) { format in
                    FilterChip(
                        title: format.displayName,
                        iconName: format.iconName,
                        isSelected: viewModel.filterState.selectedFormat == format
                    ) {
                        viewModel.selectFormatFilter(format)
                    }
                }
                
                ForEach(EventModality.allCases) { modality in
                    FilterChip(
                        title: modality.displayName,
                        iconName: modality.iconName,
                        isSelected: viewModel.filterState.selectedModality == modality
                    ) {
                        viewModel.selectModalityFilter(modality)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct FilterChip: View {
    let title: String
    let iconName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: iconName)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color.appTertiarySystemGroupedBackground)
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.clear : Color.secondary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
