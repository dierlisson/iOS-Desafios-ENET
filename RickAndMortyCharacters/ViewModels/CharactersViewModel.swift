import Foundation
import SwiftUI
import Observation

@Observable
public final class CharactersViewModel {
    public var characters: [RMCharacter] = []
    public var searchText: String = "" {
        didSet {
            triggerSearchDebounce()
        }
    }
    public var selectedStatus: RMStatus? = nil {
        didSet {
            Task { @MainActor in
                await resetAndLoad()
            }
        }
    }
    
    public var isLoading: Bool = false
    public var isLoadingNextPage: Bool = false
    public var errorMessage: String? = nil
    public var currentPage: Int = 1
    public var hasNextPage: Bool = true
    
    private let service: RickAndMortyServiceProtocol
    private var searchTask: Task<Void, Never>?
    
    public init(service: RickAndMortyServiceProtocol = RickAndMortyService()) {
        self.service = service
    }
    
    @MainActor
    public func loadInitialCharacters() async {
        guard characters.isEmpty else { return }
        await resetAndLoad()
    }
    
    @MainActor
    public func resetAndLoad() async {
        searchTask?.cancel()
        currentPage = 1
        hasNextPage = true
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await service.fetchCharacters(
                name: searchText.isEmpty ? nil : searchText,
                status: selectedStatus,
                page: 1
            )
            characters = result.characters
            hasNextPage = result.hasNextPage
        } catch {
            errorMessage = error.localizedDescription
            characters = []
        }
        
        isLoading = false
    }
    
    @MainActor
    public func loadNextPage() async {
        guard !isLoading, !isLoadingNextPage, hasNextPage else { return }
        
        isLoadingNextPage = true
        let nextPage = currentPage + 1
        
        do {
            let result = try await service.fetchCharacters(
                name: searchText.isEmpty ? nil : searchText,
                status: selectedStatus,
                page: nextPage
            )
            currentPage = nextPage
            characters.append(contentsOf: result.characters)
            hasNextPage = result.hasNextPage
        } catch {
            // Silently retain current characters if pagination fails
        }
        
        isLoadingNextPage = false
    }
    
    @MainActor
    public func retry() async {
        await resetAndLoad()
    }
    
    private func triggerSearchDebounce() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000) // 400ms debounce
            if !Task.isCancelled {
                await resetAndLoad()
            }
        }
    }
}
