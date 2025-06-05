import Foundation

/// Protocol for API client operations specific to the Recipe domain
protocol APIClientProtocol {
    // Generic fetch method for any endpoint
    func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T
    
    // Recipe operations
    func getRandomRecipes<T: Decodable>(number: Int) async throws -> T
    func getRecipeInformation<T: Decodable>(id: Int) async throws -> T
    func searchRecipes<T: Decodable>(query: String, number: Int) async throws -> T
    func complexSearch<T: Decodable>(query: String, cuisine: String?, diet: String?, intolerances: String?, number: Int) async throws -> T
    
    // Category operations
    func getCuisines<T: Decodable>() async throws -> T
    func getDiets<T: Decodable>() async throws -> T
    func getMealTypes<T: Decodable>() async throws -> T
    func getDishTypes<T: Decodable>() async throws -> T
    
    // Other operations
    func getSimilarRecipes<T: Decodable>(id: Int, number: Int) async throws -> T
    func getRecipesByIngredients<T: Decodable>(ingredients: String, number: Int) async throws -> T
    func getRecipesByNutrients<T: Decodable>(minCarbs: Int?, maxCarbs: Int?, number: Int) async throws -> T
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
    
    func getRandomRecipes<T: Decodable>(number: Int = 10) async throws -> T {
        return try await fetch(endpoint: .randomRecipes(number: number))
    }
    
    func getRecipeInformation<T: Decodable>(id: Int) async throws -> T {
        return try await fetch(endpoint: .recipeInformation(id: id))
    }
    
    func searchRecipes<T: Decodable>(query: String, number: Int = 10) async throws -> T {
        return try await fetch(endpoint: .searchRecipes(query: query, number: number))
    }
    
    func complexSearch<T: Decodable>(query: String, cuisine: String? = nil, diet: String? = nil, intolerances: String? = nil, number: Int = 10) async throws -> T {
        return try await fetch(endpoint: .complexSearch(query: query, cuisine: cuisine, diet: diet, intolerances: intolerances, number: number))
    }
    
    // MARK: - Category Operations
    
    func getCuisines<T: Decodable>() async throws -> T {
        return try await fetch(endpoint: .cuisines)
    }
    
    func getDiets<T: Decodable>() async throws -> T {
        return try await fetch(endpoint: .diets)
    }
    
    func getMealTypes<T: Decodable>() async throws -> T {
        return try await fetch(endpoint: .mealTypes)
    }
    
    func getDishTypes<T: Decodable>() async throws -> T {
        return try await fetch(endpoint: .dishTypes)
    }
    
    // MARK: - Other Operations
    
    func getSimilarRecipes<T: Decodable>(id: Int, number: Int = 5) async throws -> T {
        return try await fetch(endpoint: .similarRecipes(id: id, number: number))
    }
    
    func getRecipesByIngredients<T: Decodable>(ingredients: String, number: Int = 10) async throws -> T {
        return try await fetch(endpoint: .recipesByIngredients(ingredients: ingredients, number: number))
    }
    
    func getRecipesByNutrients<T: Decodable>(minCarbs: Int? = nil, maxCarbs: Int? = nil, number: Int = 10) async throws -> T {
        return try await fetch(endpoint: .recipesByNutrients(minCarbs: minCarbs, maxCarbs: maxCarbs, number: number))
    }
} 