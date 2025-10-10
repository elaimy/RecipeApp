import Foundation
import SwiftUI

/// Shared favorites store with persistence
final class FavoritesStore: ObservableObject {
    @Published private(set) var favoriteIDs: Set<String> = []
    @Published var favoriteMeals: [MealDetailDTO] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaultsKey = "com.recipeapp.favorites"
    private let repository: RecipeRepositoryProtocol
    private var mealsCache: [String: MealDetailDTO] = [:]
    
    init(repository: RecipeRepositoryProtocol) {
        self.repository = repository
        loadFavoritesFromStorage()
    }
    
    // MARK: - Favorites Management
    
    func isFavorite(_ mealId: String) -> Bool {
        favoriteIDs.contains(mealId)
    }
    
    @MainActor
    func toggleFavorite(_ mealId: String) {
        if favoriteIDs.contains(mealId) {
            removeFavorite(mealId)
        } else {
            addFavorite(mealId)
        }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        saveFavoritesToStorage()
    }
    
    @MainActor
    private func addFavorite(_ mealId: String) {
        favoriteIDs.insert(mealId)
    }
    
    @MainActor
    private func removeFavorite(_ mealId: String) {
        favoriteIDs.remove(mealId)
        favoriteMeals.removeAll { $0.idMeal == mealId }
        mealsCache.removeValue(forKey: mealId)
    }
    
    // MARK: - Persistence
    
    private func loadFavoritesFromStorage() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            favoriteIDs = Set(ids)
        }
    }
    
    private func saveFavoritesToStorage() {
        let idsArray = Array(favoriteIDs)
        if let data = try? JSONEncoder().encode(idsArray) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    // MARK: - Fetch Favorite Meals
    
    @MainActor
    func loadFavoriteMeals() async {
        guard !favoriteIDs.isEmpty else {
            favoriteMeals = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Check cache first
        let cachedMeals = favoriteIDs.compactMap { mealsCache[$0] }
        if cachedMeals.count == favoriteIDs.count {
            favoriteMeals = cachedMeals
            isLoading = false
            return
        }
        
        // Fetch details for all favorites in parallel
        await withTaskGroup(of: (String, MealDetailDTO?).self) { group in
            for mealId in favoriteIDs {
                // Skip if already cached
                if mealsCache[mealId] != nil {
                    continue
                }
                
                group.addTask { [weak self] in
                    guard let self = self else { return (mealId, nil) }
                    do {
                        let response: DetailResponse = try await self.repository.getMealDetails(id: mealId)
                        return (mealId, response.meals?.first)
                    } catch {
                        return (mealId, nil)
                    }
                }
            }
            
            for await (mealId, meal) in group {
                if let meal = meal {
                    mealsCache[mealId] = meal
                }
            }
        }
        
        // Update the list with cached meals
        favoriteMeals = favoriteIDs.compactMap { mealsCache[$0] }
        isLoading = false
    }
    
    @MainActor
    func retryLoadFavorites() async {
        await loadFavoriteMeals()
    }
    
    // MARK: - Cache Management
    
    func clearCache() {
        mealsCache.removeAll()
    }
}

