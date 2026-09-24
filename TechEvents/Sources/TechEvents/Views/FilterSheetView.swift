import SwiftUI

public struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding public var filterState: CompositeFilterState
    public let onApply: () -> Void
    public let onReset: () -> Void
    
    public init(
        filterState: Binding<CompositeFilterState>,
        onApply: @escaping () -> Void,
        onReset: @escaping () -> Void
    ) {
        self._filterState = filterState
        self.onApply = onApply
        self.onReset = onReset
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("Formato do Evento") {
                    Picker("Formato", selection: $filterState.selectedFormat) {
                        Text("Todos").tag(EventFormat?.none)
                        ForEach(EventFormat.allCases) { format in
                            Label(format.displayName, systemImage: format.iconName)
                                .tag(EventFormat?.some(format))
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Modalidade") {
                    Picker("Modalidade", selection: $filterState.selectedModality) {
                        Text("Todas").tag(EventModality?.none)
                        ForEach(EventModality.allCases) { modality in
                            Label(modality.displayName, systemImage: modality.iconName)
                                .tag(EventModality?.some(modality))
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Filtros Especiais") {
                    Toggle("Apenas Gratuitos", isOn: $filterState.onlyFree)
                    Toggle("Apenas Salvos (Bookmarks)", isOn: $filterState.onlyBookmarked)
                }
                
                Section {
                    Button(role: .destructive) {
                        onReset()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Limpar Todos os Filtros")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Filtros de Eventos")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Aplicar") {
                        onApply()
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}
