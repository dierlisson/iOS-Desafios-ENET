import Foundation
import Observation

@Observable
public final class FavoritesManager {
    public static let shared = FavoritesManager()
    
    public private(set) var favoriteIDs: Set<Int> = []
    private let userDefaultsKey = "RickAndMortyFavoriteIDs"
    
    public init() {
        loadFavorites()
    }
    
    public func isFavorite(_ characterID: Int) -> Bool {
        favoriteIDs.contains(characterID)
    }
    
    public func toggleFavorite(_ characterID: Int) {
        if favoriteIDs.contains(characterID) {
            favoriteIDs.remove(characterID)
        } else {
            favoriteIDs.insert(characterID)
        }
        saveFavorites()
    }
    
    private func loadFavorites() {
        if let savedArray = UserDefaults.standard.array(forKey: userDefaultsKey) as? [Int] {
            favoriteIDs = Set(savedArray)
        }
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: userDefaultsKey)
    }
}
