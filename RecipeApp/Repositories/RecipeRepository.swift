import Foundation

/// Protocol defining the repository operations for recipes
protocol RecipeRepositoryProtocol {
    // Recipe operations
    func getCategories<T: Decodable>() async throws -> T
    func getMealsByCategory<T: Decodable>(category: String) async throws -> T
    func getMealsByIngredient<T: Decodable>(ingredient: String) async throws -> T
    func getMealDetails<T: Decodable>(id: String) async throws -> T
    func searchMeals<T: Decodable>(query: String) async throws -> T
    func getRandomMeal<T: Decodable>() async throws -> T
    func getIngredientsList<T: Decodable>() async throws -> T
}

/// Implementation of the recipe repository
final class RecipeRepository: RecipeRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - Recipe Operations
    
    func getCategories<T: Decodable>() async throws -> T {
        return try await apiClient.getCategories()
    }
    
    func getMealsByCategory<T: Decodable>(category: String) async throws -> T {
        return try await apiClient.getMealsByCategory(category: category)
    }
    
    func getMealsByIngredient<T: Decodable>(ingredient: String) async throws -> T {
        return try await apiClient.getMealsByIngredient(ingredient: ingredient)
    }
    
    func getMealDetails<T: Decodable>(id: String) async throws -> T {
        return try await apiClient.getMealDetails(id: id)
    }
    
    func searchMeals<T: Decodable>(query: String) async throws -> T {
        return try await apiClient.searchMeals(query: query)
    }
    
    func getRandomMeal<T: Decodable>() async throws -> T {
        return try await apiClient.getRandomMeal()
    }
    
    func getIngredientsList<T: Decodable>() async throws -> T {
        return try await apiClient.getIngredientsList()
    }
}

