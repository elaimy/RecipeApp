import Foundation

/// Protocol for API client operations specific to the Recipe domain
protocol APIClientProtocol {
    // Generic fetch method for any endpoint
    func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T
    
    // Recipe operations
    func getCategories<T: Decodable>() async throws -> T
    func getMealsByCategory<T: Decodable>(category: String) async throws -> T
    func getMealsByIngredient<T: Decodable>(ingredient: String) async throws -> T
    func getMealDetails<T: Decodable>(id: String) async throws -> T
    func searchMeals<T: Decodable>(query: String) async throws -> T
    func getRandomMeal<T: Decodable>() async throws -> T
    func getIngredientsList<T: Decodable>() async throws -> T
}

/// Implementation of the API client using the network service
final class APIClient: APIClientProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        return try await networkService.request(endpoint: endpoint, method: .get, body: nil)
    }
    
    // MARK: - Recipe Operations
    
    func getCategories<T: Decodable>() async throws -> T {
        return try await fetch(endpoint: .categories)
    }
    
    func getMealsByCategory<T: Decodable>(category: String) async throws -> T {
        return try await fetch(endpoint: .mealsByCategory(category: category))
    }
    
    func getMealsByIngredient<T: Decodable>(ingredient: String) async throws -> T {
        return try await fetch(endpoint: .mealsByIngredient(ingredient: ingredient))
    }
    
    func getMealDetails<T: Decodable>(id: String) async throws -> T {
        return try await fetch(endpoint: .mealDetails(id: id))
    }
    
    func searchMeals<T: Decodable>(query: String) async throws -> T {
        return try await fetch(endpoint: .searchMeals(query: query))
    }
    
    func getRandomMeal<T: Decodable>() async throws -> T {
        return try await fetch(endpoint: .randomMeal)
    }
    
    func getIngredientsList<T: Decodable>() async throws -> T {
        return try await fetch(endpoint: .ingredientsList)
    }
}

